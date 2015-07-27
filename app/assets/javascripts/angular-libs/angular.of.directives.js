openFarmModule.directive('markdown', ['$sanitize',
  function markdown($sanitize) {
    var converter = new Showdown.converter();
    return {
      restrict: 'A',
      link: function (scope, element, attrs) {
        function renderMarkdown() {
            var htmlText = converter.makeHtml(scope.$eval(attrs.markdown)  || '');
            element.html($sanitize(htmlText));
        }
        scope.$watch(attrs.markdown, function(){
            renderMarkdown();
        });
        renderMarkdown();
      }
    };
}]);

openFarmModule.directive('location', [
  function location() {
    var geocoder = new google.maps.Geocoder();
    return {
      restrict: 'A',
      require: '?ngModel',
      scope: { ngModel:'=' },
      controller: ['$scope', '$element', '$attrs',
        function ($scope, $element, $attrs) {
          $scope.loadingText = $attrs.loadingText;
          $scope.$watch('ngModel', function(){
            $scope.location = $scope.ngModel;
          });

          $scope.getLocation = function(val) {
            $scope.ngModel = val;
            if (geocoder) {
              geocoder.geocode({ 'address': val }, function (results, status) {
                if (status == google.maps.GeocoderStatus.OK) {
                  var addresses = [];
                  angular.forEach(results, function(item){
                    addresses.push(item.formatted_address);
                  });
                  $scope.addresses = addresses;
                 }
                 else {
                    console.log('Geocoding failed: ' + status);
                 }
              });
            }
          $scope.setLocation = function(){
            $scope.ngModel = $scope.location;
          };
        };

        $scope.addresses = [];
      }],
      templateUrl: '/assets/templates/_location.html',
    };
}]);

openFarmModule.directive('multiRowSelect', [
  function multiRowSelect() {
    return {
      restrict: 'A',
      scope: {
        options: '=',
      },
      controller: ['$scope', '$element', '$attrs',
        function ($scope, $element, $attrs) {
          $scope.multiSelectType = $attrs.multiSelectType || 'checkbox';
          $scope.multiSelectOverflowCount = $attrs
            .multiSelectOverflowCount || 3;
          $scope.multiSelectId = $attrs.multiSelectId;
          $scope.$watch('options', function(){
            if ($scope.options !== undefined && $scope.options !== []){
              $scope.othered = $scope.options
                .reduce(function(returned, current, index){
                  if (index > $scope.multiSelectOverflowCount){
                    return returned || current.selected;
                  } else {
                    return false;
                  }
                });
            }

          }, true);
      }],
      templateUrl: '/assets/templates/_multi_checkbox_select.html',
    };
}]);

openFarmApp.directive('clearOn', [function() {
   return function(scope, elem, attr) {
      scope.$on('clearOn', function(e, name) {
        if(name === attr.clearOn) {
          elem[0].value = '';
        }
      });
   };
}]);

// Source: http://stackoverflow.com/questions/14833326/how-to-set-focus-on-input-field/14837021#14837021
openFarmApp.directive('focusOn', [function() {
   return function(scope, elem, attr) {
      scope.$on('focusOn', function(e, name) {
        if(name === attr.focusOn) {
          elem[0].focus();
        }
      });
   };
}]);

// Source: http://stackoverflow.com/questions/14833326/how-to-set-focus-on-input-field/14837021#14837021
openFarmApp.directive('autoFocus', ['$timeout',
  function($timeout) {
    return {
        restrict: 'AC',
        link: function(_scope, _element) {
            $timeout(function(){
                _element[0].focus();
            }, 0);
        }
    };
}]);

openFarmModule.directive('alerts', ['$timeout',
  function alerts($timeout) {
    return {
      restrict: 'A',
      require: '?ngModel',
      scope: {
        alerts: '='
      },
      controller: ['$scope', '$element',
        function (scope, element) {
          scope.closeAlert = function(index) {
            scope.alerts.splice(index, 1);
          };
          scope.$watch('alerts', function(){
            if (scope.alerts && scope.alerts.length){
              $timeout(function(){
                scope.alerts = scope.alerts.filter(function(alert){
                  return alert.cancelTimeout;
                });
              }, 3000);
            }
          });
          scope.$watch('alerts.length', function(newLength) {
            scope.alerts.forEach(function(alert, index) {
              $timeout(function() {
                if (index > 0) {
                  var height = element[0].children[index - 1].offsetHeight;
                  var top = scope.alerts[index - 1].top;
                  alert.top = height + top + 18;
                } else {
                  alert.top = 64;
                }
              }, 500)
            })
          });
      }],
      templateUrl:'/assets/templates/angular.of.alerts.template.html'

    };
  }]);

openFarmApp.directive('cropSearch', ['$http', 'cropService',
  function cropSearch($http, cropService) {
    return {
      restrict: 'A',
      scope: {
        cropSearchFunction: '=',
        cropOnSelect: '=',
        clearCropSelection: '=',
        focusOn: '=',
        loadingVariable: '=',
        loadingCropsText: '=',
        options: '=',
        allowNew: '=',
        query: '=',
        doesNotHaveButton: '=',
      },
      controller: ['$scope', '$element', '$attrs',
        function ($scope, $element, $attrs) {
          $scope.placeholder = $attrs.placeholder || 'Search crops';
          $scope.buttonValue = $attrs.buttonValue || 'Submit';
          $scope.cropQuery = undefined;

          $scope.firstCrop = undefined;
          //Typeahead search for crops
          $scope.getCrops = function (val) {
            // be nice and only hit the server if
            // length >= 3
            return $http.get('/api/v1/crops', {
              params: {
                filter: val
              }
            }).then(function(res) {
              var crops = [];
              crops = res.data.data;
              if (crops.length === 0 && $scope.allowNew) {
                crops.push({ attributes: {
                  name: val,
                  is_new: true
                } });
              }
              crops = crops.map(function(crop) {
                return cropService.utilities.buildCrop(crop, res.data.included);
              });
              $scope.firstCrop = crops[0];
              return crops;
            })
          };

          $scope.submitCrop = function() {
            if ($scope.firstCrop !== undefined) {
              $scope.cropOnSelect($scope.firstCrop);
            } else {
              $scope.cropOnSelect($scope.cropQuery);
            }
          }

        }
      ],
      templateUrl: '/assets/templates/_crop_search.html',
    }
}])
