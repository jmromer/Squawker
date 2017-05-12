// Like item handling
$(document).ready(() => {
  $("body").on("ajax:success", ".like-item", (e, status) => {
    let $link = $(e.target)
    let oldMethod = $link.attr("data-method")
    let newMethod = oldMethod === "post" ? "delete" : "post"

    $link
      .toggleClass("active")
      .attr("data-method", newMethod)
      .data("method", newMethod)
  }).on("ajax:error", ".like-item", (e) => {
    console.error(e)
  })

  // Flag item handling
  // TODO: implement this
  $("body").on("click", ".flag-item", (e, status) => {
    e.preventDefault()
    let $link = $(e.target)

    $link.toggleClass("active")
  })

  // Delete item handling
  $("body").on("ajax:beforeSend", ".delete-item", (e, status) => {
    let $li = $(e.target).closest("li")
    $li.remove()
  }).on("ajax:error", ".delete-item", (e) => {
    console.error("Could not delete that item")
  })
})
