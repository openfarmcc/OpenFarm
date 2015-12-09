openFarmApp.directive('guidesActions', ['$http', '$modal', 'defaultService',
  function guidesActions($http, $modal, defaultService) {
    return {
      restrict: 'A',
      scope: {
        stage: '=',
        texts: '=',
      },
      controller: ['$scope',
        function ($scope) {
          $scope.stage.stage_action_options = [];

          $scope.placeStageActionUpload = function(action, image){
            if (!action.pictures){
              action.pictures = [];
            }
            action.pictures.push({
              new: true,
              image_url: image
            });
          };
        }
      ],
      templateUrl: '/assets/angular-libs/guides/new/guides.new.actions.template.html'
    }
  }
])
