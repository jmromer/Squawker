const debug = true

class FeedFetcher {
  constructor({ endpoint }) {
    this.httpRequest = new XMLHttpRequest()
    this.endpoint = endpoint
    this.page = 1
    this.completed = false
  }

  fetchNextPage(completion) {
    if (this.completed) { return }

    this.httpRequest.onreadystatechange = completion
    this.httpRequest.open("GET", `${this.endpoint}?page=${this.page}`, false)

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
    this.completed = true
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
    return currScrollPosn > (maxScrollableHeight - offset)
  }
}

class FeedPresenter {
  constructor({ document, fetcher, listClass }) {
    this.document = document
    this.fetcher = fetcher
    this.listClass = listClass
  }

  displayResults(event) {
    let httpRequest = event.target

    if (httpRequest.readyState !== XMLHttpRequest.DONE) {
      return
    }

    if (httpRequest.status !== 200) {
      console.error(`Could not fetch: ${httpRequest.responseText}`)
      return
    }

    let newItems = httpRequest.responseText
    if (newItems === "") {
      if (debug) { console.info("Empty result set.") }

      this.fetcher.fetchingComplete()
      return
    }

    let squawkList = this.document.getElementsByClassName(this.listClass)[0]
    if (!squawkList) {
      console.error("no list found")
      return
    }

    let parentNode = squawkList.parentNode
    if (!parentNode) {
      console.error("no parent node")
      return
    }

    let newList = this.document.createElement("ul")
    newList.className = "squawks"
    newList.innerHTML = squawkList.innerHTML + newItems

    parentNode.replaceChild(newList, squawkList)
    this.fetcher.incrementPage()
  }
}
