function updateCountdown () {
  var current   = $('#squawk_content').val().length
  var remaining = 160 - current;

  if (remaining <= 10) {
    $('#countdown').text(remaining).css('color', 'red');
  } else {
    $('#countdown').text(remaining).css('color', 'black');
  }
}

$(document).ready(function(){
  $('#squawk_content').focus(function(){
    updateCountdown();
    $('#squawk_content').change(updateCountdown);
    $('#squawk_content').keyup(updateCountdown);
  });
});

$(document).ready(function(){
  $('#squawk_content').focusout(function(){
    $('#countdown').text('');
  });
});
