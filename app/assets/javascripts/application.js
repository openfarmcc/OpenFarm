//= require jquery
//= require jquery_ujs
//= require angular
//= require jquery-ui
//= require angular/angular-sanitize
//= require angular-dragdrop
//= require angular-ui-sortable
//= require angular-foundation
//= require angular-local-storage
//= require ng-rails-csrf
//= require ./libs/showdown
//= require ./libs/moment.min
//= require ./angular-libs/angular.openfarm
//= require ./angular-libs/angular.of.directives
//= require ./angular-libs/angular.of.directives.lightbox-modal
//= require ./angular-libs/angular.of.users.service
//= require ./angular-libs/angular.of.defaults.service
//= require ./angular-libs/angular.of.gardens.service
//= require ./angular-libs/angular.of.stages.service
//= require ./angular-libs/angular.of.crops.service
//= require ./angular-libs/guides/guides.service
//= require ./angular-libs/guides/directives/guides.directives
//= require ./angular-libs/guides/directives/guides.stageButtons.directive.js
//= require ./angular-libs/guides/directives/guides.timeline.directive.js
//= require ./angular-libs/guides/directives/guides.lifetimeChange.directive.js
//= require ./angular-libs/guides/new/guides.new.stages.directive.js
//= require ./angular-libs/guides/new/guides.new.stage.directive.js
//= require ./angular-libs/guides/new/guides.new.chooseCrop.directive.js
//= require ./angular-libs/guides/new/guides.new.actions.directive.js
//= require ./angular-libs/guides/new/guides.new.actionDetails.directive.js
//= require ./angular-libs/guides/new/guides.new.actionsControl.directive.js
//= require ./angular-libs/guides/new/guides.new.guideStageOverview.directive.js
//= require ./angular-libs/guides/show/guides.show.stage.directive.js
//= require ./angular-libs/guides/show/guides.show.stage.environmental-overview.directive.js
//= require ./angular-libs/guides/show/guides.show.add-stage-to-guide.directive.js
//= require ./angular-libs/guides/directives/guides.formChecker.directive.js

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
  m.parentNode.insertBefore(a, m)
})(window, document, 'script', '//www.google-analytics.com/analytics.js', 'ga');
ga('create', 'UA-54082196-1', 'auto');
ga('send', 'pageview');
}

// TODO: move these somewhere actually meaningful.

var getUrlVar = function(key) {
  var result = new RegExp(key + "=([^&]*)", "i").exec(window.location.search);
  return result && unescape(result[1]) || "";
};

var getIDFromURL = function(key) {
  var result = new RegExp(key + "/([0-9a-zA-Z\-]*)", "i").exec(window.location.pathname);
  if (result === 'new') {
    return '';
  }
  return result && unescape(result[1]) || '';
};
