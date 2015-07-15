openFarmApp.directive('guidesStage', ['$http', '$location', '$rootScope', 'defaultService',
  function guidesActions($http, $location, $rootScope, defaultService) {
    return {
      restrict: 'A',
      scope: {
        stage: '=',
        stages: '=',
        guideExists: '=',
        texts: '='
      },
      controller: ['$scope', '$element', '$attrs',
        function ($scope, $element, $attrs) {
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

          $scope.editSelectedStage = function(chosenStage){
            console.log('editing');
            $scope.stages.forEach(function(stage){
              stage.editing = false;
              if (chosenStage.name === stage.name){
                stage.editing = true;

                $scope.currentStage = chosenStage;
              }

            });
          };

          $scope.nextStep = function(){
            $rootScope.step += 1;
            $location.hash($rootScope.step);
          }

          $scope.nextStage = function(stage){
            var nextStage = $scope.stages[stage.nextSelectedIndex];
            transferStageValuesIfNoneExist(stage, nextStage);
            $scope.editSelectedStage(nextStage);
            scrollToTop();
          };

          var scrollToTop = function(){
            window.scrollTo($('.guides').scrollTop(), 0);
          }
        }
      ],
      templateUrl: '/assets/angular-libs/guides/new/guides.new.stage.template.html'
    }
  }
])
