openFarmApp.directive('guidesStage', ['$http', '$location', '$rootScope',
  function guidesActions($http, $location, $rootScope) {
    return {
      restrict: 'A',
      scope: {
        stage: '=',
        stages: '=',
        guideExists: '=',
        texts: '='
      },
      controller: ['$scope',
        function ($scope) {
          $scope.placeStageUpload = function(stage, image){
            if (!stage.pictures){
              stage.pictures = [];
            }
            stage.pictures.push({
              new: true,
              image_url: image
            });
          };

          $scope.placeStageActionUpload = function(action, image){
            if (!action.pictures){
              action.pictures = [];
            }
            action.pictures.push({
              new: true,
              image_url: image
            });
          };

          var transferStageValuesIfNoneExist = function(stage, nextStage) {
            if (!$scope.guideExists) {
              nextStage.environment = stage.environment;
              nextStage.light = stage.light;
              nextStage.soil = stage.soil;
            }
          }
          $scope.nextStage = function(stage){
            var nextStage = $scope.stages[stage.nextSelectedIndex];
            transferStageValuesIfNoneExist(stage, nextStage);
            $scope.editSelectedStage(nextStage);
            // scrollToTop();
          };

          $scope.editSelectedStage = function(chosenStage){
            $scope.stages.forEach(function(stage){
              stage.editing = false;
              if (chosenStage.name === stage.name){
                stage.editing = true;

                $scope.currentStage = chosenStage;
              }

            });
          };
        }
      ],
      templateUrl: '/assets/angular-libs/guides/new/guides.new.stage.template.html'
    }
  }
])
