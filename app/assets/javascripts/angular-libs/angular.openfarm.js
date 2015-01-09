var openFarmApp = angular.module('openFarmApp', [
  'mm.foundation',
  'ng-rails-csrf',
  'ngS3upload',
  'openFarmModule'
]);

var openFarmModule = angular.module('openFarmModule', [
  'ngSanitize'
]);

openFarmModule.factory('cropService', ['$http',
  function cropService($http) {
    // get the guide specified.
    var getCrop = function(cropId, alerts, callback){
      $http({
        url: '/api/crops/' + cropId,
        method: 'GET'
      }).success(function (response) {
        return callback (true, response.crop);
      }).error(function (response, code) {
        alerts.push({
          msg: code + ' error. Could not retrieve data from server. ' +
            'Please try again later.',
          type: 'warning'
        });
      });
    };

    var updateCrop = function(cropId, params, alerts, callback){
      $http.put('/api/crops/' + cropId + '/', params)
      .success(function (response) {
        return callback (true, response.crop);
      })
      .error(function (response, code) {
        console.log(response, code);
        var msg = '';
        angular.forEach(response, function(value){
          msg += value;
        });
        alerts.push({
          msg: msg,
          type: 'warning'
        });
      });
    };
    return {
      'getCrop': getCrop,
      'updateCrop': updateCrop
    };
}]);

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
      scope: true,
      controller: ['$scope', '$element', '$attrs',
        function ($scope, $element, $attrs) {
          $scope.loadingText = $attrs.loadingText;
          $scope.getLocation = function(val) {
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
