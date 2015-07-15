openFarmApp.directive('guidesActions', ['$http', '$modal', 'defaultService',
  function guidesActions($http, $modal, defaultService) {
    return {
      restrict: 'A',
      scope: {
        stage: '=',
        texts: '='
      },
      controller: ['$scope', '$element', '$attrs',
        function ($scope, $element, $attrs) {
          $scope.stage.stage_action_options = [];
          console.log($scope.stage);

          $scope.openAddActionModal = function(stage){

            var actionOptions = [];
            defaultService.getStageActionOptions()
              .then(function (actionOptions) {
                // http://pineconellc.github.io/angular-foundation/#modal
                var modalInstance = $modal.open({
                  templateUrl: '/assets/templates/_add_action_modal.html',
                  controller: ['$scope', '$modalInstance', 'stage', 'actionOptions',
                    function ($scope, $modalInstance, stage, actionOptions) {
                      console.log(stage);
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
                  stage.stage_action_options = selectedActions || [];
                  stage.activeAction = selectedActions[0];
                }, function () {
                  console.info('Modal dismissed at: ' + new Date());
                });
              });
          };
        }
      ],
      templateUrl: '/assets/angular-libs/guides/new/guides.new.actions.template.html'
    }
  }
])
