var guidesApp = angular.module('guidesApp', [
  'mm.foundation', 
  'ng-rails-csrf'
  ]);

guidesApp.config(['$httpProvider', '$locationProvider', 
  function($httpProvider, $locationProvider) {
    // TODO: This probably has something to do with why Google's 
    // Location APIs aren't working
    // $httpProvider.defaults.useXDomain = true;
    // delete $httpProvider.defaults.headers.common['X-Requested-With'];
    $locationProvider.html5Mode(true); 
}]);

guidesApp.controller('newGuideCtrl', ['$scope', '$http', '$location',  
  function guidesApp($scope, $http, $location) {
  $scope.alerts = [];
  $scope.crops = [];
  $scope.step = 1;
  $scope.crop_not_found = false;

  $scope.new_guide = {
    name: '',
    crop: undefined,
    overview: ''
  };

  if ($location.search().crop_id){
    $http.get('/api/crops/' + $location.search().crop_id)
      .success(function(r){
        console.log(r);
        $scope.new_guide.crop = r.crop;
        $scope.query = r.crop.name;
      })
      .error(function(r, e){
        $scope.alerts.push({
          msg: e,
          type: 'alert'
        });
        console.log(e);
      });

    $scope.default_crop = $location.search().crop_id;
  }

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
        console.log(response.crops);
        if (response.crops.length){
          $scope.crops = response.crops;
        } else {
          $scope.crop_not_found = true;
        }
      }).error(function (response, code) {
        $scope.alerts.push({
          msg: code + ' error. Could not retrieve data from server. Please try again later.',
          type: 'warning'
        });
      });
    }
  };

  //Gets fired when user selects dropdown.
  $scope.cropSelected = function ($item, $model, $label) {
    $scope.new_guide.crop = $item;
    $scope.crop_not_found = false;
  };

  $scope.createCrop = function(){
    window.location.href = '/crops/new/?name=' + $scope.query;
  }

  $scope.nextStep = function(){
    $scope.step += 1;
  }
  $scope.previousStep = function(){
    $scope.step -= 1;
  }

  $scope.submitForm = function () {
    var params = {
      "guide": {
          name: $scope.new_guide.name,
          crop_id: $scope.new_guide.crop._id,
          overview: $scope.new_guide.overview
      }
    };
    $http.post('/api/guides/', params)
      .success(function (r) {        
        window.location.href = "/guides/" + r.guide._id + "/edit/";
      })
      .error(function (r) {
        $scope.alerts.push({
          msg: r.error,
          type: 'alert'
        });
        console.log(r.error);
      });
  };

  $scope.closeAlert = function(index) {
    $scope.alerts.splice(index, 1);
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

