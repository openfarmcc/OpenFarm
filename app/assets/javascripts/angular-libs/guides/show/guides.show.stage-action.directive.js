openFarmApp.directive('ofShowStageAction', ['$http', 'stageService',
  function ofShowStageAction($http, stageService) {
    return {
      restrict: 'A',
      scope: {
        action: '=ofShowStageAction',
        editingStage: '=',
        s3Bucket: '=',
        stage: '=',
        saveStageChanges: '=',
        index: '='
      },
      controller: ['$scope',
        function ($scope) {
          $scope.placeStageActionImageUpload = function (image) {
            var newPicture = {
              new: true,
              image_url: image
            }
            if ($scope.action.pictures) {
              $scope.action.pictures.push(newPicture)
            } else {
              $scope.action.pictures = [newPicture]
            }
          }

          $scope.deleteStageAction = function (idx) {
            stageService.deleteStageAction($scope.stage.id, $scope.action.id)
              .then(function () {
                // $scope.action.hide = true;
                $scope.stage.stage_actions.splice(idx, 1);
              })
          }
        }
      ],
      templateUrl: '/assets/angular-libs/guides/show/guides.show.stage-action.template.html'
    };
  }
]);
