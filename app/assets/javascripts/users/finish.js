openFarmApp.controller('finishCtrl', ['$scope', '$http', 'userService',
  'alertsService',
  function finishCtrl($scope, $http, userService, alertsService) {
    $scope.userId = USER_ID || undefined;

    $scope.setUser = function(success, object){
      if (success){
        $scope.user = object;
        console.log($scope.user);
      }
    };

    userService.getUser($scope.userId,
                        $scope.setUser);

    $scope.placeUserUpload = function(image){
      $scope.user.user_setting.picture = {
        new: true,
        image_url: image
      };
    };

    $scope.submitForm = function(){
      $scope.user.sending = true;

      var params = {
        attributes: {
          'help_list': $scope.user.help_list,
          'mailing_list': $scope.user.mailing_list
        },
        user_setting: {
          'location': $scope.user.user_setting.location,
          'units': $scope.user.user_setting.units,
        }
      };

      if ($scope.user.user_setting.picture) {
        params.featured_image = $scope
          .user.user_setting.picture.image_url || null;
      } else {
        params.featured_image = null
      }

      var userCallback = function(success, user){
        $scope.user.sending = false;
        if (success) {
          $scope.user = user;

          // TODO unhardcode this URL
          window.location.href = '/users/' + $scope.user.id + '/';
        }
      };

      userService.updateUser($scope.user._id,
                             params,
                             userCallback);
    };
}]);
