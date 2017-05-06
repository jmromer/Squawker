class ScrollManager {
  constructor({ window }) {
    this.window = window
    this.bumpOffset = 100
  }

  isAtBottom() {
    let documentHeight = this.window.document.body.clientHeight
    let viewportHeight = this.window.innerHeight
    let currScrollPosn = this.window.scrollY
    let maxScrollableHeight = documentHeight - viewportHeight
    return currScrollPosn + this.bumpOffset > maxScrollableHeight
  }

  canScrollY() {
    let documentHeight = this.window.document.body.clientHeight
    let viewportHeight = this.window.innerHeight
    return viewportHeight < documentHeight
  }

  scrollToTop() {
    this.window.scrollTo(0, 0)
  }
}
