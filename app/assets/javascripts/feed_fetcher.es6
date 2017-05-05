const debug = false

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

  scrollToTop() {
    this.window.scrollTo(0, 0)
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
    let squawkList = this.document.getElementsByClassName(this.listClass)[0]
    if (!squawkList) {
      console.error("no list found")
      return
    }

    if (newItems === "") {
      if (debug) { console.info("Empty result set.") }

      this.fetcher.fetchingComplete()
      let backToTop = this.backToTopListItem()
      squawkList.appendChild(backToTop)
      return
    }

    this.fetcher.incrementPage()

    let parentNode = squawkList.parentNode
    if (!parentNode) {
      console.error("no parent node")
      let backToTop = this.backToTopListItem()
      squawkList.appendChild(backToTop)
      return
    }

    let newList = this.document.createElement("ul")
    newList.className = "squawks"
    newList.innerHTML = squawkList.innerHTML + newItems
    parentNode.replaceChild(newList, squawkList)
  }

  backToTopListItem() {
    let backToTop = this.document.createElement("li")
    let link = this.document.createElement("a")
    link.setAttribute("onClick", "scrollManager.scrollToTop()")
    link.textContent = "back to top"
    link.setAttribute("style", "cursor: pointer;")
    backToTop.appendChild(link)
    return backToTop
  }
}
