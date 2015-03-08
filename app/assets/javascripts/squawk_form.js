var updateCountdown = function (e) {
  var $form, current, remaining, color;
  $form = $(e.delegateTarget);
  current = $form.find('#squawk_content').val().length;
  remaining = 160 - current;
  color = (remaining <= 10) ? 'red' : 'black';
  $form.find('#countdown').text(remaining).css('color', color);
};

var clearCountdown = function (e){
  $(e.delegateTarget).find('#countdown').text('');
};

$(function(){
  $('#new_squawk').on({
    'focus keyup change': updateCountdown,
    'focusout': clearCountdown
  }, '#squawk_content');
});
