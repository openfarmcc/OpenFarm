openFarmApp.directive('ofShowStageAction', ['$http', 'stageService',
  function ofShowStageAction($http, stageService) {
    return {
      restrict: 'A',
      scope: {
        action: '=ofShowStageAction',
        editingStage: '=',
        s3Bucket: '=',
        stage: '='
      },
      controller: ['$scope',
        function ($scope) {
          $scope.placeStageActionImageUpload = function (image) {
            $scope.action.pictures.push({
              new: true,
              image_url: image
            })
          }

          $scope.deleteStageAction = function () {
            stageService
              .deleteStageAction($scope.stage.id, $scope.action.id)
                .then(function () {
                  $scope.action.hide = true;
                })
          }
        }
      ],
      templateUrl: '/assets/angular-libs/guides/show/guides.show.stage-action.template.html'
    };
  }
]);
