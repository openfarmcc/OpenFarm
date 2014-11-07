openFarmApp.controller('gardenCtrl', ['$scope', '$http', 'userService',
  'gardenService', 'cropService',
  function gardenCtrl($scope,
                      $http,
                      userService,
                      gardenService,
                      cropService) {

    $scope.alerts = [];

    $scope.initCallback = function(success, user){
      $scope.currentUser = user;
      $scope.gardens = user.gardens;
      angular.forEach(user.gardens, function(garden){
        angular.forEach(garden.garden_crops, function(crop){
          var callback = function(success, response){
            crop.guide.crop = response;
          };
          cropService.getCrop(crop.guide.crop_id, $scope.alerts, callback);
        });
      });
    };
    userService.getUser(USER_ID, $scope.alerts, $scope.initCallback);

    $scope.selectAll = function(garden){
      angular.forEach(garden.garden_crops, function(crop){
        crop.selected = garden.selectAll;
      });
      $scope.checkSelected(garden);
    };

    $scope.checkSelected = function(garden){
      garden.selected = false;
      angular.forEach(garden.garden_crops, function(crop){
        if (crop.selected === true){
          garden.selected = true;
        }
      });
      if (garden.selected === false){
        garden.selectAll = false;
      }
    };

    $scope.saveGarden = function(garden){
      gardenService.saveGarden(garden, $scope.alerts);
      // $scope.saveGardenCropChanges(garden);
    };

    $scope.saveGardenCropChanges = function(garden){
      angular.forEach(garden.garden_crops, function(crop){
        gardenService.saveGardenCrop(garden,
                                     crop,
                                     $scope.alerts);
      });
    };

    $scope.deleteSelected = function(garden){
      angular.forEach(garden.garden_crops, function(crop){
        if (crop.selected && !crop.hide){
          var removeFromList = function(success){
            console.log(success);
            if (success){
              // don't quite want to deal with splicing arrays
              // across different function calls
              crop.hide = true;
              console.log(crop);
            }
          };
          gardenService.deleteGardenCrop(garden,
                                         crop,
                                         $scope.alerts,
                                         removeFromList);
        }
      });
    };
}]);
