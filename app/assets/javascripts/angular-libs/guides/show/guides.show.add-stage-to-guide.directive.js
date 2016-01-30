openFarmApp.directive('ofShowAddStageToGuide', ['$http', '$modal', 'stageService',
  function ofShowAddStageToGuide($http, $modal, stageService) {
    return {
      restrict: 'A',
      scope: {

      },
      controller: ['$scope',
        function ($scope) {
        }
      ],
      templateUrl: '/assets/angular-libs/guides/show/guides.show.add-stage-to-guide.template.html'
    };
  }
]);
