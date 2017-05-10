class SquawkBox extends React.Component {
  constructor(props) {
    super(props)
    this.state = {remainingChars: "", color: "black" }
    this.updateCountdown = this.updateCountdown.bind(this)
    this.clearCountdown = this.clearCountdown.bind(this)
  }

  render() {
    return <field>
      <textarea cols="30"
                placeholder="sing the song of yourself"
                className="squawk-form-content"
                name="squawk[content]"
                onKeyDown={this.updateCountdown}
                onFocus={this.updateCountdown}
                onChange={this.updateCountdown}
                onBlur={this.clearCountdown}>
      </textarea>

      <div className="squawk-form-countdown"
           style={{color: this.state.color}}>
        {this.state.remainingChars}
      </div>
  </field>
  }

  updateCountdown(event) {
    if ((event.metaKey || event.ctrlKey) && event.keyCode == 13) {
      document.getElementById("js-squawk-form").submit()
    }

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

  clearCountdown(event) {
    this.setState({remainingChars: ""})
  }
}
