function updateCountdown () {
  var currentChars   = $('#squawk_content').val().length
  var remainingChars = 160 - currentChars;

  if (remainingChars <= 10) {
    $('#countdown').text(remainingChars).css('color', 'red');
  } else {
    $('#countdown').text(remainingChars).css('color', 'black');
  }
}

$(document).ready(function(){
  updateCountdown();
  $('#squawk_content').change(updateCountdown);
  $('#squawk_content').keyup(updateCountdown);
});
