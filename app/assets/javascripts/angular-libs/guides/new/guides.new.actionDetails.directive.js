openFarmApp.directive('actionDetails', [
  '$http',
  '$modal',
  'defaultService',
  function actionDetails($http, $modal, defaultService) {
    return {
      restrict: 'A',
      scope: {
        action: '=',
        texts: '=',
      },
      controller: [
        '$scope',
        function($scope) {
          $scope.placeStageActionUpload = function(action, image) {
            if (!action.pictures) {
              action.pictures = [];
            }
            action.pictures.push({
              new: true,
              image_url: image,
            });
          };
        },
      ],
      templateUrl: '/assets/angular-libs/guides/new/guides.new.actionDetails.template.html',
    };
  },
]);
