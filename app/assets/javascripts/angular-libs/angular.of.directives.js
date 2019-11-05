openFarmApp.directive('markdown', [
  '$sanitize',
  function markdown($sanitize) {
    var converter = new Showdown.converter();
    return {
      restrict: 'A',
      link: function(scope, element, attrs) {
        function renderMarkdown() {
          var htmlText = converter.makeHtml(scope.$eval(attrs.markdown) || '');
          element.html($sanitize(htmlText));
        }
        scope.$watch(attrs.markdown, function() {
          renderMarkdown();
        });
        renderMarkdown();
      },
    };
  },
]);

openFarmApp.directive('loader', [
  '$rootScope',
  function loader($rootScope) {
    return {
      restrict: 'A',
      link: function() {
        $rootScope.ofPageLoading = true;
      },
    };
  },
]);

openFarmApp.directive('location', [
  function location() {
    var geocoder = new google.maps.Geocoder();
    return {
      restrict: 'A',
      require: '?ngModel',
      scope: { ngModel: '=' },
      controller: [
        '$scope',
        '$element',
        '$attrs',
        function($scope, $element, $attrs) {
          $scope.loadingText = $attrs.loadingText;
          $scope.$watch('ngModel', function() {
            $scope.location = $scope.ngModel;
          });

          $scope.getLocation = function(val) {
            $scope.ngModel = val;
            if (geocoder) {
              geocoder.geocode({ address: val }, function(results, status) {
                if (status == google.maps.GeocoderStatus.OK) {
                  var addresses = [];
                  angular.forEach(results, function(item) {
                    addresses.push(item.formatted_address);
                  });
                  $scope.addresses = addresses;
                } else {
                  console.error('Geocoding failed: ' + status);
                }
              });
            }
            $scope.setLocation = function() {
              $scope.ngModel = $scope.location;
            };
          };

          $scope.addresses = [];
        },
      ],
      templateUrl: '/assets/templates/_location.html',
    };
  },
]);

openFarmApp.directive('multiRowSelect', [
  function multiRowSelect() {
    return {
      restrict: 'A',
      scope: {
        optionsArray: '=',
        relativeId: '=?',
      },
      controller: [
        '$scope',
        '$element',
        '$attrs',
        function($scope, $element, $attrs) {
          $scope.multiSelectType = $attrs.multiSelectType || 'checkbox';
          $scope.multiSelectOverflowCount = $attrs.multiSelectOverflowCount || 3;
          $scope.multiSelectId = $attrs.multiSelectId;
          $scope.$watch(
            'optionsArray',
            function() {
              if ($scope.optionsArray !== undefined && $scope.optionsArray !== []) {
                $scope.othered = $scope.optionsArray.reduce(function(returned, current, index) {
                  if (index > $scope.multiSelectOverflowCount) {
                    return returned || current.selected;
                  } else {
                    return false;
                  }
                });
              }
            },
            true
          );
        },
      ],
      templateUrl: '/assets/templates/_multi_checkbox_select.html',
    };
  },
]);

openFarmApp.directive('clearOn', [
  function() {
    return function(scope, elem, attr) {
      scope.$on('clearOn', function(e, name) {
        if (name === attr.clearOn) {
          elem[0].value = '';
        }
      });
    };
  },
]);

// Source: http://stackoverflow.com/questions/14833326/how-to-set-focus-on-input-field/14837021#14837021
openFarmApp.directive('focusOn', [
  function() {
    return function(scope, elem, attr) {
      scope.$on('focusOn', function(e, name) {
        if (name === attr.focusOn) {
          elem[0].focus();
        }
      });
    };
  },
]);

// Source: http://stackoverflow.com/questions/14833326/how-to-set-focus-on-input-field/14837021#14837021
openFarmApp.directive('autoFocus', [
  '$timeout',
  function($timeout) {
    return {
      restrict: 'AC',
      link: function($scope, $element) {
        if ($scope.autoFocus) {
          $timeout(function() {
            $element[0].focus();
          }, 0);
        }
      },
    };
  },
]);

openFarmApp.directive('ofSticky', [
  function() {
    return {
      restrict: 'A',
      link: function($scope, $element, $attributes) {
        $window = $(window);
        $window.on('scroll', function() {
          update_sticky_positioning();
        });

        var update_sticky_positioning = function() {
          var $parent = $($element);
          var $toHang = $parent.children($attributes.ofStickyChild);
          var offset = $parent.offset().top - +$attributes.ofStickyOffset;
          if ($window.scrollTop() - offset > 0) {
            $toHang.addClass('fixed');
            $toHang.css('top', $attributes.ofStickyOffset + 'px');
          } else {
            $toHang.removeClass('fixed');
          }
        };
      },
    };
  },
]);

openFarmApp.directive('alerts', [
  '$timeout',
  function alerts($timeout) {
    return {
      restrict: 'A',
      require: '?ngModel',
      scope: {
        alerts: '=',
      },
      controller: [
        '$scope',
        '$element',
        function(scope, element) {
          scope.closeAlert = function(index) {
            scope.alerts.splice(index, 1);
          };
          scope.$watch('alerts', function() {
            if (scope.alerts && scope.alerts.length) {
              $timeout(function() {
                scope.alerts = scope.alerts.filter(function(alert) {
                  return alert.cancelTimeout;
                });
              }, 3000);
            }
          });
          scope.$watch('alerts.length', function() {
            if (scope.alerts !== undefined) {
              scope.alerts.forEach(function(alert, index) {
                $timeout(function() {
                  if (index > 0) {
                    var height = element[0].children[index - 1].offsetHeight;
                    var top = scope.alerts[index - 1].top;
                    alert.top = height + top + 18;
                  } else {
                    alert.top = 64;
                  }
                }, 200);
              });
            }
          });
        },
      ],
      templateUrl: '/assets/templates/angular.of.alerts.template.html',
    };
  },
]);
