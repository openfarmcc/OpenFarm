openFarmApp.directive('guidesStageOverview', ['$http', '$modal', 'defaultService',
  function guidesStageOverview($http, $modal, defaultService) {
    return {
      restrict: 'A',
      scope: {
        stage: '=',
        texts: '=',
        viewingStageOverview: '='
      },
      controller: ['$scope',
        function ($scope) {
          $scope.viewingStageOverview = false;
        }
      ],
      templateUrl: '/assets/angular-libs/guides/new/guides.new.stage-overview.template.html'
    };
  }
]);
