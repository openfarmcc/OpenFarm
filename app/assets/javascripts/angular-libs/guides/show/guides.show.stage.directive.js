openFarmApp.directive('ofShowGuideStages', ['$http', '$modal', 'stageService',
  function ofShowGuideStages($http, $modal, stageService) {
    return {
      restrict: 'A',
      scope: {
        stage: '=',
        options: '=',
        saved: '=?',
        texts: '=?',
        triggerGuideUpdate: '=?',
        editing: '=?'
      },
      controller: ['$scope',
        function ($scope) {

          $scope.$watch('options', function(val) {
            if (val !== undefined) {
              $scope.environment = angular.copy($scope.options.multiSelectEnvironment);
              $scope.soil = angular.copy($scope.options.multiSelectSoil);
              $scope.light = angular.copy($scope.options.multiSelectLight);
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

          $scope.saveStage = function(stage) {

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

            console.log(data);

            stageService.updateStageWithPromise(stage.id, {'data': data})
              .then(function(response) {
                $scope.triggerGuideUpdate();
                console.log('success', response);
              }, function(error) {
                console.log('error', error)
              });
          }

          $scope.$watch('saved', function(after, before) {
            if (after === true && before === false) {
              $scope.saveStage($scope.stage)
            }
          })
        }
      ],
      templateUrl: '/assets/angular-libs/guides/show/guides.show.stage.template.html'
    };
  }
]);
