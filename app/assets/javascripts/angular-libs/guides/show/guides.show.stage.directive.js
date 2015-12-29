openFarmApp.directive('ofShowGuideStages', ['$http', '$modal', 'defaultService',
  function ofShowGuideStages($http, $modal, defaultService) {
    return {
      restrict: 'A',
      scope: {
        stage: '=',
        texts: '=?',
      },
      controller: ['$scope',
        function ($scope) {
          console.log($scope.stage);
        }
      ],
      templateUrl: '/assets/angular-libs/guides/show/guides.show.stage.template.html'
    }
  }
])
