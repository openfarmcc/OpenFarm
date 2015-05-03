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

  // Redirect the browser to a specified crop
  //
  // pathTemplate is a string template for a crop path, 
  //              with the text "ID" representing where the url slug should go
  $scope.goToCrop = function (crop, pathTemplate) {
    var slug = crop._slugs.length > 0 ? crop._slugs[0] : crop._id;
    location.assign( pathTemplate.replace('ID', slug) );
  };
}]);
