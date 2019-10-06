openFarmApp.directive('addCrop', [
  '$http',
  '$rootScope',
  'cropService',
  'gardenService',
  function addCrop($http, $rootScope, cropService, gardenService) {
    return {
      restrict: 'A',
      scope: {
        cropOnSelect: '=',
        gardenQuery: '=',
        query: '=',
        user: '=',
        objectType: '=',
      },
      controller: [
        '$scope',
        '$element',
        '$attrs',
        function($scope, $element, $attrs) {
          $scope.placeholder = $attrs.placeholder || 'Search crops';
          $scope.buttonValue = $attrs.buttonValue || 'Submit';
          $scope.firstCrop = undefined;
          $scope.finalCrop = undefined;
          $scope.crops = undefined;
          $scope.garden = undefined;

          // Typeahead search for crops
          $scope.getCrops = function(val) {
            // be nice and only hit the server if
            // length >= 3
            return $http
              .get('/api/v1/crops', {
                params: {
                  filter: val,
                },
              })
              .then(function(res) {
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
                crops = crops.map(function(crop) {
                  return cropService.utilities.buildCrop(crop, res.data.included);
                });
                $scope.firstCrop = crops[0];
                $scope.crops = crops;
                return crops;
              });
          };

          function acallback(success, response) {
            $scope.user.gardens.forEach(function(garden) {
              if (garden === $scope.gardenQuery) {
                garden.garden_crops.push({
                  crop: response.crop,
                  guide: response.guide,
                  sowed: response.sowed,
                  stage: response.stage,
                  quantity: response.quantity,
                });
              }
            });
          }

          // Typeahead search for crops
          // cropSearch.getCrops("tomato");
          $scope.addCropToGarden = function() {
            $scope.crops1 = $scope.getCrops($scope.cropQuery);
            var cropi;
            if ($scope.crops1) {
              for (cropi in $scope.crops) {
                if ($scope.crops[cropi].name == $scope.cropQuery.name) {
                  gardenService.addGardenCropToGarden(
                    $scope.gardenQuery,
                    $scope.objectType,
                    $scope.cropQuery,
                    acallback
                  );
                }
                if ($scope.crops[cropi].name == $scope.cropQuery) {
                  $scope.finalCrop = cropService.utilities.buildParams($scope.crops[cropi]);
                  gardenService.addGardenCropToGarden(
                    $scope.gardenQuery,
                    $scope.objectType,
                    $scope.cropQuery,
                    acallback
                  );
                }
              }
            }
          };
        },
      ],
      templateUrl: '/assets/templates/_add_crop_to_garden.html',
    };
  },
]);
