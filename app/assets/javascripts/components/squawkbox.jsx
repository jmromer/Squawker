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
    let atSign = 50
    let comma = 188
    let space = 32
    let colon = 186
    let returnKey = 13
    let breaks = [comma, space, colon]

    // if we're in filtering mode, filter
    if (this.state.filtering) {
      let currVal = event.target.value
      let currPosn = event.target.selectionEnd
      let slice = currVal.slice(0, currPosn)
      let match = slice.match(/@(\w+)$/)
      if (!match) { return }

      let seed = match[1]
      let seedRegex = new RegExp(seed, "i")

      let candidates = this.state.users.reduce((acc, [index, user]) => {
        if (index.match(seedRegex)) { acc.push(user) }
        return acc
      }, [])

      this.state.candidates = candidates
    }

    // if at-sign typed, query for user data and begin filtering
    if (event.keyCode === atSign) {
      if (this.state.users) {
        this.state.filtering = true
        return
      }

      $.getJSON("/usernames", (users) => {
        this.state.users = users
        this.state.filtering = true
      })
    }

    // terminate suggestion mode on specific word break chars
    if (this.state.filtering && breaks.includes(event.keyCode || event.which)) {
      this.state.filtering = false
      this.state.candidates = []
    }

    // suggestion selection
    // TODO: if in suggestion mode and arrow key pressed
    // if (arrow key pressed)

    // suggestion completion
    if (this.state.filtering && event.keyCode === returnKey) {
      event.preventDefault()
      this.state.filtering = false
      // TODO: inject suggestion to text field
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
}
