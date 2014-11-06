openFarmApp.controller('gardenCtrl', ['$scope', '$http', 'userService',
  'gardenService', 'cropService',
  function gardenCtrl($scope,
                      $http,
                      userService,
                      gardenService,
                      cropService) {

    $scope.alerts = [];

    $scope.init = function(success, user){
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
    userService.getUser(USER_ID, $scope.alerts, $scope.init);

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

    $scope.saveGardenCropChanges = function(garden){
      angular.forEach(garden.garden_crops, function(crop){
        gardenService.saveGardenCrop(garden,
                                     crop,
                                     $scope.alerts);
      });
    };

    $scope.deleteSelected = function(garden){
      angular.forEach(garden.garden_crops, function(crop){
        if (crop.selected){
          var removeFromList = function(success){
            if (success){
              // don't quite want to deal with splicing arrays
              // across different function calls
              crop.hide = true;  
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
