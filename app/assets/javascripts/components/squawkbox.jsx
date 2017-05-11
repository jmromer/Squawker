class SquawkBox extends React.Component {
  constructor(props) {
    super(props)
    this.state = {
      remainingChars: "",
      color: "black",
      candidates: []
    }

    this.handleKeyDown = this.handleKeyDown.bind(this)
    this.handleKeyUp = this.handleKeyUp.bind(this)
    this.handleFocus = this.handleFocus.bind(this)
    this.handleChange = this.handleChange.bind(this)
    this.handleBlur = this.handleBlur.bind(this)
    this.suggestCompletions = this.suggestCompletions.bind(this)
    this.updateCountdown = this.updateCountdown.bind(this)
    this.submitForm = this.submitForm.bind(this)
    this.navigateDown = this.navigateDown.bind(this)
    this.navigateUp = this.navigateUp.bind(this)
    this.beginFiltering = this.beginFiltering.bind(this)
    this.endFiltering = this.endFiltering.bind(this)
  }

  beginFiltering(textarea) {
    this.state.filtering = true
    this.state.cursorPosition = textarea.selectionEnd
  }

  endFiltering() {
    this.state.candidates = []
    this.state.filtering = false
    this.state.cursorPosition = null
  }

  render() {
    return (
      <field style={{position: "relative", display: "block"}}>
        <textarea cols="30"
                  placeholder="sing the song of yourself"
                  className="squawk-form-content"
                  name="squawk[content]"
                  onKeyDown={this.handleKeyDown}
                  onKeyUp={this.handleKeyUp}
                  onFocus={this.handleFocus}
                  onChange={this.handleOnChange}
                  onBlur={this.handleBlur}>
        </textarea>

        <div className="squawk-form-countdown"
             style={{color: this.state.color}}>
          {this.state.remainingChars}
        </div>

        <Suggestions list={this.state.candidates}/>
      </field>
    )
  }

  handleKeyUp(event) {
    this.suggestCompletions(event)
    this.updateCountdown(event)
  }

  handleKeyDown(event) {
    let arrowUp = 38
    let arrowDown = 40
    let returnKey = 13
    let textarea = event.target

    if (this.state.filtering) {
      this.state.cursorPosition = textarea.selectionEnd

      // suggestion completion
      if (event.keyCode === returnKey) {
        event.preventDefault()
        let field = textarea.parentElement
        let allItems = field.getElementsByTagName("li")
        let selectedItem = field.getElementsByClassName("suggestion-focus")[0]
        let handle = selectedItem.getElementsByClassName("suggestion-username")[0]

        let currVal = textarea.value
        let originalPosn = this.state.cursorPosition

        let strToRemove = "@" + this.state.searchSeed
        let selectedHandle = "@" + handle.textContent
        textarea.value = textarea.value.replace(strToRemove, selectedHandle)

        let newPosn = originalPosn - strToRemove.length + selectedHandle.length
        textarea.setSelectionRange(newPosn, newPosn)

        this.endFiltering()
        return
      }

      let letterN = 78
      let letterP = 80
      let letterJ = 74
      let letterK = 75
      if (event.which === arrowUp ||
          event.ctrlKey && (event.keyCode == letterP || event.keyCode == letterK)) {
        event.preventDefault()
        this.navigateUp(event)
        return
      }

      if (event.which === arrowDown ||
          event.ctrlKey && (event.keyCode == letterN || event.keyCode == letterJ)) {
        event.preventDefault()
        this.navigateDown(event)
        return
      }

      let comma = 188
      let space = 32
      let colon = 186
      let breaks = [comma, space, colon]
      // terminate suggestion mode on specific word break chars
      if (breaks.includes(event.keyCode || event.which)) {
        this.endFiltering()
        return
      }
    }

    // cmd+enter or ctrl+enter to submit
    if ((event.metaKey || event.ctrlKey) && event.keyCode == 13) {
      this.submitForm()
      return
    }

    this.suggestCompletions(event)
  }

  handleFocus(event) {
    this.updateCountdown(event)
  }

  handleChange(event) {
    this.updateCountdown(event)
  }

  handleBlur(event) {
    this.clearCountdown(event)
  }

  // 2. display filter results in the ui
  // 3. handle suggestion selection and completion
  suggestCompletions(event) {
    let textarea = event.target

    // if we're in filtering mode, filter
    if (this.state.filtering) {
      let currVal = textarea.value
      let currPosn = textarea.selectionEnd
      let slice = currVal.slice(0, currPosn)
      let match = slice.match(/@(\w+)$/)
      if (!match) { return }

      let seed = match[1]
      this.state.searchSeed = seed
      let seedRegex = new RegExp(seed, "i")

      let candidates = this.state.users.reduce((acc, [index, user]) => {
        if (index.match(seedRegex)) { acc.push(user) }
        return acc
      }, [])

      this.state.candidates = candidates
    }

    // if at-sign typed, query for user data and begin filtering
    let atSign = 50
    if (event.keyCode === atSign) {
      if (this.state.users) {
        this.beginFiltering(textarea)
      } else {
        $.getJSON("/usernames", (users) => {
          this.state.users = users
          this.beginFiltering(textarea)
        })
      }
    }
  }

  submitForm() {
    document.getElementById("js-squawk-form").submit()
  }

  updateCountdown(event) {
    let maxLength = 160
    let currentLength = event.target.value.length
    let remaining = maxLength - currentLength
    let color = (remaining <= 10) ? "red" : "black"

    if (remaining === maxLength) {
      this.setState({remainingChars: ""})
    } else {
      this.setState({remainingChars: remaining, color: color})
    }
  }

  clearCountdown() {
    this.setState({remainingChars: ""})
  }

  navigateUp(event) {
    let field = event.target.parentElement
    let allItems = field.getElementsByTagName("li")
    let selectedItem = field.getElementsByClassName("suggestion-focus")[0]

    if (!selectedItem) { return }

    let prevItemNum = parseInt(selectedItem.dataset.itemNumber, 10) - 1
    let itemsArray = Array.from(allItems)
    let prevItem = itemsArray.filter(e => e.dataset.itemNumber == prevItemNum)[0]

    if (prevItem) {
      itemsArray.forEach(e => e.classList.remove("suggestion-focus"))
      prevItem.classList.add("suggestion-focus")
    }
  }

  navigateDown(event) {
    let field = event.target.parentElement
    let allItems = field.getElementsByTagName("li")
    let selectedItem = field.getElementsByClassName("suggestion-focus")[0]

    if (!selectedItem) {
      let firstSuggestion = allItems[0]

      if (firstSuggestion) {
        firstSuggestion.classList.add("suggestion-focus")
      }
    } else {
      let nextItemNum = 1 + parseInt(selectedItem.dataset.itemNumber, 10)
      let itemsArray = Array.from(allItems)
      let nextItem = itemsArray.filter(e => e.dataset.itemNumber == nextItemNum)[0]

      if (nextItem) {
        itemsArray.forEach(e => e.classList.remove("suggestion-focus"))
        nextItem.classList.add("suggestion-focus")
      }
    }
  }
}
