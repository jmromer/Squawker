function updateCountdown () {
  var current   = $('#squawk_content').val().length
  var remaining = 160 - current;

  if (remaining === 160 ) {
    $('#countdown').html('');
  } else if (remaining <= 10) {
    $('#countdown').text(remaining).css('color', 'red');
  } else {
    $('#countdown').text(remaining).css('color', 'black');
  }
}

$(document).ready(function(){
  if ($('#squawk_content').val() != undefined) {
    updateCountdown();
    $('#squawk_content').change(updateCountdown);
    $('#squawk_content').keyup(updateCountdown);
  }
});

