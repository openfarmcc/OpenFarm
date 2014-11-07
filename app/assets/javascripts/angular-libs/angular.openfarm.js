var openFarmApp = angular.module('openFarmApp', [
  'mm.foundation',
  'ng-rails-csrf',
  'ngS3upload',
  'openFarmModule'
]);

var openFarmModule = angular.module('openFarmModule', [
  'ngSanitize'
]);

openFarmModule.factory('guideService', ['$http',
  function guideService($http) {
    // get the guide specified.
    var getGuide = function(guideId, alerts, callback){
      $http({
        url: '/api/guides/' + guideId,
        method: 'GET'
      }).success(function (response) {
        return callback (true, response.guide);
      }).error(function (response, code) {
        alerts.push({
          msg: code + ' error. Could not retrieve data from server. ' +
            'Please try again later.',
          type: 'warning'
        });
      });
    };
    return {
      'getGuide': getGuide
    };
}]);

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
    return {
      'getCrop': getCrop
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

openFarmModule.factory('gardenService', ['$http',
  function gardenService($http) {
    var saveGarden = function(garden, alerts, callback){
      var url = '/api/gardens/' + garden._id;
      var data = {
        'description': garden.description || null,
        'type': garden.type || null,
        'location': garden.location || null,
        'average_sun': garden.average_sun || null,
        'ph': garden.ph || null,
        'soil_type': garden.soil_type || null
      };
      $http.put(url, data)
        .success(function (response, object) {
          alerts.push({
            'type': 'success',
            'msg': 'Success!'
          });
          if (callback){
            return callback(response, object);
          }
        })
        .error(function (response, code){
          alerts.push({
            'type': 'alert',
            'msg': response
          });
          if (callback){
            return callback(response, code);  
          }
        });
    };
    var saveGardenCrop = function(garden, gardenCrop, alerts, callback){
      // TODO: this is on pause until there's a way to 
      // actually add crops and guides to a garden.
      var url = '/api/gardens/'+ garden._id +
                '/garden_crops/' + gardenCrop._id;
      $http.put(url, gardenCrop)
        .success(function (response, object) {
          alerts.push({
            'type': 'success',
            'msg': 'Success!'
          });
          if (callback){
            return callback(response, object);
          }
        })
        .error(function (response, code){
          alerts.push({
            'type': 'alert',
            'msg': response
          });
          if (callback){
            return callback(response, code);  
          }
        });
    };

    var addGardenCropToGarden = function(garden, guide, alerts, callback){
      var data = {
        'guide_id': guide._id
      };
      $http.post('/api/gardens/' + garden._id +'/garden_crops/', data)
        .success(function(success, response){
          alerts.push({
            'type': 'success',
            'msg': 'Success!'
          });
          if (callback){
            return callback(success, response);  
          }
        })
        .error(function(response, code){
          alerts.push({
            'type': 'alert',
            'msg': response
          });
          if (callback){
            return callback(success, response);  
          }
        });
    };

    var deleteGardenCrop = function(garden, gardenCrop, alerts, callback){
      var url = '/api/gardens/'+ garden._id +
                '/garden_crops/' + gardenCrop._id;
      $http.delete(url)
        .success(function(response, object){
          alerts.push({
            'type': 'success',
            'msg': 'Deleted crop',
          });
          if (callback){
            return callback(true, response, object);  
          }
        })
        .error(function(response, code){
          alerts.push({
            'type': 'alert',
            'msg': response
          });
          if (callback){
            return callback(false, response, code);  
          }
        });
    };
    return {
      'saveGarden': saveGarden,
      'saveGardenCrop': saveGardenCrop,
      'addGardenCropToGarden': addGardenCropToGarden,
      'deleteGardenCrop': deleteGardenCrop
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
      template: '<input type="text"'+
             'ng-model="location"'+
             'autocomplete="off"'+
             'id="location"'+
             'placeholder="Ex: Hanoi, Portland, California"'+
             'typeahead="address for address in addresses"'+
             'ng-change="getLocation(location)"'+
             'typeahead-min-length="3"'+
             'typeahead-loading="loadingLocations"'+
             'typeahead-wait-ms="555"'+
             'name="location">'+
             '<i ng-show="loadingLocations" '+
               'class="fa fa-refresh" ng-bind="loadingText"></i>',
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
          'class="ng-cloak columns large-6 centered radius float" ' +
          'ng-repeat="alert in alerts" ' +
          'type="alert.type" close="closeAlert($index)">' +
            '<div class=""> {{alert.msg}} </div>' +
        '</alert>'
    };
  }]);