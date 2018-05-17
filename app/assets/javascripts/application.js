//= require jquery
//= require jquery_ujs
//= require angular
//= require jquery-ui
//= require angular-sanitize
//= require angular-dragdrop
//= require angular-ui-sortable
//= require angular-foundation
//= require angular-local-storage
//= require ng-rails-csrf
//= require ng-tags-input
//= require ng-file-upload
//= require showdown
//= require moment
//= require ./angular-libs/angular.openfarm
//= require_tree ./angular-libs

//= require url-helpers.js
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

var isDNT = (window.doNotTrack === 1 ||
             navigator.doNotTrack === 'yes' ||
             navigator.doNotTrack == '1' ||
             navigator.msDoNotTrack == '1');

if (!isDNT) {
(function(i, s, o, g, r, a, m) {
  i['GoogleAnalyticsObject'] = r;
  i[r] = i[r] || function() {
    (i[r].q = i[r].q || []).push(arguments);
  }, i[r].l = 1 * new Date();
  a = s.createElement(o),
  m = s.getElementsByTagName(o)[0];
  a.async = 1;
  a.src = g;
  m.parentNode.insertBefore(a, m);
})(window, document, 'script', '//www.google-analytics.com/analytics.js', 'ga');
ga('create', 'UA-54082196-1', 'auto');
ga('send', 'pageview');
}
