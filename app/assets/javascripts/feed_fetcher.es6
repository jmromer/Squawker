class FeedFetcher {
  constructor({ endpoint }) {
    this.httpRequest = new XMLHttpRequest()
    this.endpoint = endpoint
    this.page = 1
  }

  fetchNextPage(completion) {
    this.httpRequest.onreadystatechange = completion
    this.httpRequest.open("GET", `${this.endpoint}?page=${this.page}`, false)

    // console.info(`Requesting page ${this.page}`)
    // console.info(`GET ${this.endpoint}?page=${this.page}`)

    this.httpRequest.send()
  }

  incrementPage() {
    // console.info(`Success. Incremented nextPage to ${this.page}`)
    this.page += 1
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
      // console.info("Empty result set.")
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
