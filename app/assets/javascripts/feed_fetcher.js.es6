class FeedFetcher {
  constructor({ endpoint }) {
    this.debug = false
    this.async = true

    this.xhr = new XMLHttpRequest()
    this.endpoint = endpoint
    this.listId = "js-squawk-list"
    this.page = 1
    this.hasCompleted = false

    this.xhr.onprogress = this.updateProgress.bind(this)
    this.xhr.onload = this.transferComplete.bind(this)
    this.xhr.onabort = this.transferCanceled.bind(this)
    this.xhr.onerror = this.transferFailed.bind(this)
    this.xhr.ontimeout = this.transferFailed.bind(this)
  }

  fetchInitialPages({ scrollManager }) {
    let getNextPageIfNeeded = () => {
      if (scrollManager.canScrollY()) { return }

      this.fetchNextPage(getNextPageIfNeeded)
    }

    this.fetchNextPage(getNextPageIfNeeded)
  }

  fetchNextPage(completion) {
    if (this.hasCompleted) {
      if (this.debug) {
        console.info("not fetching another page.")
      }

      return
    }

    if (this.debug) {
      console.info(`Requesting page ${this.page}`)
      console.info(`GET ${this.endpoint}?page=${this.page}`)
    }

    // completion handler to be executed after request is done processing
    this.completion = completion

    let url = `${this.endpoint}?page=${this.page}`
    this.xhr.open("GET", url, this.async)
    this.xhr.send()
    this.fetchingComplete()
  }

  transferComplete(event) {
    let newItems = this.xhr.responseText
    let squawkList = window.document.getElementById(this.listId)
    let parentNode = squawkList.parentNode

    if (newItems === "") {
      if (this.debug) { console.info("Empty result set.") }

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

    // Build a new list from the old + new items
    let newList = window.document.createElement("ul")
    newList.id = this.listId
    newList.className = "squawks"
    newList.innerHTML = squawkList.innerHTML + newItems

    parentNode.replaceChild(newList, squawkList)
    this.incrementPage()

    // invoke completion handler, if present
    if (this.completion) {
      this.completion()
    }
  }

  transferFailed(event) {
    console.error(`Could not fetch: ${this.xhr.responseText}`)
  }

  transferCanceled(event) {
    console.log("Transfer canceled")
  }

  updateProgress(event) {
    let prog = Math.round(event.loaded / event.total) * 100
    if (this.debug) { console.log(`${prog}% complete`) }
  }

  incrementPage() {
    if (this.debug) {
      console.info(`Success. Incremented nextPage to ${this.page}`)
    }

    this.page += 1
    this.hasCompleted = false
  }

  fetchingComplete() {
    this.hasCompleted = true
  }
}
