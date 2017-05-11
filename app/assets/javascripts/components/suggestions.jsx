class Suggestions extends React.Component {
  constructor(props) {
    super(props)
  }

  render() {
    if (this.props.list.length === 0) {
      return <div></div>
    } else {
      return (
        <div className="suggestions-container">
          <div className="suggestions">
            <ul className="suggestion-list">
              {this.props.list.map(
                (e) =>
                  <li key={e.handle}
                      className="suggestion-item"
                      tabIndex="0">
                    <span className="suggestion-username">
                      {e.handle}
                    </span>
                    <span className="suggestion-name">
                      {e.name}
                    </span>
                    </li>)
              }
            </ul>
          </div>
        </div>)
    }
  }
}
