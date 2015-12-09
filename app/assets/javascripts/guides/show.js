openFarmApp.controller('showGuideCtrl', ['$scope', '$http', 'guideService',
    'userService', 'gardenService', 'cropService', 'stageService',
  function showGuideCtrl($scope,
                         $http,
                         guideService,
                         userService,
                         gardenService,
                         cropService,
                         stageService) {
    $scope.guideId = getIDFromURL('guides') || GUIDE_ID;
    $scope.userId = USER_ID || undefined;
    $scope.gardenCrop = {};

    $scope.setGuideUser = function(success, object){
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
        if ($scope.guide.basic_needs){
          $scope.guide.basic_needs.forEach(function(b){
            if (b.percent < 0.5){
              switch (b.name){
                case 'Sun / Shade':
                  b.tooltip = 'Low compatibility with "' + b.garden +
                  '" because it gets ' + b.user;
                  break;
                case 'Location':
                  b.tooltip = 'Low compatibility with "' + b.garden +
                  '" because it is ' + b.user;
                  break;
                case 'Soil Type':
                  b.tooltip = 'Low compatibility with "' + b.garden +
                  '" because it has ' + b.user + ' soil';
                  break;
                case 'Practices':
                  b.tooltip = 'Low compatibility with "' + b.garden +
                  '" because you don\'t follow ' + b.user + ' practices there';
                  break;
              }
            }

            if (b.percent >= 0.5 && b.percent < 0.75){
              switch (b.name){
                case 'Sun / Shade':
                  b.tooltip = 'Medium compatibility with "' + b.garden +
                  '" because it gets ' + b.user;
                  break;
                case 'Location':
                  b.tooltip = 'Medium compatibility with "' + b.garden +
                  '" because it is ' + b.user;
                  break;
                case 'Soil Type':
                  b.tooltip = 'Medium compatibility with "' + b.garden +
                  '" because it has ' + b.user + ' soil';
                  break;
                case 'Practices':
                  b.tooltip = 'Medium compatibility with "' + b.garden +
                  '" because you follow ' + b.user +
                  ' and other practices there';
                  break;
              }
            }

            if (b.percent >= 0.75){
              switch (b.name){
                case 'Sun / Shade':
                  b.tooltip = 'High compatibility with "' + b.garden +
                  '" because it gets ' + b.user;
                  break;
                case 'Location':
                  b.tooltip = 'High compatibility with "' + b.garden +
                  '" because it is ' + b.user;
                  break;
                case 'Soil Type':
                  b.tooltip = 'High compatibility with "' + b.garden +
                  '" because it has ' + b.user + ' soil';
                  break;
                case 'Practices':
                  b.tooltip = 'High compatibility with "' + b.garden +
                  '" because you follow only ' + b.user + ' practices there';
                  break;
              }
            }
          });
        }
      }
    };

    $scope.setGuide = function(object){

      if ($scope.userId){
        userService.getUser($scope.userId,
                            $scope.setCurrentUser);
      }

      $scope.guide = object;
      if($scope.guide.user !== undefined) {
        userService.getUser($scope.guide.user.id,
                            $scope.setGuideUser);
      }

      cropService.getCrop($scope.guide.relationships.crop.data.id,
                          function(success, crop) {
                            $scope.guide.crop = crop;
                          });
      console.log($scope.guide);
      $scope.$watch('guide.stages', function() {
        if ($scope.guide.stages !== undefined) {
          $scope.guide.stages.forEach(function(stage) {
            stageService.getPictures(stage)
              .then(function(pictures) {
                // console.log('in show', pictures);
                stage.pictures = pictures.map(function(pic) {
                  return pic.attributes;
                });
                // console.log(stage.pictures, $scope.guide.stages[0].pictures);
              });
          });
          // This is a hack because stages get built from the
          // API. This is kind of flawed still at the moment,
          // and probably a suitable place to do the next refactor.
          // All of these services can probably be "promise-fied"
          // Basically what's happening here is we're making sure that
          // guides.stages isn't just made up from yet-to-be-loaded stages

          // $scope.isNotUndefined = $scope.guide.stages.filter(function(s) {
          //   return undefined !== s
          // }).length === $scope.guide.stages.length;
          // console.log($scope.isNotUndefined);
          if (true) {
            $scope.haveTimes = $scope.guide.stages
              .sort(function(a, b){ return a.order > b.order; })
              .filter(function(s){ return s.stage_length; });

            $scope.plantLifetime = $scope.haveTimes.reduce(function(pV, cV){
              return pV + cV.stage_length;
            }, 0);
          }

        }
      });

    };

    guideService.getGuideWithPromise($scope.guideId)
      .then($scope.setGuide);
  }]);
