// Used for creating a new guide. Does things like typeahead search and form validation and stuff
var guidesApp = angular.module('guidesApp', ['mm.foundation', 'ng-rails-csrf']);

guidesApp.controller('newGuideCtrl', function guidesApp($scope, $http) {

  $scope.crops = [];

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
      window.location.href = r.guide._id;
    }).error(function (r) {
      alert(r.error);
    });
  };
});
