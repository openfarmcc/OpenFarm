openFarmApp.directive("formChecker", function () {
  return {
    require: "^form",
    scope: {
      stage: "=formChecker",
    },
    link: function (scope, element, attr) {
      // loop through each stage
      scope.$watch(
        "stage",
        function () {
          var checked = {};

          var elements = ["environment", "light", "soil"];

          if (scope.stage.selected) {
            scope.stage.edited = false;

            elements.forEach(function (element) {
              scope.stage[element].forEach(function (opt) {
                if (opt.selected) {
                  scope.stage.edited = true;
                  checked[element] = true;
                }
              });
            });
          }

          if (scope.stage.stageActions) {
            scope.stage.stageActions.forEach(function (stageAction) {
              // validate actions.
              checked.stageActions = true;
            });
          }

          var flag = true;
          angular.forEach(checked, function (value, key) {
            if (!value) flag = false;
          });

          scope.stage.valid = flag;
        },
        true
      );
    },
  };
});
