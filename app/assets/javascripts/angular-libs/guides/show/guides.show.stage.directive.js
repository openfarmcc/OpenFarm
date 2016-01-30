openFarmApp.directive('ofShowGuideStages', ['$http', '$modal', 'stageService',
  function ofShowGuideStages($http, $modal, stageService) {
    return {
      restrict: 'A',
      scope: {
        stage: '=',
        detailOptions: '=',
        texts: '=?',
        triggerGuideUpdate: '=?',
      },
      controller: ['$scope',
        function ($scope) {

          $scope.$watch('detailOptions', function(val) {
            if (val !== undefined) {
              $scope.environment = angular.copy($scope.detailOptions.multiSelectEnvironment);
              $scope.soil = angular.copy($scope.detailOptions.multiSelectSoil);
              $scope.light = angular.copy($scope.detailOptions.multiSelectLight);
              $scope.environment.forEach(function(env) {
                if ($scope.stage.environment !== null && $scope.stage.environment.indexOf(env.label) > -1) {
                  env.selected = true;
                }
              });
              $scope.soil.forEach(function(env) {
                if ($scope.stage.soil !== null && $scope.stage.soil.indexOf(env.label) > -1) {
                  env.selected = true;
                }
              });
              $scope.light.forEach(function(env) {
                if ($scope.stage.light !== null && $scope.stage.light.indexOf(env.label) > -1) {
                  env.selected = true;
                }
              });
            }
          });

          $scope.toggleEditingStage = function() {
            $scope.editingStage = !$scope.editingStage;
          }

          $scope.saveStageChanges = function(stage) {

            var data = {
              'attributes': {
                name: stage.name,
                overview: stage.overview,
                environment: $scope.environment.filter(function(env) {
                                return env.selected;
                              }).map(function(env) {
                                return env.label
                              }),
                light: $scope.light.filter(function(light) {
                          return light.selected;
                        }).map(function(light) {
                          return light.label
                        }),
                soil: $scope.soil.filter(function(soil) {
                        return soil.selected;
                      }).map(function(soil) {
                        return soil.label
                      }),
                stage_length: stage.stage_length,
                order: stage.order,
              },
              actions: stage.stage_actions.map(function(sa, index) {
                        return {
                          name: sa.name,
                          images: sa.pictures,
                          overview: sa.overview,
                          order: index
                        };
                      }),
              images: stage.pictures
            };

            stageService.updateStageWithPromise(stage.id, {'data': data})
              .then(function(response) {
                // $scope.triggerGuideUpdate();
                $scope.toggleEditingStage();
              }, function(error) {
                console.log('error', error)
              });
          }
        }
      ],
      templateUrl: '/assets/angular-libs/guides/show/guides.show.stage.template.html'
    };
  }
]);
