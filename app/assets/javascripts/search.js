openFarmApp.controller('searchCtrl', ['$scope', '$http',
  function searchCtrl($scope, $http) {
  $scope.crops = [];

  //Typeahead search for crops
  $scope.search = function (val) {
    // be nice and only hit the server if
    // length >= 3
    if ($scope.query.length >= 3){
      $http({
        url: '/api/v1/crops',
        method: "GET",
        params: {
          filter: val
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
  $scope.goToCrop = function (crop, model, label, options) {

    console.log('crop', crop)

    var slug = crop.slug ? crop.slug : crop.id;
    location.assign( options.pathTemplate.replace('ID', slug) );
  };
}]);
