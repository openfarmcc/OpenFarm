var openFarmApp = angular.module('openFarmApp', [
  'mm.foundation',
  'ng-rails-csrf',
  'ngS3upload',
  'ngDragDrop',
  'openFarmModule'

]);

var openFarmModule = angular.module('openFarmModule', [
  'ngSanitize'
]);

openFarmModule.factory('userService', ['$http',
  function userService($http) {
    // get the guide specified.
    var getUser = function(userId, alerts, callback){
      $http({
        url: '/api/users/' + userId,
        method: 'GET'
      }).success(function (response) {
        return callback (true, response.user);
      }).error(function (response, code) {
        alerts.push({
          msg: response,
          type: 'warning'
        });
        return callback(false, response, code);
      });
    };

    return {
      'getUser': getUser,
    };

}]);

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
      }],
      templateUrl: '/assets/templates/_multi_checkbox_select.html',
    };
}]);

openFarmModule.directive('alerts', ['$timeout',
  function alerts($timeout) {
    return {
      restrict: 'A',
      require: '?ngModel',
      scope: true,
      controller: ['$scope', '$element', '$attrs',
        function ($scope, $element, $attrs) {
          $scope.closeAlert = function(index) {
            $scope.alerts.splice(index, 1);
          };
          $scope.$watch('alerts.length', function(){
            if ($scope.alerts.length > 0){
              $timeout(function(){
                $scope.alerts = [];
              }, 3000);
            }
          });
      }],
      template:
        '<alert ng-cloak ' +
          'class="ng-cloak columns large-6 large-centered radius float" ' +
          'ng-repeat="alert in alerts" ' +
          'type="alert.type" close="closeAlert($index)">' +
            '<div class=""> {{alert.msg}} </div>' +
        '</alert>'
    };
  }]);

openFarmApp.directive('clearOn', function() {
   return function(scope, elem, attr) {
      scope.$on('clearOn', function(e, name) {
        if(name === attr.clearOn) {
          elem[0].value = '';
        }
      });
   };
});

// Source: http://stackoverflow.com/questions/14833326/how-to-set-focus-on-input-field/14837021#14837021
openFarmApp.directive('focusOn', function() {
   return function(scope, elem, attr) {
      scope.$on('focusOn', function(e, name) {
        if(name === attr.focusOn) {
          elem[0].focus();
        }
      });
   };
});

// Source: http://stackoverflow.com/questions/14833326/how-to-set-focus-on-input-field/14837021#14837021
openFarmApp.directive('autoFocus', function($timeout) {
    return {
        restrict: 'AC',
        link: function(_scope, _element) {
            $timeout(function(){
                _element[0].focus();
            }, 0);
        }
    };
});
