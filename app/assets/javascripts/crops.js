openFarmApp.controller('cropCtrl', ['$scope', '$http',
  function cropCtrl($scope, $http) {
  $scope.crops = [];

  // Redirect the browser to a specified crop
  //
  $scope.addCropToGarden = function (crop) {
    console.log(crop);
    // options.pathTemplate.replace('ID', slug)
  };

}]);
