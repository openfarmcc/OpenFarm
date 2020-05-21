openFarmApp.directive("stageButtons", [
  "$rootScope",
  "$location",
  function stageButtons($rootScope, $location) {
    return {
      restrict: "A",
      scope: {
        abledBool: "&",
        nextFunction: "=",
        processing: "=",
        stage: "=",
        nextStage: "=",
        texts: "=",
        hint: "=",
      },
      controller: [
        "$scope",
        "$element",
        "$attrs",
        function ($scope, $element, $attrs) {
          // Takes in attributes and set them to the appropriate
          // variable on the local scope.
          $scope.$watch("processing", function () {
            if ($scope.processing === true) {
              $scope.disabledText = "This may take some time";
            }
          });
          $scope.abledText = $attrs.abledText || "Continue";
          $scope.disabledText = $attrs.disabledText || "You can't continue yet.";
          $scope.cancelText = $attrs.cancelText || "Cancel.";
          $scope.cancelUrl = $attrs.cancelUrl || "/";
          $scope.backText = $attrs.backText || undefined;

          $scope.switchToStep = function (step) {
            $rootScope.step = step;
            $location.hash($rootScope.step);
            scrollToTop();
          };

          $scope.goBack = function () {
            $rootScope.previousStep = $rootScope.step;
            $rootScope.step -= 1;
            $location.hash($rootScope.step);
            scrollToTop();
          };

          var scrollToTop = function () {
            window.scrollTo($(".guides").scrollTop(), 0);
          };

          $scope.previousStep = function () {
            $rootScope.previousStep = $rootScope.step;
            $rootScope.step -= 1;
            $location.hash($rootScope.step);
            scrollToTop();
          };

          $scope.tunnelToNextStage = function (stage) {
            $scope.nextStage(stage);
            scrollToTop();
          };

          $scope.nextStep = function () {
            $rootScope.previousStep = $rootScope.step;
            $rootScope.step += 1;
            $location.hash($rootScope.step);
            scrollToTop();
          };

          $scope.nextStep = $scope.nextFunction || $scope.nextStep;
        },
      ],
      templateUrl: "/assets/templates/_stage_buttons.html",
    };
  },
]);
