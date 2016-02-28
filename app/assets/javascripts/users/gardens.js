openFarmApp.controller('gardenCtrl', ['$scope', '$http', '$rootScope',
  'userService', 'gardenService', 'cropService',
  function gardenCtrl($scope,
                      $http,
                      $rootScope,
                      userService,
                      gardenService,
                      cropService) {
    $scope.addingGarden = false;
    $scope.newGarden = {};

    // $scope.profileUser = $rootScope.profileUser;
    // $scope.currentUser = $rootScope.currentUser;

    $scope.toggleAddGarden = function() {
      $scope.addingGarden = !$scope.addingGarden;
    }

    $scope.$watch('profileUser', function(){
      if($rootScope.profileUser) {
        gardenService.getGardensForUser($rootScope.profileUser,
          function(success, response) {
            if(success) {
              console.log(response)
              $scope.profileUser.gardens = response;

              $scope.profileUser.gardens.forEach(function(garden){
                // set the pH if it hasn't been set.
                if (!garden.ph){
                  garden.ph = 7.5;
                }

                garden.garden_crops.forEach(function(garden_crop){
                  var callback = function(success, response){
                    garden_crop.guide.crop = response;
                  };
                  // We only need to fetch the crop if the garden_crop doesn't
                  // already have a crop associated with it.
                  if (garden_crop.guide){
                    cropService.getCrop(garden_crop.guide.crop_id,
                                        callback);
                  }
                });
              });
            }
          });
      }
    });

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
          // way easier for now
          $scope.currentUser.gardens.push(garden);
          $scope.profileUser.gardens.push(garden);
          $scope.newGarden = {};
          $scope.addingGarden = false;
        }
      };
      gardenService.createGarden(newGarden, callback);
    };

    $scope.saveGarden = function(garden){
      garden.location = garden.location === '' ? null : garden.location
      garden.location = garden.description === '' ? null : garden.description
      garden.location = garden.average_sun === '' ? null : garden.average_sun
      garden.location = garden.soil_type === '' ? null : garden.soil_type
      garden.location = garden.type === '' ? null : garden.type
      gardenService.saveGarden(garden);
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
        gardenService.deleteGarden(garden, removeFromGardens);
      }
    };

    $scope.saveGardenCropChanges = function(garden){
      angular.forEach(garden.garden_crops, function(crop){
        gardenService.saveGardenCrop(garden,
                                     crop);
      });
    };

    $scope.deleteSelected = function(garden){
      garden.garden_crops.forEach(function(crop){
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
