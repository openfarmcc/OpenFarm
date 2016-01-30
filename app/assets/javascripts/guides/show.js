openFarmApp.controller('showGuideCtrl', ['$scope', '$http', 'guideService', '$q',
    'userService', 'gardenService', 'cropService', 'stageService', 'defaultService',
  function showGuideCtrl($scope,
                         $http,
                         guideService,
                         $q,
                         userService,
                         gardenService,
                         cropService,
                         stageService,
                         defaultService) {
    $scope.guideId = getIDFromURL('guides') || GUIDE_ID;
    $scope.userId = USER_ID || undefined;
    $scope.gardenCrop = {};

    $scope.toggleEditingGuide = function() {
      $scope.editing = !$scope.editing;
      $scope.saved = false;
    };

    $scope.setGuideUser = function(success, object){
      if (success){
        $scope.guide.user = object;
      }
    };

    $scope.saveGuideChanges = function() {
      var params = {'data':  {
        'attributes': {
          'overview': $scope.guide.overview,
          'name': $scope.guide.name,
          'practices': $scope.practices.filter(function(practice) {
                         return practice.selected === true;
                       }).map(function(practice) {
                         return practice.slug;
                       })
          }
        }
      };

      guideService.updateGuideWithPromise($scope.guide.id, params)
        .then(function(response) {

          $scope.toggleEditingGuide();

        }, function(response) {
          console.log("error updating guide", response);
        });
    };

    $scope.guideUpdate = function() {
      guideService.getGuideWithPromise($scope.guideId)
        .then($scope.setGuide);
    }

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

      // if ($scope.guide && $scope.guide.stages !== undefined) {
      //   console.log('guide stages exist')
      //   // We're doing this because we don't want to overwrite the
      //   // freshly edited stages. This is pretty dark magic though,
      //   // maybe we don't need it?
      //   var stages = angular.copy($scope.guide.stages)
      //   delete object.stages;
      //   console.log(object.stages, JSON.stringify(stages))
      //   $scope.guide = object;
      //   $scope.guide.stages = stages;
      // } else {
      $scope.guide = object;
      // }



      if ($scope.userId){
        userService.getUser($scope.userId,
                            $scope.setCurrentUser);
      }

      if($scope.guide.user !== undefined) {
        userService.getUser($scope.guide.user.id,
                            $scope.setGuideUser);
      }

      $q.all([
        defaultService.processedDetailOptions(),
        cropService.getCropWithPromise($scope.guide.relationships.crop.data.id)
      ]).then(function(data) {
        $scope.options = data[0];
        $scope.practices = data[0].multiSelectPractices;
        $scope.practices.forEach(function(practice) {
          if ($scope.guide.practices !== null && $scope.guide.practices.indexOf(practice.slug.toLowerCase()) > -1) {
            practice.selected = true;
          }
        });

        $scope.guide.crop = data[1];
      });

      $scope.$watch('guide.stages', function() {
        if ($scope.guide.stages !== undefined) {

          $scope.guide.stages.forEach(function(stage) {

            stageService.getPictures(stage)
              .then(function(pictures) {

                stage.pictures = pictures.map(function(pic) {
                  return pic.attributes;
                });
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
          // $scope.haveTimes = $scope.guide.stages
          //   .sort(function(a, b){ return a.order > b.order; })
          //   .filter(function(s){ return s.stage_length; });

          // $scope.plantLifetime = $scope.haveTimes.reduce(function(pV, cV){
          //   return pV + cV.stage_length;
          // }, 0);
        }
      });
    };

    guideService.getGuideWithPromise($scope.guideId)
      .then($scope.setGuide);
  }]);
