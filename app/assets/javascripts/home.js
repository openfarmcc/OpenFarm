<!--[if lt IE 9]>
document.createElement('video');
<!--[endif]-->

$(window).unload(function() {
  $.rails.enableFormElements($($.rails.formSubmitSelector));
});
