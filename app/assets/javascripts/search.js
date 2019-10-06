openFarmApp.controller('searchCtrl', [
  '$scope',
  '$http',
  function searchCtrl($scope, $http) {
    $scope.crops = [];

    // Redirect the browser to a specified crop
    //
    $scope.goToCrop = function(crop) {
      if (crop !== undefined && crop.name !== undefined) {
        location.assign(crop.links.self.website);
      } else if (typeof crop === 'string' || crop instanceof String) {
        location.assign('/crop_search/?q=' + crop);
      } else if (crop === undefined) {
        location.assign('/crop_search/?q=');
      }
      // options.pathTemplate.replace('ID', slug)
    };
  },
]);
