openFarmApp.controller('gardenCtrl', ['$scope', '$http', 'userService',
  'gardenService', 'cropService',
  function gardenCtrl($scope,
                      $http,
                      userService,
                      gardenService,
                      cropService) {

    $scope.alerts = [];
    $scope.newGarden = {};

    $scope.initCallback = function(success, user){
      $scope.currentUser = user;

      $scope.gardens = user.gardens;

      angular.forEach(user.gardens, function(garden){
        // set the pH if it hasn't been set.
        if (!garden.ph){
          garden.ph = 7.5;
        }

        angular.forEach(garden.garden_crops, function(garden_crop){
          var callback = function(success, response){
            garden_crop.guide.crop = response;
          };
          // We only need to fetch the crop if the garden_crop doesn't already
          // have a crop associated with it.
          if (garden_crop.guide){
            cropService.getCrop(garden_crop.guide.crop_id,
                                $scope.alerts,
                                callback);
          }
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

    $scope.createGarden = function(newGarden){
      var callback = function(success, garden){
        if (success){
          $scope.currentUser.gardens.push(garden);
        }
      };
      gardenService.createGarden(newGarden, $scope.alerts, callback);
    };

    $scope.saveGarden = function(garden){
      gardenService.saveGarden(garden, $scope.alerts);
    };

    $scope.destroyGarden = function(index, garden){
      // TODO: This needs to be made translatable.
      var answer = confirm('Permanently delete garden ' + garden.name +
                           '? All crops stored in your garden will be ' +
                           'destroyed as well.');
      var removeFromGardens = function(){
        // Don't want to deal with splicing arrays,
        // And also, this allows for 'undo' functionality in the future.
        garden.hide = true;
      };
      if (answer){
        gardenService.deleteGarden(garden, $scope.alerts, removeFromGardens);
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
        if (crop.selected && !crop.hide){
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

    $scope.handleNewGardenImage = function(garden, image){
      garden.pictures.push({
        image_url: image,
        new: true
      });
    };
}]);
