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

    $scope.setCurrentUser = function(object){
      $scope.currentUser = object;
    };

    $scope.setCrop = function(success, crop){
      userService.getUserWithPromise($scope.userId)
        .then($scope.setCurrentUser)

      $scope.crop = crop;
    };

    cropService.getCrop(getIDFromURL('crops'), $scope.setCrop);
  }]);
