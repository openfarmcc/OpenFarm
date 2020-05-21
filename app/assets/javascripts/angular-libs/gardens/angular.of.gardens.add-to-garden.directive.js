openFarmApp.directive("addToGardens", [
  "$rootScope",
  "gardenService",
  function ($rootScope, gardenService) {
    return {
      restrict: "A",
      scope: {
        cropObject: "=",
        objectType: "=",
        user: "=user",
      },
      link: function ($scope, element, attr) {
        $scope.$watch("user", function () {
          if ($scope.user && $scope.gardens === undefined) {
            $scope.gardens = {};
            gardenService.getGardensForUser($scope.user, function (success, response, code) {
              if (success) {
                $scope.gardens = response;
                $scope.gardens.forEach(function (garden) {
                  garden.added = !!findCropInGarden(garden);
                });
              }
            });
          }
        });

        function findCropInGarden(garden) {
          var gardenCrop = garden.garden_crops.filter(function (gC) {
            return gC[$scope.objectType] && gC[$scope.objectType].id === $scope.cropObject.id;
          });
          return gardenCrop && gardenCrop.length > 0 ? gardenCrop[0] : null;
        }

        $scope.toggleGarden = function (garden) {
          garden.adding = true;
          if (!garden.added) {
            var callback = function (success) {
              if (success) {
                garden.adding = false;
                garden.added = true;
              }
            };
            gardenService.addGardenCropToGarden(garden, $scope.objectType, $scope.cropObject, callback);
          } else {
            gardenService.deleteGardenCrop(garden, findCropInGarden(garden), function () {
              garden.adding = false;
              garden.added = false;
            });
          }
        };
      },
      templateUrl: "/assets/templates/_add_to_gardens.html",
    };
  },
]);
