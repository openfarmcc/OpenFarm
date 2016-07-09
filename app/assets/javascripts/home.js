// <!--[if lt IE 9]>
// document.createElement('video');
// <!--[endif]-->

// TODO: what is the point of this? unload is deprecated in jquery > 1.8
// $(window).unload(function() {
//   $.rails.enableFormElements($($.rails.formSubmitSelector));
// });

// Cool title effect for "community favorites"
$(window).load(function() {
  // get the  height of the hero
  var pageHeight = $($('.hero')[0]).height();
  // get the height including margins of the featured crops title
  var titleHeight = $($('.explore-community-favorites')[0]).outerHeight(true);

  // On resize, recalculate the above values
  $(window).resize(function() {
    pageHeight = $($('.hero')[0]).height();
    titleHeight = $($('.explore-community-favorites')[0]).outerHeight(true);
  });

  $(window).scroll(function() {
    updateTitleBackground($(window).scrollTop(), pageHeight, titleHeight);
  });
});

// Darken the title background when the user scrolls to the featured crops header
function updateTitleBackground(scrollPos, pageHeight, titleHeight) {
  var exploreCommunityFavoritesTitle = $($('.explore-community-favorites')[0]);
  // The extra 1px lets smooth scrolling still trigger the change
  if (scrollPos >= (pageHeight - titleHeight - 1)) {
    exploreCommunityFavoritesTitle.addClass('full-black');
  }
  else {
    exploreCommunityFavoritesTitle.removeClass('full-black');
  }
}

