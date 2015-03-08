var updateCountdown = function ($form) {
  var current, remaining, color;
  current = $form.find('#squawk_content').val().length;
  remaining = 160 - current;
  color = (remaining <= 10) ? 'red' : 'black';
  $form.find('#countdown').text(remaining).css('color', color);
};

var clearCountdown = function ($form){
  $(this).find('#countdown').text('');
};

$(document).ready(function(){
  $('#new_squawk').on({
    'focus keyup': {
      '#squawk_content': updateCountdown($(this))
    },
    'focusout': {
      '#squawk_content': clearCountdown($(this))
    }
  });
});
