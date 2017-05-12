class SquawkBox extends React.Component {
  constructor(props) {
    super(props)

    this.state = {
      candidates: [],
      cursorPosition: null,
      color: "black",
      filtering: false,
      numLines: 1,
      remainingChars: "",
      users: null,
      searchSeed: null,
      squawkForm: null
    }

    this.handleBlur = this.handleBlur.bind(this)
    this.handleFocus = this.handleFocus.bind(this)
    this.handleKeyDown = this.handleKeyDown.bind(this)
    this.handleKeyUp = this.handleKeyUp.bind(this)
    this.handleSuggestionClick = this.handleSuggestionClick.bind(this)
  }

  componentDidMount() {
    let squawkForm = document.getElementById("js-squawk-form")
    squawkForm.addEventListener("suggestion:click", this.handleSuggestionClick)
    this.state.squawkForm = squawkForm
  }

  // Render text area with Suggestions child component
  render() {
    return (
      <field style={{position: "relative", display: "block"}}>
        <textarea cols="30"
                  className="squawk-form-content"
                  name="squawk[content]"
                  placeholder="sing the song of yourself"
                  onBlur={this.handleBlur}
                  onFocus={this.handleFocus}
                  onKeyDown={this.handleKeyDown}
                  onKeyUp={this.handleKeyUp}>
        </textarea>

        <div className="squawk-form-countdown"
             style={{color: this.state.color}}>
          {this.state.remainingChars}
        </div>

        <Suggestions list={this.state.candidates}
                     numLines={this.state.numLines}/>
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
    let cmdOrCtrl = event.metaKey || event.ctrlKey
    let textarea = event.target
    let atSign = 50
    let returnKey = 13

    // if at-sign typed, query for user data and begin filtering
    if (event.keyCode === atSign) {
      if (this.state.users) {
        this.beginFiltering(textarea)
      } else {
        $.getJSON("/usernames", (users) => {
          this.setState({ users: users })
          this.beginFiltering(textarea)
        })
      }
    }

    // cmd+enter or ctrl+enter to submit the form
    if (cmdOrCtrl && event.keyCode == returnKey) {
      return this.submitForm(event)
    }

    // if not filtering, begin filtering
    if (!this.state.filtering) {
      return this.filterSuggestedAtMentions(event)
    }

    // store the current cursor position (+1 for mobile, for some reason)
    this.setState({ cursorPosition: textarea.selectionEnd + 1 })

    if (event.keyCode === returnKey) {
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

  handleSuggestionClick(event) {
    let selectedItem = event.target
    let textarea = this.state.squawkForm.getElementsByTagName("textarea")[0]
    this.completeSelectedSuggestion(textarea, selectedItem)
  }

  // Form submission
  // ===============
  submitForm(event) {
    event.preventDefault()
    $(this.state.squawkForm).submit()
  }

  // Countdown methods
  // ==================
  updateCountdown(event) {
    let maxChars = 160
    let currentLength = event.target.value.length
    let remainingChars = maxChars - currentLength
    let color = (remainingChars <= 10) ? "red" : "black"

    if (remainingChars === maxChars) {
      this.clearCountdown()
    } else {
      this.setState({remainingChars: remainingChars, color: color})
    }

    // set approx number of lines entered for Suggestions prop
    this.state.numLines = Math.ceil(currentLength / 37)
  }

  clearCountdown() {
    this.setState({remainingChars: ""})
  }

  // Navigation methods
  // ==================
  // Event -> Boolean
  isNavigationUp(event) {
    let key = event.keyCode || event.which
    let letterK = 75
    let letterP = 80
    let arrowUp = 38
    return key === arrowUp ||
           event.ctrlKey && (key === letterP || key === letterK)
  }

  // Event -> Boolean
  isNavigationDown(event) {
    let key = event.keyCode || event.which
    let letterN = 78
    let letterJ = 74
    let arrowDown = 40
    return key === arrowDown ||
           event.ctrlKey && (key === letterN || key == letterJ)
  }

  isWordBreak(event) {
    let key = event.keyCode || event.which
    let comma = 188
    let space = 32
    let colon = 186
    let breaks = [comma, space, colon]

    breaks.includes(key)
  }

  navigate({ direction, event }) {
    let field = event.target.parentElement
    let selectedItem = field.getElementsByClassName("suggestion-focus")[0]

    let allItems = field.getElementsByTagName("li")
    let itemsArray = Array.from(allItems)

    if (direction === "up") {
      this.navigateUp(selectedItem, itemsArray)
    } else {
      this.navigateDown(selectedItem, itemsArray)
    }
  }

  navigateUp(selectedItem, itemsArray) {
    if (!selectedItem) { return }
    let prevItemNum = parseInt(selectedItem.dataset.itemNumber, 10) - 1
    let prevItem = itemsArray.filter(e => e.dataset.itemNumber == prevItemNum)[0]

    if (!prevItem) { return }
    itemsArray.forEach(e => e.classList.remove("suggestion-focus"))
    prevItem.classList.add("suggestion-focus")
  }

  navigateDown(selectedItem, itemsArray) {
    if (!selectedItem) {
      let firstSuggestion = itemsArray[0]
      if (!firstSuggestion) { return }
      firstSuggestion.classList.add("suggestion-focus")
      return
    }

    let nextItemNum = parseInt(selectedItem.dataset.itemNumber, 10) + 1
    let nextItem = itemsArray.filter(e => e.dataset.itemNumber == nextItemNum)[0]

    if (!nextItem) { return }
    itemsArray.forEach(e => e.classList.remove("suggestion-focus"))
    nextItem.classList.add("suggestion-focus")
  }

  // Suggester Methods
  filterSuggestedAtMentions(event) {
    // if we're not in filtering mode, no-op
    if (!this.state.filtering) { return }

    let textarea = event.target
    let currVal = textarea.value
    let currPosn = textarea.selectionEnd
    let slice = currVal.slice(0, currPosn)
    let match = slice.match(/@(\w+)$/)

    // once we delete the '@', cancel filtering
    if (!match) {
      return this.setState({ candidates: [] })
    }

    let seed = match[1]
    this.state.searchSeed = seed
    let seedRegex = new RegExp(seed, "i")

    let candidates = this.state.users.reduce((acc, [index, user]) => {
      if (index.match(seedRegex)) { acc.push(user) }
      return acc
    }, [])

    this.setState({ candidates: candidates })
  }

  completeSelectedSuggestion(textarea, selectedItem) {
    let field = textarea.parentElement
    let allItems = field.getElementsByTagName("li")
    selectedItem = selectedItem ||
                   field.getElementsByClassName("suggestion-focus")[0]

    if (!selectedItem) { return this.endFiltering() }

    let handle = selectedItem.getElementsByClassName("suggestion-username")[0]
    let currVal = textarea.value
    let originalPosn = this.state.cursorPosition

    let strToRemove = "@" + this.state.searchSeed
    let selectedHandle = "@" + handle.textContent
    textarea.value = textarea.value.replace(strToRemove, selectedHandle)

    let newPosn = originalPosn - strToRemove.length + selectedHandle.length
    textarea.setSelectionRange(newPosn, newPosn)

    this.endFiltering()
  }

  beginFiltering(textarea) {
    this.setState({
      filtering: true,
      cursorPosition: textarea.selectionEnd
    })

  }

  endFiltering() {
    this.setState({
      candidates: [],
      filtering: false,
      cursorPosition: null
    })
  }
}
