var guidesApp = angular.module('guidesApp', [
  'mm.foundation',
  'ng-rails-csrf'
  ]);

guidesApp.controller('newGuideCtrl', ['$scope', '$http',
  function guidesApp($scope, $http, $location) {
  $scope.alerts = [];
  $scope.crops = [];
  $scope.step = 1;
  $scope.crop_not_found = false;
  $scope.addresses = [];

  $scope.new_guide = {
    name: '',
    crop: undefined,
    overview: ''
  };

  if (getUrlVar("crop_id")){
    $http.get('/api/crops/' + getUrlVar("crop_id"))
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

    // $scope.default_crop = $location.search().crop_id;
  }

  $scope.$watch('loadingCrops', function(){
    // console.log($scope.loadingCrops);
  })

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
    $scope.new_guide.crop.description = '';
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
          name: $scope.new_guide.name,
          crop_id: $scope.new_guide.crop._id,
          overview: $scope.new_guide.overview || null,
          location: $scope.new_guide.location || null
      }
    $http.post('/api/guides/', params)
      .success(function (r) {
        // console.log(r);
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

  var geocoder = new google.maps.Geocoder();

  // Any function returning a promise object can be used to load values asynchronously
  $scope.getLocation = function(val) {
    console.log('val', val);
    if (geocoder) {
      geocoder.geocode({ 'address': val }, function (results, status) {
        if (status == google.maps.GeocoderStatus.OK) {
            var addresses = [];
            angular.forEach(results, function(item){
              addresses.push(item.formatted_address);
            })
            console.log('addresses');
            $scope.addresses = addresses;
         }
         else {
            console.log("Geocoding failed: " + status);
         }
        
      });
    }
  };

  $scope.cancel = function(path){
    window.location.href = path || '/';
  }

  
}]);

