openFarmApp.controller('showGuideCtrl', ['$scope', '$http', 'guideService',
    'userService', 'gardenService',
  function showGuideCtrl($scope,
                         $http,
                         guideService,
                         userService,
                         gardenService) {
    $scope.guideId = getIDFromURL('guides') || GUIDE_ID;
    $scope.userId = USER_ID || undefined;
    $scope.alerts = [];
    $scope.gardenCrop = {};

    $scope.setUser = function(success, object){
      if (success){
        $scope.guide.user = object;
      }
    };

    $scope.setCurrentUser = function(success, object){
      if (success){
        $scope.currentUser = object;

        $scope.currentUser.gardens.forEach(function(g){
          g.garden_crops.forEach(function(gc){
            if (gc.guide._id === $scope.guide._id){
              g.added = true;
              $scope.gardenCrop = gc;
            }
          });
        });
      }
    };

    $scope.setGuide = function(success, object){
      if (success){
        $scope.guide = object;
        userService.getUser($scope.guide.user_id,
                            $scope.alerts,
                            $scope.setUser);

        $scope.haveTimes = $scope.guide.stages
          .sort(function(a, b){ return a.order > b.order; })
          .filter(function(s){
            return s.stage_length;
          });

        $scope.plantLifetime = $scope.haveTimes.reduce(function(pV, cV){
          return pV.stage_length + cV.stage_length;
        });
      }
    };

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
          $scope.guide,
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

    if ($scope.userId){
      userService.getUser($scope.userId,
                          $scope.alerts,
                          $scope.setCurrentUser);
    }

    guideService.getGuide($scope.guideId, $scope.alerts, $scope.setGuide);
  }]);
