var guidesApp = angular.module('guidesApp', [
  'mm.foundation', 
  'ng-rails-csrf'
  ]);

guidesApp.config(['$httpProvider', function($httpProvider) {
    // $httpProvider.defaults.useXDomain = true;
    delete $httpProvider.defaults.headers.common['X-Requested-With'];
}]);


guidesApp.controller('newGuideCtrl', ['$scope', '$http', 
  function guidesApp($scope, $http) {

  $scope.crops = [];
  $scope.step = 1;

  $scope.new_guide = {
    name: '',
    crop: undefined,
    overview: '',
    user: USER_ID
  };

  //Typeahead search for crops
  $scope.search = function () {
    // be nice and only hit the server if
    // length >= 3
    if ($scope.query.length >= 3){
      $http({
        url: '/api/crops',
        method: "GET",
        params: {
          query: $scope.query
        }
      }).success(function (response) {
        $scope.crops = response.crops;
      }).error(function (response, code) {
        alert(code + ' error. Could not retrieve data from server. Please try again later.');
      });
    }
  };

  //Gets fired when user selects dropdown.
  $scope.cropSelected = function ($item, $model, $label) {
    $scope.new_guide.crop = $item;
  };

  $scope.nextStep = function(){
    $scope.step += 1;
  }

  $scope.submitForm = function () {
    $http({
      url: '/api/guides',
      method: "POST",
      params: {
        name: $scope.new_guide.name,
        crop_id: $scope.new_guide.crop._id,
        overview: $scope.new_guide.overview
      }
    }).success(function (r) {
      window.location.href = "/guides/" + r.guide._id + "/edit/";
    }).error(function (r) {
      alert(r.error);
    });
  };

  // Any function returning a promise object can be used to load values asynchronously
  $scope.getLocation = function(val) {
    return $http.get('http://maps.googleapis.com/maps/api/geocode/json', {
      params: {
        address: val,
        sensor: false
      }
    }).then(function(res){
      var addresses = [];
      angular.forEach(res.data.results, function(item){
        addresses.push(item.formatted_address);
      });
      return addresses;
    });
  };


}]);

guidesApp.controller('showGuideCtrl', 
  function guidesApp($scope, $http){
    
  });
