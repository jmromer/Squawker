class SquawkBox extends React.Component {
  constructor(props) {
    super(props)

    this.state = {
      candidates: [],
      cursorPosition: null,
      color: "black",
      isFiltering: false,
      numLines: 1,
      remainingChars: "",
      users: null,
      searchSeed: null
    }

    // Key codes
    this.KEYS = {
      at: 50,
      return: 13,
      k: 75,
      p: 80,
      n: 78,
      j: 74,
      up: 38,
      down: 40,
      comma: 188,
      space: 32,
      colon: 186,
      wordBreaks: [this.comma, this.space, this.colon]
    }
  }

  // Render text area with Suggestions child component
  render() {
    return (
      <field style={{position: "relative", display: "block"}}>
        <textarea cols="30"
                  className="squawk-form-content"
                  name="squawk[content]"
                  placeholder="sing the song of yourself"
                  onBlur={this.handleBlur.bind(this)}
                  onFocus={this.handleFocus.bind(this)}
                  onKeyDown={this.handleKeyDown.bind(this)}
                  onKeyUp={this.handleKeyUp.bind(this)}>
        </textarea>

        <div className="squawk-form-countdown"
             style={{color: this.state.color}}>
          {this.state.remainingChars}
        </div>

        <Suggestions
          list={this.state.candidates}
          numLines={this.state.numLines}
          handleSuggestionClick={this.handleSuggestionClick.bind(this)} />
      </field>
    )
  }

  // Event Handlers
  handleBlur(event) {
    this.clearCountdown(event)
  }

  handleFocus(event) {
    this.updateCountdown(event)
  }

  handleKeyUp(event) {
    this.filterSuggestedAtMentions(event)
    this.updateCountdown(event)
  }

  handleKeyDown(event) {
    this.updateCountdown(event)

    const textarea = event.target
    const cmdOrCtrl = event.metaKey || event.ctrlKey

    // if at-sign typed, query for user data and begin filtering
    if (event.keyCode === this.KEYS.at) {
      if (this.state.users) {
        this.beginFiltering(textarea)
      } else {
        $.getJSON("/usernames", (users) => {
          this.setState({ users })
          this.beginFiltering(textarea)
        })
      }
    }

    // cmd+enter or ctrl+enter to submit the form
    if (cmdOrCtrl && event.keyCode == this.KEYS.return) {
      return this.submitForm(event)
    }

    // if not filtering, begin filtering
    if (!this.state.isFiltering) {
      return this.filterSuggestedAtMentions(event)
    }

    // store the current cursor position (+1 for mobile, for some reason)
    this.setState({ cursorPosition: textarea.selectionEnd + 1 })

    if (event.keyCode === this.KEYS.return) {
      event.preventDefault()
      this.completeSelectedSuggestion(textarea)
    }

    if (this.isNavigationUp(event)) {
      event.preventDefault()
      return this.navigate({ direction: "up", event: event })
    }

    if (this.isNavigationDown(event)) {
      event.preventDefault()
      return this.navigate({ direction: "down", event: event })
    }

    // terminate suggestion mode on specific word break chars
    if (this.isWordBreak(event)) {
      return this.endFiltering()
    }
  }

  handleSuggestionClick(selectedItem) {
    const squawkForm = document.getElementById("js-squawk-form")
    const textarea = squawkForm.getElementsByTagName("textarea")[0]
    this.completeSelectedSuggestion(textarea, selectedItem)
  }

  // Form submission
  // ===============
  submitForm(event) {
    event.preventDefault()
    const squawkForm = document.getElementById("js-squawk-form")
    $(squawkForm).submit()
  }

  // Countdown methods
  // ==================
  updateCountdown(event) {
    const maxChars = 160
    const currentLength = event.target.value.length
    const remainingChars = maxChars - currentLength
    const color = (remainingChars <= 10) ? "red" : "black"

    if (remainingChars === maxChars) {
      this.clearCountdown()
    } else {
      this.setState({remainingChars: remainingChars, color: color})
    }

    // set approx number of lines entered for Suggestions prop
    this.setState({numLines: Math.ceil(currentLength / 37)})
  }

  clearCountdown() {
    this.setState({remainingChars: ""})
  }

  // Navigation methods
  // ==================
  // Event -> Boolean
  isNavigationUp(event) {
    const key = event.keyCode || event.which
    const upKeys = (key === this.KEYS.p || key === this.KEYS.k)

    return key === this.KEYS.up || event.ctrlKey && upKeys
  }

  // Event -> Boolean
  isNavigationDown(event) {
    const key = event.keyCode || event.which
    const downKeys = (key === this.KEYS.n || key == this.KEYS.j)

    return key === this.KEYS.down || event.ctrlKey && downKeys
  }

  isWordBreak(event) {
    const key = event.keyCode || event.which
    this.KEYS.wordBreaks.includes(key)
  }

  navigate({ direction, event }) {
    const field = event.target.parentElement
    const selectedItem = field.getElementsByClassName("suggestion-focus")[0]

    const allItems = field.getElementsByTagName("li")
    const itemsArray = Array.from(allItems)

    if (direction === "up") {
      this.navigateUp(selectedItem, itemsArray)
    } else {
      this.navigateDown(selectedItem, itemsArray)
    }
  }

  navigateUp(selectedItem, itemsArray) {
    if (!selectedItem) { return }
    const prevItemNum = parseInt(selectedItem.dataset.itemNumber, 10) - 1
    const prevItem = itemsArray.filter(e => e.dataset.itemNumber == prevItemNum)[0]

    if (!prevItem) { return }
    itemsArray.forEach(e => e.classList.remove("suggestion-focus"))
    prevItem.classList.add("suggestion-focus")
  }

  navigateDown(selectedItem, itemsArray) {
    if (!selectedItem) {
      const firstSuggestion = itemsArray[0]
      if (!firstSuggestion) { return }
      firstSuggestion.classList.add("suggestion-focus")
      return
    }

    const nextItemNum = parseInt(selectedItem.dataset.itemNumber, 10) + 1
    const nextItem = itemsArray.filter(e => e.dataset.itemNumber == nextItemNum)[0]

    if (!nextItem) { return }
    itemsArray.forEach(e => e.classList.remove("suggestion-focus"))
    nextItem.classList.add("suggestion-focus")
  }

  // Suggester Methods
  filterSuggestedAtMentions(event) {
    // if we're not in filtering mode, no-op
    if (!this.state.isFiltering) { return }

    const textarea = event.target
    const currVal = textarea.value
    const currPosn = textarea.selectionEnd
    const slice = currVal.slice(0, currPosn)
    const match = slice.match(/@(\w+)$/)

    // once we delete the '@', cancel filtering
    if (!match) {
      return this.setState({ candidates: [] })
    }

    const seed = match[1]
    this.setState({searchSeed: seed})
    const seedRegex = new RegExp(seed, "i")

    const candidates = this.state.users.reduce((acc, [index, user]) => {
      if (index.match(seedRegex)) { acc.push(user) }
      return acc
    }, [])

    this.setState({ candidates: candidates })
  }

  completeSelectedSuggestion(textarea, selectedItem) {
    const field = textarea.parentElement
    const allItems = field.getElementsByTagName("li")
    selectedItem = selectedItem ||
                   field.getElementsByClassName("suggestion-focus")[0]

    if (!selectedItem) { return this.endFiltering() }

    const handle = selectedItem.getElementsByClassName("suggestion-username")[0]
    const currVal = textarea.value
    const originalPosn = this.state.cursorPosition

    const strToRemove = "@" + this.state.searchSeed
    const selectedHandle = "@" + handle.textContent
    textarea.value = textarea.value.replace(strToRemove, selectedHandle)

    const newPosn = originalPosn - strToRemove.length + selectedHandle.length
    textarea.setSelectionRange(newPosn, newPosn)

    this.endFiltering()
  }

  beginFiltering(textarea) {
    const curr = textarea.selectionEnd
    this.setState({ cursorPosition: curr, isFiltering: true })
  }

  endFiltering() {
    this.setState({ candidates: [], cursorPosition: null, isFiltering: false })
  }
}
