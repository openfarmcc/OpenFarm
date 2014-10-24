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
    var getGuide = function(guide_id, callback){
      $http({
        url: '/api/guides/' + guide_id,
        method: "GET"
      }).success(function (response) {
        return callback (true, response.guide);
      }).error(function (response, code) {
        return callback(false, response, code);
      });
    };
    return {
      "getGuide": getGuide
    };
}]);

openFarmModule.factory('userService', ['$http',
  function userService($http) {

    // get the guide specified.
    var getUser = function(user_id, callback){
      $http({
        url: '/api/users/' + user_id,
        method: "GET"
      }).success(function (response) {
        return callback (true, response.user);
      }).error(function (response, code) {
        return callback(false, response, code);
      });
    };
    return {
      "getUser": getUser
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
                    console.log("Geocoding failed: " + status);
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





