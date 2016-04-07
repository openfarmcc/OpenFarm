openFarmApp.directive('ofShowStageAction', ['$http', '$modal',
  function ofShowStageAction($http, $modal) {
    return {
      restrict: 'A',
      scope: {
        action: '=ofShowStageAction',
        editingStage: '=',
        s3Bucket: '='
      },
      controller: ['$scope',
        function ($scope) {
          $scope.placeStageActionImageUpload = function (image) {
            console.log('scoping this stage action image')
            $scope.action.pictures.push({
              new: true,
              image_url: image
            })
          }
        }
      ],
      templateUrl: '/assets/angular-libs/guides/show/guides.show.stage-action.template.html'
    };
  }
]);
