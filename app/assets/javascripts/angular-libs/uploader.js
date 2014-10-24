openFarmModule.directive('uploader', ['$http',
  function($http) {
    return {
      restrict: 'A',
      link: function($scope, el, attr) {
        debugger;
      }
    };
}]);


openFarmApp.controller('testbed', function($scope){
    $scope.hey = '[Yahoo. So 90s](http://www.yahoo.com)'
  });
