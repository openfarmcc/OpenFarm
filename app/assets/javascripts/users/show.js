openFarmApp.controller('profileCtrl', ['$scope', '$rootScope', '$http', 'userService',
  function profileCtrl($scope, $rootScope, $http, userService) {
    $scope.profileId = PROFILE_ID || undefined;
    $scope.userId = USER_ID || undefined;

    $scope.alerts = [];
    $scope.query = '';

    $scope.setProfileUser = function(success, object){
      if (success){
        $scope.profileUser = object;
        if(!object.user_setting.favorite_crop &&
           $scope.profileUser._id === $scope.currentUser._id) {
          $scope.cropNotSet = true;
          $scope.favoriteCrop = undefined;
          $scope.editProfile();
        }
      }
    };

    $scope.editProfile = function(){
      $scope.editing = true;
    };

    $scope.setFavoriteCrop = function(){
      if ($scope.currentUser._id == $scope.profileUser._id) {
        var favCrop = $scope.crops.filter(function(crop) {
          return crop.name === $scope.query;
        })[0];

        var callback = function(success, user) {
          if(user) {
            $scope.profileUser = user;
            $scope.editing = false;
            $scope.cropNotSet = false;
            $scope.favoriteCrop = user.user_setting.favorite_crop;
          }
        }
        userService.setFavoriteCrop($scope.currentUser._id,
                                    favCrop._id,
                                    $scope.alerts,
                                    callback)
      }
    }



    userService.getUser(USER_ID, $scope.alerts, function(success, user) {
      $scope.currentUser = user;

      userService.getUser(PROFILE_ID,
                        $scope.alerts,
                        $scope.setProfileUser);
    });
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
