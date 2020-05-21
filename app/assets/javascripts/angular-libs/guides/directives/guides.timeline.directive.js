openFarmApp.directive("timeline", [
  "guideService",
  function timeline(guideService) {
    return {
      restrict: "A",
      scope: true,
      controller: [
        "$scope",
        function ($scope) {
          guideService.drawTimeline();
        },
      ],
      templateUrl: "/assets/templates/_timeline.html",
    };
  },
]);

openFarmApp.directive("createTimeline", [
  "guideService",
  function createTimeline(guideService) {
    return {
      restrict: "A",
      scope: {
        timespan: "=createTimeline",
      },
      require: "timeline",
      controller: [
        "$scope",
        function ($scope) {
          $scope.creating = true;

          guideService.drawTimeline($scope.timespan, function (days, dayWidth, scale) {
            $scope.days = days;
            $scope.dayWidth = dayWidth;
            $scope.calendarScale = scale;
          });
        },
      ],
      templateUrl: "/assets/templates/_timeline.html",
    };
  },
]);
