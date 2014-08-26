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
    $http({
      url: '/api/crops',
      method: "GET",
      params: {
        query: $scope.query
      }
    }).success(function (r) {
      $scope.crops = r;
    }).error(function (r) {
      alert('Could not retrieve data from server. Please try again later.');
    });
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
      window.location.href = r._id;
    }).error(function (r) {
      alert(r.error);
    });
  };
});
