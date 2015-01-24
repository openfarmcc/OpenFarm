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
            if (gc.guide && gc.guide._id === $scope.guide._id){
              g.added = true;
              $scope.gardenCrop = gc;
            }
          });
        });

        $scope.guide.basic_needs.forEach(function(b){
          if (b.percent < 0.5){
            switch (b.name){
              case 'Sun / Shade':
                b.tooltip = 'Low because you have ' + b.user;
                break;
              case 'Location':
                b.tooltip = 'Low because your garden is ' + b.user;
                break;
              case 'Soil Type':
                b.tooltip = 'Low because you have ' + b.user + ' soil.';
                break;
              case 'Practices':
                b.tooltip = 'You don\'t follow these practices in any '+
                            'of your gardens';
                break;
            }
          }

          if (b.percent >= 0.5 && b.percent < 0.75){
            switch (b.name){
              case 'Sun / Shade':
                b.tooltip = 'Medium because you have ' + b.user;
                break;
              case 'Location':
                b.tooltip = 'Medium because your garden is ' + b.user;
                break;
              case 'Soil Type':
                b.tooltip = 'Medium because you have ' + b.user + ' soil.';
                break;
              case 'Practices':
                b.tooltip = 'You follow some of these practices in '+
                            'your gardens';
                break;
            }
          }

          if (b.percent >= 0.75){
            switch (b.name){
              case 'Sun / Shade':
                b.tooltip = 'High because you have ' + b.user;
                break;
              case 'Location':
                b.tooltip = 'High because your garden is ' + b.user;
                break;
              case 'Soil Type':
                b.tooltip = 'High because you have ' + b.user + ' soil.';
                break;
              case 'Practices':
                b.tooltip = 'You follow some of these practices in '+
                            'your gardens';
                break;
            }
          }
        });
      }
    };

    $scope.setGuide = function(success, object){
      if (success){

        if ($scope.userId){
          userService.getUser($scope.userId,
                              $scope.alerts,
                              $scope.setCurrentUser);
        }
        $scope.guide = object;
        userService.getUser($scope.guide.user_id,
                            $scope.alerts,
                            $scope.setUser);

        $scope.haveTimes = $scope.guide.stages
          .sort(function(a, b){ return a.order > b.order; })
          .filter(function(s){ return s.stage_length; });

        $scope.plantLifetime = $scope.haveTimes.reduce(function(pV, cV){
          return pV + cV.stage_length;
        }, 0);
      }
    };

    // TODO: this can be cleaned up. It's duplicated in
    // crops/show.js. Either create a directive or put
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
          'guide',
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

    guideService.getGuide($scope.guideId, $scope.alerts, $scope.setGuide);
  }]);
