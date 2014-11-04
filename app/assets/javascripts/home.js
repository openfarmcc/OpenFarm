<!--[if lt IE 9]>
document.createElement('video');
<!--[endif]-->

$(window).unload(function() {
  $.rails.enableFormElements($($.rails.formSubmitSelector));
});

// Cool title effect for "community favorites"
$(window).load(function() {
  $pageHeight = $($('.hero')[0]).height();
  // get the height including margins of the featured crops title
  $exploreCommunityFavoritesTitleHeight = $($('.explore-community-favorites')[0]).outerHeight(true);

  // On resize, recalculate the above values
  $(window).resize(function() {
    $pageHeight = $($('.hero')[0]).height();
    $exploreCommunityFavoritesTitleHeight = $($('.explore-community-favorites')[0]).outerHeight(true);
  })

  $(window).scroll(function() {
    scrollHandler($(window).scrollTop());
  })
})

// Black out the title background when the user scrolls to the featured crops header
function scrollHandler(scrollPos) {
  $exploreCommunityFavoritesTitle = $($(".explore-community-favorites")[0]);
  // The extra 1px lets smooth scrolling still trigger the change
  if (scrollPos >= ($pageHeight - $exploreCommunityFavoritesTitleHeight - 1)) {
    $exploreCommunityFavoritesTitle.addClass("full-black");
  }
  else {
    $exploreCommunityFavoritesTitle.removeClass("full-black");
  }
}

