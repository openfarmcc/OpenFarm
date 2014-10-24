openFarmApp.controller('searchCtrl', ['$scope', '$http',
  function searchCtrl($scope, $http) {
  $scope.crops = [];
   
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
        }
      });
    }
  };    
}]);
