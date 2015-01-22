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

        $scope.currentUser.gardens.forEach(function(garden){
          garden.garden_crops.forEach(function(gardenCrop){
            console.log(gardenCrop);
            if (gardenCrop.crop && gardenCrop.crop._id === $scope.crop._id){
              garden.added = true;
              $scope.gardenCrop = gardenCrop;
            }
          });
        });
      }
    };

    $scope.setCrop = function(success, crop){
      console.log('setting crop');
      userService.getUser($scope.userId,
                          $scope.alerts,
                          $scope.setCurrentUser);
      $scope.crop = crop;
    };

    // TODO: this can be cleaned up. It's duplicated in
    // guides/show.js. Either create a directive or put
    // it in the gardenService.

    $scope.toggleGarden = function(garden){
      garden.adding = true;
      if (!garden.added){
        var callback = function(success){
          if (success){
            garden.adding = false;
            garden.added = true;
          }
        };
        gardenService.addGardenCropToGarden(garden,
          'crop',
          $scope.crop,
          $scope.alerts,
          callback);
      } else {
        gardenService.deleteGardenCrop(garden,
          $scope.gardenCrop,
          $scope.alerts,
          function(){
            garden.adding = false;
            garden.added = false;
          });
      }
    };

    cropService.getCrop(getIDFromURL('crops'), $scope.alerts, $scope.setCrop);
  }]);
