// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file.
//
// Read Sprockets README (https://github.com/sstephenson/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery
//= require jquery_ujs
//= require foundation
//- require jquery-ui
//= require mm-foundation-0.3.0.js
//= require mm-foundation-tpls-0.3.0.js
//= require_tree .

$(function(){ 
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
        (i[r].q = i[r].q || []).push(arguments)
    }, i[r].l = 1 * new Date();
    a = s.createElement(o),
        m = s.getElementsByTagName(o)[0];
    a.async = 1;
    a.src = g;
    m.parentNode.insertBefore(a, m)
})(window, document, 'script', '//www.google-analytics.com/analytics.js', 'ga');
ga('create', 'UA-54082196-1', 'auto');
ga('send', 'pageview');
