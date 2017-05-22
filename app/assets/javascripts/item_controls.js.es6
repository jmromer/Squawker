// Like item handling
$(document).ready(() => {
  // Find the containing list item
  const targetSquawk = e => $(e.target).closest("li")

  // change a POST link to DELETE, or vice versa.
  // Set "active" class correspondingly
  const flipForm = e => {
    let $remoteLink = $(e.target)
    let oldMethod = $remoteLink.attr("data-method")
    let newMethod = oldMethod === "post" ? "delete" : "post"

    $remoteLink
      .toggleClass("active")
      .attr("data-method", newMethod)
      .data("method", newMethod)
  }

  const requestRecommendations = e => {
    e.preventDefault()
    let $squawkLi = targetSquawk(e)
    let squawkId = $squawkLi.attr("id")

    $.ajax({
      url: `/recommendations?squawk_id=${squawkId}`
    }).done(resp => {
      let $recs = $("#recommendations")
      let $list = $($recs.find(".js-recs-list")[0])
      $recs.show()
      $list.html(resp)
    })
  }

  $("body")
    .on("ajax:beforeSend", ".like-item:not('.active')", requestRecommendations)

  // Like item handling
  // Flip optimistically, revert on failure
  $("body")
    .on("ajax:beforeSend", ".like-item", flipForm)
    .on("ajax:error", ".like-item", flipForm)

  // Delete item handling
  // ====================
  // Hide optimistically, remove from DOM on success, revert on failure
  $("body")
    .on("ajax:beforeSend", ".delete-item", e => targetSquawk(e).hide())
    .on("ajax:success", ".delete-item", e => targetSquawk(e).remove())
    .on("ajax:error", ".delete-item", e => targetSquawk(e).show())

  // Flag item handling
  // ==================
  // When not displaying flagged items:
  //   Hide optimistically, remove from DOM on success, replace on failure
  // When displaying flagged items:
  //   Flip optimistically, revert on failure
  $("body")
    .on("ajax:beforeSend", ".flag-item", e => {
      if (window.Squawker.config.displayFlaggedSquawks) {
        flipForm(e)
      } else {
        targetSquawk(e).hide()
      }
    })
    .on("ajax:success", ".flag-item", e => {
      if (window.Squawker.config.displayFlaggedSquawks) { return }

      targetSquawk(e).remove()
    })
    .on("ajax:error", ".flag-item", e => {
      if (window.Squawker.config.displayFlaggedSquawks) {
        flipForm(e)
      } else {
        targetSquawk(e).show()
      }
    })
})
