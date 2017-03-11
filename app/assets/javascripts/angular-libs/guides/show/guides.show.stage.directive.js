openFarmApp.directive('ofShowGuideStages', ['$http', '$modal', 'stageService',
  'defaultService',
  function ofShowGuideStages($http, $modal, stageService, defaultService) {
    return {
      restrict: 'A',
      scope: {
        stage: '=',
        detailOptions: '=',
        texts: '=?',
        canEdit: '=',
        triggerGuideUpdate: '=?',
        s3Bucket: '='
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

          if ($scope.stage) {
            stageService.getStage($scope.stage.id)
              .then(function (obj) {
                // TODO: We probably want to keep this more consistent
                // stage-actions? Probably a jsonAPI serializer thing.
                $scope.stage.stage_actions = obj['stage-actions']
              });
          }

          $scope.toggleEditingStage = function() {
            $scope.editingStage = !$scope.editingStage;
          }

          $scope.deleteStage = function(stage) {
            var con = confirm('Are you sure you want to delete this stage?');
            if (con) {
              stageService.deleteStageWithPromise(stage.id)
                .then(function() {
                  $scope.triggerGuideUpdate();
                })
            }
          }

          $scope.placeImageUpload = function (image) {
            var newPicture = {
              new: true,
              image_url: image
            }
            if ($scope.stage.pictures) {
              $scope.stage.pictures.push(newPicture)
            } else {
              $scope.stage.pictures = [newPicture]
            }
          }

          $scope.saveStageChanges = function(stage) {
            var actions = stage.stage_actions || [];
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
              actions: actions.map(function(sa, index) {
                        var actionData = {
                          name: sa.name,
                          images: sa.pictures,
                          time: sa.time,
                          time_unit: sa.time_unit,
                          overview: sa.overview,
                          order: index,
                          id: sa.id || null
                        };
                        return actionData
                      }),
              images: stage.pictures || null
            };


            stageService.updateStageWithPromise(stage.id, {'data': data})
              .then(function(response) {
                $scope.toggleEditingStage();
                // window.location.reload()
              }, function(error) {
                console.log('error updating stage', error)
              });
          }

          $scope.openAddActionModal = function(stage){

            defaultService.getStageActionOptions()
              .then(function (actionOptions) {
                // http://pineconellc.github.io/angular-foundation/#modal
                var modalInstance = $modal.open({
                  templateUrl: '/assets/templates/_add_action_modal.html',
                  controller: ['$scope', '$modalInstance', 'stage',
                    'actionOptions',
                    function ($scope, $modalInstance, stage, actionOptions) {
                      $scope.actionOptions = actionOptions;
                      $scope.existingActions = stage.stage_action_options || [];

                      $scope.actionOptions.forEach(function(action){
                        $scope.existingActions.forEach(function(existingAction){
                          if (existingAction.name === action.name){
                            action.overview = existingAction.overview;
                            action.selected = true;
                            action.pictures = [];
                          }
                        });
                      });

                      $scope.ok = function () {
                        var selectedActions = $scope.actionOptions
                                                .filter(function(action){
                                                  return action.selected;
                                                });
                        $modalInstance.close(selectedActions);
                      };

                      $scope.cancel = function () {
                        $modalInstance.dismiss('cancel');
                      };
                    }],
                  keyboard: false,
                  resolve: {
                    stage: function(){
                      return stage;
                    },
                    actionOptions: function(){
                      return actionOptions;
                    }
                  }
                });

                modalInstance.result.then(function (selectedActions) {
                  selectedActions.forEach(function (action) {
                    action.new = true;
                    action.pictures = [];
                    action.overview = null;
                    stage.stage_actions = stage.stage_actions || [];
                    stage.stage_actions.push(action)
                  })
                }, function () {
                  console.info('Modal dismissed at: ' + new Date());
                });
              });
          };
        }
      ],
      templateUrl: '/assets/angular-libs/guides/show/guides.show.stage.template.html'
    };
  }
]);
