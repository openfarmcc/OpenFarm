openFarmApp.factory('focus', ['$rootScope', '$timeout',
  function ($rootScope, $timeout) {
    return function(name) {
      $timeout(function (){
        $rootScope.$broadcast('focusOn', name);
      });
    };
}]);

