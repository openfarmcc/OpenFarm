openFarmApp.controller('profileCtrl', ['$scope', '$http', 'userService',
  function profileCtrl($scope, $http, userService) {
    $scope.userId = USER_ID || undefined;

    $scope.alerts = [];

    $scope.setUser = function(success, object){
      if (success){
        $scope.user = object;
        console.log(object);
        if(!object.favorite_crop) {
          $scope.cropNotSet = true;
          $scope.editProfile();
        }
      }
    };

    $scope.editProfile = function(){
      $scope.editing = true;
    };

    userService.getUser($scope.userId,
                        $scope.alerts,
                        $scope.setUser);
}]);
