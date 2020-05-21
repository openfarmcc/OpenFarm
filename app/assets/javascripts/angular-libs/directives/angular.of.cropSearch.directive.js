openFarmApp.directive("cropSearch", [
  "$http",
  "cropService",
  function cropSearch($http, cropService) {
    return {
      restrict: "A",
      scope: {
        cropSearchFunction: "=",
        cropOnSelect: "=",
        clearCropSelection: "=",
        focusOn: "=",
        loadingVariable: "=",
        loadingCropsText: "=",
        options: "=",
        allowNew: "=",
        query: "=?",
        doesNotHaveButton: "=",
        required: "=?",
      },
      controller: [
        "$scope",
        "$element",
        "$attrs",
        function ($scope, $element, $attrs) {
          $scope.placeholder = $attrs.placeholder || "Search crops";
          $scope.buttonValue = $attrs.buttonValue || "Submit";
          $scope.query = "";

          $scope.required = $scope.required !== undefined ? $scope.required : true;

          $scope.firstCrop = undefined;
          //Typeahead search for crops
          $scope.getCrops = function (val) {
            // be nice and only hit the server if
            // length >= 3
            return $http
              .get("/api/v1/crops", {
                params: {
                  filter: val,
                },
              })
              .then(function (res) {
                var crops = [];
                crops = res.data.data;
                if (crops.length === 0 && $scope.allowNew) {
                  crops.push({
                    attributes: {
                      name: val,
                      is_new: true,
                    },
                  });
                }
                crops = crops.map(function (crop) {
                  return cropService.utilities.buildCrop(crop, res.data.included);
                });
                $scope.firstCrop = crops[0];
                return crops;
              });
          };

          $scope.submitCrop = function ($item, $model, $label, options) {
            if ($scope.firstCrop !== undefined) {
              $scope.cropOnSelect($scope.firstCrop);
            } else {
              $scope.cropOnSelect($scope.query);
            }
            $scope.query = "";
          };
        },
      ],
      templateUrl: "/assets/templates/_crop_search.html",
    };
  },
]);
