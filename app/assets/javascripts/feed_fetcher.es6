const debug = false

class FeedFetcher {
  constructor({ endpoint }) {
    this.httpRequest = new XMLHttpRequest()
    this.endpoint = endpoint
    this.listId = "js-squawk-list"
    this.page = 1
    this.hasCompleted = false

    this.httpRequest
      .addEventListener("progress", this.updateProgress.bind(this))
    this.httpRequest
      .addEventListener("load", this.transferComplete.bind(this))
    this.httpRequest
      .addEventListener("error", this.transferFailed.bind(this))
    this.httpRequest
      .addEventListener("abort", this.transferCanceled.bind(this))
  }

  updateProgress(event) {
    let prog = Math.round(event.loaded / event.total) * 100
    if (debug) { console.log(`${prog}% complete`) }
  }

  transferComplete(event) {
    let newItems = this.httpRequest.responseText
    let squawkList = window.document.getElementById(this.listId)
    let parentNode = squawkList.parentNode

    if (newItems === "") {
      if (debug) { console.info("Empty result set.") }

      // disallow repeated requests
      this.fetchingComplete()

      // append "back to top" link
      parentNode.appendChild(this.backToTop)
      return
    }

    // if a "back to top" link is present, store it, remove from dom
    let backToTop = window.document.getElementById("js-back-to-top")
    if (backToTop) {
      this.backToTop = backToTop
      backToTop.remove()
    }

    // Build a new
    let newList = window.document.createElement("ul")
    newList.id = this.listId
    newList.className = "squawks"
    newList.innerHTML = squawkList.innerHTML + newItems

    parentNode.replaceChild(newList, squawkList)
    this.incrementPage()
  }

  transferFailed(event) {
    console.error(`Could not fetch: ${this.httpRequest.responseText}`)
  }

  transferCanceled(event) {
    console.log("Transfer canceled")
  }

  fetchNextPage() {
    if (this.hasCompleted) { return }

    this.httpRequest.open("GET",
                          `${this.endpoint}?page=${this.page}`,
                          false)

    if (debug) {
      console.info(`Requesting page ${this.page}`)
      console.info(`GET ${this.endpoint}?page=${this.page}`)
    }

    this.httpRequest.send()
  }

  incrementPage() {
    if (debug) {
      console.info(`Success. Incremented nextPage to ${this.page}`)
    }

    this.page += 1
  }

  fetchingComplete() {
    this.hasCompleted = true
  }
}

class ScrollManager {
  constructor({ window }) {
    this.window = window
  }

  scrollIsAtBottom({ offset }) {
    let documentHeight = this.window.document.body.clientHeight
    let viewportHeight = this.window.innerHeight
    let currScrollPosn = this.window.scrollY
    let maxScrollableHeight = documentHeight - viewportHeight
    return currScrollPosn + offset > maxScrollableHeight
  }

  scrollToTop() {
    this.window.scrollTo(0, 0)
  }
}
