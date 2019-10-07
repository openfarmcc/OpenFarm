openFarmApp.directive('ofEnvironmentalOverview', [
  function ofEnvironmentalOverview() {
    return {
      restrict: 'A',
      scope: {
        factors: '=ofEnvironmentalOverview',
      },
      controller: ['$scope', function($scope) {}],
      templateUrl: '/assets/angular-libs/guides/show/guides.show.stage.environmental-overview.template.html',
    };
  },
]);
