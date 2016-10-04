openFarmApp.controller('addCropCtrl', ['$scope',
  function cropCtrl($scope) {
  $scope.crops = [];

  // Redirect the browser to a specified crop
  //
  $scope.addCropToGarden = function (crop) {
    console.log(crop);
    // options.pathTemplate.replace('ID', slug)
  };

}]);
