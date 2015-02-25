//= require jquery
//= require jquery_ujs
//= require angular
//= require jquery-ui
//= require angular/angular-sanitize
//= require angular-dragdrop
//= require angular-foundation
//= require ng-rails-csrf
//= require ./libs/showdown
//= require ./libs/moment.min
//= require ./angular-libs/angular.openfarm
//= require ./angular-libs/angular.openfarm.guides
//= require ./angular-libs/angular.openfarm.gardens
//= require ./angular-libs/angular.openfarm.stages
//= require ./angular-libs/angular.openfarm.crops
//= require ./angular-libs/ngs3upload
//= require foundation
//= require foundation/custom.modernizr
//= require foundation/foundation
//= require foundation/foundation.accordion
//= require foundation/foundation.alert
//= require foundation/foundation.dropdown
//= require foundation/foundation.tooltip
//= require foundation/foundation.topbar
//= require_tree ./guides
//= require_tree ./crops

//TODO: Need a better folder structure
$(function() {
  $(document).foundation({
    accordion: {
      // specify the class used for active (or open) accordion panels
      active_class: 'active',
      // allow multiple accordion panels to be active at the same time
      multi_expand: true,
      // allow accordion panels to be closed by clicking on their headers
      // setting to false only closes accordion panels when another is opened
      toggleable: true
    }
  });
});

(function(i, s, o, g, r, a, m) {
  i['GoogleAnalyticsObject'] = r;
  i[r] = i[r] || function() {
    (i[r].q = i[r].q || []).push(arguments);
  }, i[r].l = 1 * new Date();
  a = s.createElement(o),
  m = s.getElementsByTagName(o)[0];
  a.async = 1;
  a.src = g;
  m.parentNode.insertBefore(a, m)
})(window, document, 'script', '//www.google-analytics.com/analytics.js', 'ga');
ga('create', 'UA-54082196-1', 'auto');
ga('send', 'pageview');

// TODO: move these somewhere actually meaningful.

var getUrlVar = function(key) {
  var result = new RegExp(key + "=([^&]*)", "i").exec(window.location.search);
  return result && unescape(result[1]) || "";
};

var getIDFromURL = function(key) {
  var result = new RegExp(key + "/([0-9a-zA-Z\-]*)", "i").exec(window.location.pathname);
  return result && unescape(result[1]) || "";
};

var pushToAlerts = function (response, code, alerts){
  console.log(response, code);
  var msg = '';
  angular.forEach(response, function(value){
    msg += value;
  });
  alerts.push({
    msg: msg,
    type: 'warning'
  });
};

// Smooth anchor scrolling via Chris Coyier
// http://css-tricks.com/snippets/jquery/smooth-scrolling/
$(function() {
  $('a[href*=#]:not([href=#])').click(function() {
    if (location.pathname.replace(/^\//,'') == this.pathname.replace(/^\//,'') && location.hostname == this.hostname) {
      var target = $(this.hash);
      target = target.length ? target : $('[name=' + this.hash.slice(1) +']');
      if (target.length) {
        $('html,body').animate({
          scrollTop: target.offset().top
        }, 800);
        return false;
      }
    }
  });
});
