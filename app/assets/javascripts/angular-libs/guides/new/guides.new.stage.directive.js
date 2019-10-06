openFarmApp.directive('guidesStage', [
  '$http',
  '$location',
  '$rootScope',
  function guidesActions($http, $location, $rootScope) {
    return {
      restrict: 'A',
      scope: {
        stage: '=',
        stages: '=',
        guideExists: '=',
        texts: '=',
      },
      controller: [
        '$scope',
        function($scope) {
          $scope.viewingStageOverview = true;

          var transferStageValuesIfNoneExist = function(stage, nextStage) {
            if (!$scope.guideExists) {
              nextStage.environment = angular.copy(stage.environment);
              nextStage.light = angular.copy(stage.light);
              nextStage.soil = angular.copy(stage.soil);
            }
          };

          $scope.nextStage = function(stage) {
            var nextStage = $scope.stages[stage.nextSelectedIndex];
            transferStageValuesIfNoneExist(stage, nextStage);
            $scope.editSelectedStage(nextStage);
          };

          $scope.editSelectedStage = function(chosenStage) {
            $scope.stages.forEach(function(stage) {
              stage.editing = false;
              if (chosenStage.name === stage.name) {
                stage.editing = true;
                $scope.currentStage = chosenStage;
              }
            });
          };
        },
      ],
      templateUrl: '/assets/angular-libs/guides/new/guides.new.stage.template.html',
    };
  },
]);
