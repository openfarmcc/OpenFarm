openFarmApp.controller('showCropCtrl', ['$scope', '$http', 'cropService',
  'gardenService', 'userService',
  function newGuideCtrl($scope,
                        $http,
                        cropService,
                        gardenService,
                        userService) {
    $scope.alerts = [];
    $scope.s3upload = '';
    $scope.crop = {};
    $scope.userId = USER_ID || undefined;

    $scope.setCurrentUser = function(success, object){
      if (success){
        $scope.currentUser = object;
      }
    };

    $scope.setCrop = function(success, crop){
      userService.getUser($scope.userId,
                          $scope.alerts,
                          $scope.setCurrentUser);
      $scope.crop = crop;
    };

    cropService.getCrop(getIDFromURL('crops'), $scope.alerts, $scope.setCrop);
  }]);
