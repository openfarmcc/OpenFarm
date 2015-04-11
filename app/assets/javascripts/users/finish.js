openFarmApp.controller('finishCtrl', ['$scope', '$http', 'userService',
  function finishCtrl($scope, $http, userService) {
    $scope.userId = USER_ID || undefined;

    $scope.alerts = [];

    $scope.setUser = function(success, object){
      if (success){
        $scope.user = object;
        console.log($scope.user);
      }
    };

    userService.getUser($scope.userId,
                        $scope.alerts,
                        $scope.setUser);
}]);
