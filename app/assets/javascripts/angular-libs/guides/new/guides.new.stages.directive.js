openFarmApp.directive('guidesStages', ['$http', '$q', '$rootScope', '$filter',
  'defaultService',
  function guidesStages($http, $q, $rootScope, $filter, defaultService) {
    return {
      restrict: 'A',
      scope: {
        guide: '=',
        options: '=',
        texts: '=',
      },
      controller: ['$scope', '$element', '$attrs',
        function ($scope) {
          var initStages = function() {
            $q.all([
              defaultService.getStageOptions()
            ])
            .then(function(data) {
              $scope.stages = $filter('orderBy')(data[0], 'order');

              $scope.$watch('guide.stagesToBuildFromLocalStoredGuide',
                function(afterValue) {
                  if (afterValue) {
                    $scope.guide.stages = buildDetailsForStages(
                      $scope.guide.stages
                    );
                  }
                });

              $scope.$watch('guide.stagesToBuildDefault',
                function(afterValue) {
                  if (afterValue) {
                    $scope.guide.stages = buildDetailsForStages();
                  }
                });

              $scope.$watch('guide.exists', function(afterValue) {
                if (afterValue && $scope.guide.loadedStages) {
                  $scope.guide.stages = buildFromExistingAndPreloadedStages(
                    $scope.guide.loadedStages,
                    $scope.stages
                  );
                }
              });
              $scope.$watch('guide.stages', function(){
                if ($scope.guide !== undefined && $scope.guide.stages) {
                  if ($scope.guide.stages.length === 0) {
                    $scope.guide.stages = $scope.stages;
                    // we did a reset, so we should redo everything.
                  } else {
                    // we only want to set these watches once we know that
                    // we'll have a guide to check on.
                    $rootScope.$watch('step', function(afterValue){
                      if (afterValue === 3){
                        setEditingStage();
                      }
                    });

                    var stages = $scope.guide.stages;
                    $scope.guide.selectedStagesCount = $scope.guide.stages
                                                  .filter(function(s) {
                                                    return s.selected;
                                                  }).length;

                    // keep track of what the next and previous stage
                    // is for toggling through them.
                    if (stages){
                      var lastSelectedIndex = null;
                      stages.forEach(function(item, index){
                        item.nextSelectedIndex = undefined;
                        if (item.selected){
                          item.originalIndex = index;
                          if (lastSelectedIndex !== null){
                            item.lastSelectedIndex = lastSelectedIndex;
                            stages[lastSelectedIndex].nextSelectedIndex = index;
                          }

                          lastSelectedIndex = index;
                        }
                      });
                    }
                    setEditingStage();
                  }
                }
              }, true);
            });
          };

          // We should only init stages if we have a guide.
          $scope.$watch('guide', function() {
            if ($scope.guide !== undefined) {
              initStages();
            }
          });

          var buildStageDetails = function(array, selectedArray){
            var returnArray = [];
            array.forEach(function(d){
              var obj = {
                slug: d.toLowerCase().replace(/ /g,'_').replace(/[^\w-]+/g,''),
                label: d,
                selected: selectedArray.indexOf(d) === -1 ? false : true,
              };
              returnArray.push(obj);
            });
            return returnArray;
          };

          var calculateStageLengthType = function(existing){
            switch(true){
              case (parseInt(existing.stage_length, 10) % 7 === 0):
                existing.stage_length = existing.stage_length / 7;
                existing.length_type = 'weeks';
                break;
              case (parseInt(existing.stage_length, 10) % 30 === 0):
                existing.stage_length = existing.stage_length / 30;
                existing.length_type = 'months';
                break;
              default:
                existing.length_type = 'days';
            }
            return existing;
          };

          var buildDetailsForStages = function(preloadedStages){

            if (preloadedStages === undefined) {
              preloadedStages = $scope.stages;
            }
            preloadedStages.forEach(function(preloadedStage){
              preloadedStage.environment = buildStageDetails(
                $scope.options.environment,
                (preloadedStage.environment || [])
              );
              preloadedStage.light = buildStageDetails(
                $scope.options.light,
                (preloadedStage.light || [])
              );
              preloadedStage.soil = buildStageDetails(
                $scope.options.soil,
                (preloadedStage.soil || [])
              );
            });
            setDefaultStages(preloadedStages);
            return preloadedStages;
          };

          var transferStageActions = function(existing, preloaded){
            if (existing.stage_actions.length > 0){
              existing.stage_action_options = [];
              existing.stage_action_options = existing.stage_actions;
            } else {
              existing.stage_action_options = preloaded.stage_action_options;
            }
            return existing;
          };

          var setDefaultStages = function(stages) {
            // set default stages
            console.log('setting default stages');
            stages.forEach(function(stage) {
              console.log(stage.name);
              if (stage.name === 'Preparation' ||
                  stage.name === 'Growing' ||
                  stage.name === 'Harvest') {
                stage.selected = true;
              }
            });
          };

          var buildFromExistingAndPreloadedStages = function (existing,
                                                              preloaded){
            var stages = [];
            var existingStageNames = existing.map(function(s){
              return s.name;
            });
            preloaded.forEach(function(preloadedStage){
              var existingStageIndex = existingStageNames
                .indexOf(preloadedStage.name);
              if (existingStageIndex !== -1){
                var existingStage = existing[existingStageIndex];
                existingStage.exists = true;
                existingStage.selected = true;
                existingStage = transferStageActions(existingStage,
                                                     preloadedStage);
                existingStage = calculateStageLengthType(existingStage);
                stages.push(existingStage);
              } else {
                stages.push(preloadedStage);
              }
            });
            console.log('setting default stages');
            return buildDetailsForStages(stages);
          };

          var setEditingStage = function(){
            var selectedSet = false;

            var isSet = ($scope.guide.stages.filter(function(stage) {
              return stage.editing;
            }).length > 0);

            if (!isSet){
              $scope.guide.stages.forEach(function(stage){
                if (stage.selected && !selectedSet){
                  // hacked hack is a hack
                  selectedSet = true;
                  stage.editing = true;
                } else {
                  stage.editing = false;
                }
              });
            }
          };


        }
      ],
      templateUrl: '/assets/angular-libs/guides/new/guides.new.stages.template.html'
    };
  }
]);
