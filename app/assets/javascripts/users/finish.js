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

    $scope.placeUserUpload = function(image){
      $scope.user.user_setting.picture = {
        new: true,
        image_url: image
      };
    };

    $scope.submitForm = function(){
      $scope.user.sending = true;

      var params = {
        user: {
          'help_list': $scope.user.help_list,
          'mailing_list': $scope.user.mailing_list
        },
        user_setting: {
          'location': $scope.user.user_setting.location,
          'units': $scope.user.user_setting.units,
        }
      };

      params.featured_image = $scope.user.user_setting.picture.image_url || null;

      console.log('params', params)

      var userCallback = function(success, user){
        $scope.user.sending = false;
        if (success) {
          $scope.user = user;
          window.location.href = '/users/' + $scope.user._id + '/';
        } else {

        }

      };

      userService.updateUser($scope.user._id,
                             params,
                             $scope.alerts,
                             userCallback);
    };
}]);
