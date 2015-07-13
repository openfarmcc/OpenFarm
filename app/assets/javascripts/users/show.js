openFarmApp.controller('profileCtrl', ['$scope', '$rootScope', '$http',
  'userService', 'gardenService',
  function profileCtrl($scope, $rootScope, $http, userService, gardenService) {
    $scope.profileId = PROFILE_ID || undefined;
    $scope.userId = USER_ID || undefined;

    $scope.query = '';

    $scope.setProfileUser = function(success, object){
      if (success){
        $rootScope.profileUser = $scope.profileUser = object;

        if(!object.user_setting.favorite_crop &&
          $scope.profileUser.id === $scope.currentUser.id) {
          $scope.cropNotSet = true;
          $scope.favoriteCrop = undefined;
          if ($scope.profileId === $scope.userId) {
            $scope.editProfile();
          }
        }
      }
    };

    $scope.editProfile = function(){
      $scope.editing = true;
    };

    $scope.setFavoriteCrop = function(item, model, label){
      if ($scope.currentUser.id == $scope.profileUser.id) {
        var favCrop = item;

        var callback = function(success, user) {
          console.log('user', user);
          if(user) {
            $scope.profileUser = user;
            $scope.editing = false;
            $scope.cropNotSet = false;
            $scope.favoriteCrop = user.user_setting.favorite_crop;
          }
        }
        userService.setFavoriteCrop($scope.currentUser.id,
                                    favCrop.id,
                                    callback)
      }
    }


    //
    userService.getUser($scope.userId, function(success, user) {
      $rootScope.currentUser = $scope.currentUser = user;

      userService.getUser($scope.profileId,
                        $scope.setProfileUser);
    });
}]);
