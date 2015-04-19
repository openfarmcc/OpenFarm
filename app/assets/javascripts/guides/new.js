openFarmApp.directive('formChecker', function(){
  return {
    require: '^form',
    scope: {
      stage: '=formChecker'
    },
    link: function(scope, element, attr){
      // loop through each stage
      scope.$watch('stage', function(){
        if (scope.stage.selected){
          scope.stage.edited = false;
          scope.stage.environment.forEach(function(opt){
            if (opt.selected){
              scope.stage.edited = true;
            }
          });
          scope.stage.light.forEach(function(opt){
            if (opt.selected){
              scope.stage.edited = true;
            }
          });
          scope.stage.soil.forEach(function(opt){
            if (opt.selected){
              scope.stage.edited = true;
            }
          });
        }
      }, true);
    }
  };
});

openFarmApp.factory('focus', function ($rootScope, $timeout) {
  return function(name) {
    $timeout(function (){
      $rootScope.$broadcast('focusOn', name);
    });
  };
});

openFarmApp.directive('stageButtons', [
  function stageButtons(){
    return {
      restrict: 'A',
      scope: {
          abledBool: '&',
          nextFunction: '=',
          processing: '='
      },
      controller: ['$scope', '$element', '$attrs',
       function ($scope, $element, $attrs){
        // Takes in attributes and set them to the appropriate
        // variable on the local scope.
        $scope.$watch('processing', function(){
          if ($scope.processing === true){
            $scope.disabledText = 'This may take some time';
          }
        });
        $scope.abledText = $attrs.abledText || 'Continue';
        $scope.disabledText =
          $attrs.disabledText || 'You can\'t continue yet.';
        $scope.cancelText = $attrs.cancelText || 'Cancel.';
        $scope.cancelUrl = $attrs.cancelUrl || '/';
        $scope.backText = $attrs.backText || undefined;

        $scope.previousStep = $scope.$parent.previousStep;
        $scope.nextStep = $scope.nextFunction || $scope.$parent.nextStep;
      }],
      templateUrl: '/assets/templates/_stage_buttons.html'
    };
}]);

openFarmApp.directive('lifetimeChange', [
  function lifetimeChange(){
    return {
      restrict: 'A',
      scope: {
        timespan: '=timespan',
        calendarScale: '='
      },
      controller: ['$scope', '$element', '$attrs',
        function($scope, $element, $attrs){
          var diffX = -1;

          var calculateDifference = function(x, offset){
            // calculates the offset to maintain the difference between
            // where the user clicked and where they're dragging to.
            return x - offset;
          };

          var jumpToWeekStarts = function(position, scale){
            // Makes sure that the newPosition jumps to the relevant week.
            var weekWidth = scale.step * 7;
            return scale.convertPositionToWeek(position) * weekWidth;
          };

          var dictateLength = function(x, diffX, scale, leftOffset){
            // A function that constrains the length based on days of the year
            var newPosition = x - diffX;

            leftOffset = leftOffset || 0;

            if (newPosition >= 0 && newPosition <= scale.range - leftOffset){
              return jumpToWeekStarts(newPosition, scale);
            }
            if (newPosition < 0){
              return 0;
            }
            if (newPosition > scale.range - leftOffset){
              return scale.range - leftOffset;
            }
          };

          var lengthChangeHandler = function(e){
            var element = e.data.element;
            var scale = e.data.scale;
            var direction = e.data.direction;
            var x = e.pageX - element.parent().parent().offset().left;
            var oldLeftX = parseInt(element.parent().css('left'), 10) || 0;
            var oldRightX = parseInt(element.parent().css('width'), 10);
            var newWidth = oldRightX;

            if (diffX === -1){
              var offset = (direction === 'left' ? oldLeftX : oldRightX);
              diffX = calculateDifference(x, offset);
            }
            // Calculate new things based on direction;
            if (direction === 'left'){

              var newLeft = dictateLength(x, diffX, scale);

              element.parent().css('left', newLeft);

              // This needs to be made more functional
              $scope
                .timespan
                .set_start_event(scale.convertPositionToWeek(newLeft));

              var newLeftX = parseInt(element.parent().css('left'), 10);


              // But we also need to set the new length.
              var previousWidth = parseInt(element.parent().css('width'), 10);
              // The new width will be the previous width minus
              // the difference in length.
              newWidth = previousWidth + oldLeftX - newLeftX;

            } else {
              newWidth = dictateLength(x, diffX, scale, oldLeftX);
            }

            element.parent().css('width', newWidth);

            // this needs to be made more functional

            $scope
              .timespan
              .set_length(scale.convertPositionToWeek(newWidth));
          };

          $element.on('mousedown', function(){
            $(document).bind('mousemove.lifetime',
              {
                'direction': $attrs.lifetimeChange,
                'element': $element,
                'scale': $scope.calendarScale,
                'timespan': $scope.timespan
              },
              lengthChangeHandler);
          });


          $(document).on('mouseup', function(){
            $(document).unbind('mousemove.lifetime', lengthChangeHandler);
          });
        }]
    };
  }]);

openFarmApp.directive('createTimeline', ['guideService',
  function createTimeline(guideService){
    return {
      restrict: 'A',
      scope: {
        timespan: '=createTimeline'
      },
      require: 'timeline',
      controller: ['$scope',
        function($scope){
          $scope.creating = true;

          guideService.drawTimeline($scope.timespan,
                                    function(days, dayWidth, scale){
                                      $scope.days = days;
                                      $scope.dayWidth = dayWidth;
                                      $scope.calendarScale = scale;
                                    });

        }],
      templateUrl: '/assets/templates/_timeline.html'
    };
  }]);

openFarmApp.config(['$locationProvider', function($locationProvider) {
  $locationProvider.html5Mode(false).hashPrefix('!');
}]);

openFarmApp.controller('newGuideCtrl', ['$scope', '$http', '$filter',
  'guideService', 'stageService', '$modal', '$location', 'localStorageService',
  function newGuideCtrl($scope, $http, $filter, guideService, stageService,
                        $modal, $location, localStorageService) {

  $scope.$on('$locationChangeSuccess', function(){
    $scope.step = +$location.hash() || 1;
  });

  $scope.environmentOptions = [];
  $scope.lightOptions = [];
  $scope.soilOptions = [];
  $scope.practicesOptions = [];
  var practices = [];

  $http.get('/api/detail_options/')
    .success(function(response){
      response.detail_options.forEach(function(detail) {
        var category = detail.category + 'Options';
        $scope[category].push(detail.name);
      });

      practices = $scope.practicesOptions.map(function(practice) {
        return {
          // TODO: make the slug creation more robust.
          'slug': practice.toLowerCase(),
          'label': practice,
          'selected': false
        };
      });
    })
    .error(function(r, e){
      $scope.alerts.push({
        msg: e,
        type: 'alert'
      });
      console.log(r, e);
    });

  $scope.alerts = [];
  $scope.crops = [];
  $scope.step = +$location.hash() || 1;
  $scope.crop_not_found = false;
  $scope.addresses = [];
  $scope.stages = [];
  $scope.hasEdited = [];
  $scope.haveEditedStages = false;
  $scope.existingGuideID = getIDFromURL('guides');
  $scope.guideExists = ($scope.existingGuideID &&
                        $scope.existingGuideID !== 'new');

  var processCropID = function(crop_id) {
    if (crop_id){
      $http.get('/api/crops/' + crop_id)
        .success(function(r){
          $scope.newGuide.crop = r.crop;
          $scope.query = r.crop.name;
        })
        .error(function(r, e){
          $scope.alerts.push({
            msg: e,
            type: 'alert'
          });
          console.log(r, e);
        });
    }
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
    preloadedStages.forEach(function(preloadedStage){
      preloadedStage.environment = $scope.buildStageDetails($scope.environmentOptions,
                                                            (preloadedStage.environment ||
                                                             []));
      preloadedStage.light = $scope.buildStageDetails($scope.lightOptions,
                                                      (preloadedStage.light ||
                                                       []));
      preloadedStage.soil = $scope.buildStageDetails($scope.soilOptions,
                                                     (preloadedStage.soil ||
                                                      []));
    });
    return preloadedStages;
  };

  var setEditingStage = function(){
    var selectedSet = false;

    var isSet = ($scope.newGuide.stages.filter(function(stage) {
      return stage.editing;
    }).length > 0);

    if (!isSet){
      $scope.newGuide.stages.forEach(function(stage){
        if (stage.selected && !selectedSet){
          // hacked hack is a hack
          // $scope.newGuide.stages[stage.originalIndex].editing = true;
          selectedSet = true;
          stage.editing = true;
        } else {
          // $scope.newGuide.stages[stage.originalIndex].editing = false;
          stage.editing = false;
        }
      });
    }
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

  var buildFromExistingAndPreloadedStages = function(existing, preloaded){
    var stages = [];
    var existingStageNames = existing.map(function(s){
      return s.name;
    });
    preloaded.forEach(function(preloadedStage, index){
      var existingStageIndex = existingStageNames.indexOf(preloadedStage.name);
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

    return buildDetailsForStages(stages);
  };

  var loadExternalGuide = function(guideId, practices){
    $http.get('/api/guides/' + guideId)
      .success(function(r){
        $scope.hasEditedStages = true;
        $scope.newGuide.exists = true;
        $scope.newGuide.practices = practices;
        $scope.newGuide._id = r.guide._id;
        $scope.newGuide.featured_image = r.guide.featured_image;
        $scope.s3upload = r.guide.featured_image;
        $scope.newGuide.name = r.guide.name;
        $scope.newGuide.location = r.guide.location;
        $scope.newGuide.overview = r.guide.overview;

        var transferTimeSpan = function(defaultTS, remoteTS){
          var newTimeSpan = remoteTS || defaultTS;
          newTimeSpan.set_length = defaultTS.set_length;
          newTimeSpan.set_start_event = defaultTS.set_start_event;
          return newTimeSpan;
        };

        $scope.newGuide.time_span = transferTimeSpan($scope.newGuide.time_span,
                                                     r.guide.time_span);

        if (r.guide.practices){
          $scope.newGuide.practices.forEach(function(practice){
            if (r.guide.practices.indexOf(practice.slug) !== -1){
              practice.selected = true;
            }
          });
        }

        if (r.guide.stages){
          $scope.newGuide.stages =
            buildFromExistingAndPreloadedStages(r.guide.stages, $scope.stages);

        }
        processCropID(r.guide.crop_id);
      })
      .error(function(r, e){
        $scope.alerts.push({
          msg: e,
          type: 'alert'
        });
        console.log(r, e);
      });
  };

  var resetAlert = function(){
    $scope.alerts.push({
      msg: 'We noticed that you hadn\'t finished completing your guide, ' +
           'so we preloaded it.',
      type: 'info',
      action: 'Start from scratch?',
      cancelTimeout: true,
      actionFunction: function(index){
        $scope.newGuide = angular.copy($scope.originalGuide);
        $scope.alerts.splice(index, 1);
        $scope.switchToStep(1);
        localStorageService.remove('guide');
        checkGuideSource();
      }
    });
  };

  var checkGuideSource = function(checkAlert){
    if ($scope.guideExists){
      loadExternalGuide(getIDFromURL('guides'), practices);
    } else {
      var localGuide = localStorageService.get('guide')
      if (localGuide && !localGuide._id){
        $scope.newGuide = localGuide;
        if (checkAlert){
          resetAlert();
        }
        $scope.newGuide.stages = buildDetailsForStages($scope.newGuide.stages);
      } else {
        $scope.newGuide.stages = buildDetailsForStages($scope.stages);
      }
    }
  };

  var setGuide = function(){

    $scope.originalGuide = {
        name: '',
        crop: undefined,
        overview: '',
        // selectedStages: [],
        time_span: {
          'length': 24,
          'length_units':'weeks',
          'start_event': 21,
          'start_event_format':'%W',
          set_start_event: function(val){
            this.start_event = val;
          },
          set_length: function(val){
            this.length = val;
          }
        },
        exists: false,
        stages: $scope.stages,
        practices: practices,
        how_long: 0,
        how_long_type: 'days',
        start_time: moment().format('MMMM')
    };

    $scope.newGuide = angular.copy($scope.originalGuide);

    checkGuideSource(true);

    $scope.$watch('newGuide', function(){
      if (!$scope.guideExists){
        localStorageService.set('guide', $scope.newGuide);
      }
    }, true);

    $scope.$watch('newGuide.stages', function(){

      // $scope.newGuide.selectedStages = [];

      var stages = $scope.newGuide.stages;
      $scope.selectedStagesCount = $scope.newGuide.stages
                                    .filter(function(s) {
                                      return s.selected;
                                    }).length;

      // keep track of what the next and previous stage is for toggling
      // through them.
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

            // $scope.newGuide.selectedStages.push(item);
            lastSelectedIndex = index;
          }
        });
      }

      // $scope.newGuide.selectedStages.sort(function(a, b){
      //   return a.order > b.order;
      // });

      setEditingStage();
    }, true);

    $scope.$watch('step', function(afterValue){
      if (afterValue === 3){
        setEditingStage();
      }
    });

    $scope.$watch('alerts.length', function(){
      $scope.newGuide.sending = false;
    });

    processCropID(getUrlVar('crop_id'));
  };

  var getStages = function(success_callback, error_callback){
    $http.get('/api/stage_options/')
      .success(function(response){
        $scope.stages = response.stage_options;
        $scope.stages = $filter('orderBy')($scope.stages, 'order');
        success_callback();
      })
      .error(function(response, code){
        $scope.alerts.push({
          msg: code + ' error. We had trouble fetching all stage options.',
          type: 'warning'
        });
      });
  };

  getStages(setGuide);


  //Typeahead search for crops
  $scope.search = function () {
    // be nice and only hit the server if
    // length >= 3
    if ($scope.query && $scope.query.length >= 3){
      $http({
        url: '/api/crops',
        method: "GET",
        params: {
          query: $scope.query
        }
      }).success(function (response) {
        if (response.crops.length){
          $scope.crops = response.crops;
        } else {
          $scope.crop_not_found = true;
        }
      }).error(function (response, code) {
        $scope.alerts.push({
          msg: code + ' error. Could not retrieve data from server. Please try again later.',
          type: 'warning'
        });
      });
    }
  };

  //Gets fired when user selects dropdown.
  $scope.cropSelected = function ($item, $model, $label) {
    $scope.newGuide.crop = $item;
    $scope.crop_not_found = false;
    $scope.newGuide.crop.description = '';
  };

  //Gets fired when user resets their selection.
  $scope.clearCropSelection = function ($item, $model, $label) {
    $scope.newGuide.crop = null;
    $scope.crop_not_found = false;

    focus('cropSelectionCanceled');
  };

  $scope.createCrop = function(){
    window.location.href = '/crops/new/?source=guide&name=' + $scope.query;
  };

  $scope.switchToStep = function(step){
    $scope.step = step;
    $location.hash($scope.step);
    scrollToTop();
  };

  var scrollToTop = function(){
    $('body').scrollTop(0);
  }

  $scope.nextStep = function(){
    if ($scope.step === 3){
      $scope.hasEditedStages = true;
    }
    $scope.step += 1;
    $location.hash($scope.step);
    scrollToTop();
  };

  $scope.previousStep = function(){
    $scope.step -= 1;
    $location.hash($scope.step);
    scrollToTop();
  };

  var transferStageValuesIfNoneExist = function(stage, nextStage) {
    if (!$scope.guideExists) {
      nextStage.environment = stage.environment;
      nextStage.light = stage.light;
      nextStage.soil = stage.soil;
    }
  }

  $scope.nextStage = function(stage){
    var nextStage = $scope.stages[stage.nextSelectedIndex];
    transferStageValuesIfNoneExist(stage, nextStage);
    $scope.editSelectedStage(nextStage);
    scrollToTop();
  };

  $scope.editSelectedStage = function(chosenStage){
    $scope.newGuide.stages.forEach(function(stage){
      stage.editing = false;
      if (chosenStage.name === stage.name){
        stage.editing = true;

        $scope.currentStage = chosenStage;
      }
    });
  };

  $scope.openAddActionModal = function(stage){
    var actionOptions = [];
    $http({
      url: '/api/stage_action_options',
      method: 'GET'
    }).success(function (response) {
      actionOptions = response.stage_action_options;

      // http://pineconellc.github.io/angular-foundation/#modal
      var modalInstance = $modal.open({
        templateUrl: '/assets/templates/_add_action_modal.html',
        controller: ['$scope', '$modalInstance', 'stage', 'actionOptions',
          function ($scope, $modalInstance, stage, actionOptions) {
            $scope.actionOptions = actionOptions;
            $scope.existingActions = stage.stage_action_options;

            $scope.actionOptions.forEach(function(action){
              $scope.existingActions.forEach(function(existingAction){
                if (existingAction.name === action.name){
                  action.overview = existingAction.overview;
                  action.selected = true;
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

        stage.stage_action_options = selectedActions;
        stage.activeAction = selectedActions[0];
      }, function () {
        console.info('Modal dismissed at: ' + new Date());
      });
    });
  };

  $scope.buildStageDetails = function(array, selectedArray){
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

  var buildParametersFromScope = function(){
    // Gather things in the scope and put them in parameters.

    angular.forEach($scope.newGuide.time_span, function(val, key){
      $scope.newGuide.time_span[key] = val || undefined;
    });

    var practices = [];
    angular.forEach($scope.newGuide.practices, function(value, key){
      if (value.selected){
        practices.push(value.slug);
      }
    }, practices);

    var defineFeaturedImage = function(image){
      var featured_image = null;
      if (image !== undefined && image.indexOf('baren_field') === -1){
        featured_image = image;
      }
      return featured_image;
    }

    var params = {
      time_span: $scope.newGuide.time_span,
      name: $scope.newGuide.name,
      crop_id: $scope.newGuide.crop._id,
      overview: $scope.newGuide.overview || null,
      location: $scope.newGuide.location || null,
      featured_image: defineFeaturedImage($scope.newGuide.featured_image),
      practices: practices
    };

    if (params.featured_image === '/assets/leaf-grey.png'){
      params.featured_image = null;
    }

    return params;
  };

  $scope.submitForm = function () {
    $scope.newGuide.sending = true;

    var params = buildParametersFromScope();

    if ($scope.newGuide._id){
      // In this case the guide already existed,
      // so we need to put, not to post.
      // TODO: refactor the $scope.alerts thing
      // so that it cancels things if things go wrong
      params._id = $scope.newGuide._id;
      guideService.updateGuide(params._id,
                               params,
                               $scope.alerts,
                               $scope.sendStages);
    } else {
      guideService.createGuide(params,
                               $scope.alerts,
                               $scope.sendStages);
    }
  };

  var calcTimeLength = function(length, length_type){
    if (length && length_type){
      switch (length_type){
        case 'minutes':
        return length;
        case 'hours':
        return length * 60;
        case 'action_days': // A special case of days,
        // for actions we're measuring in minutes, not days;
        return length * 60 * 24;
        case 'months':
        return length * 30;
        case 'weeks':
        return length * 7;
        default:
        return length;
      }
    } else {
      return null;
    }
  };

  $scope.sendStages = function(success, guide){
    console.log('sending stages');
    $scope.newGuide._id = guide._id;
    $scope.sent = 0;
    $scope.newGuide.stages.forEach(function(stage){
      var stageParams = {
        name: stage.name,
        guide_id: guide._id,
        order: stage.order,
        stage_length: calcTimeLength(stage.stage_length, stage.length_type),
        environment: stage.environment.filter(function(s){
            return s.selected;
          }).map(function(s){
            return s.label;
          }) || null,
        soil: stage.soil.filter(function(s){
            return s.selected;
          }).map(function(s){
            return s.label;
          }) || null,
        light: stage.light.filter(function(s){
            return s.selected;
          }).map(function(s){
            return s.label;
          }) || null,
        actions: stage.stage_action_options.filter(function(a){
          console.log(a);
            return a.overview || a.time || (a.pictures && a.pictures.length > 0);
          }).map(function(action, index){
            return { name: action.name,
                     images: action.pictures.filter(function(p){
                      return !p.deleted;
                     }),
                     overview: action.overview,
                     time: calcTimeLength(action.time, action.length_type),
                     order: index };
          }) || null
      };
      if (stage.pictures){
        stageParams.images = stage.pictures.filter(function(p){
          return !p.deleted;
        });
      }

      // Go through all the possible changes on
      // each stage.

      if (stage.selected && !stage.exists){
        console.log('creating stage');
        stageService.createStage(stageParams,
                                 $scope.alerts,
                                 function(success, stage){
                                   stage.sent = true;
                                   $scope.sent ++;
                                   $scope.checkNumberUpdated();
                                 });

      } else if (stage.selected && stage.exists){
        console.log('updating stage');
        stageService.updateStage(stage._id,
                                 stageParams,
                                 $scope.alerts,
                                 function(){
                                   stage.sent = true;
                                   $scope.sent ++;
                                   $scope.checkNumberUpdated();
                                 });

      } else if (stage.exists){
        console.log('deleting stage');
        stageService.deleteStage(stage._id,
                                 $scope.alerts,
                                 function(){
                                   stage.sent = true;
                                   $scope.sent ++;
                                   $scope.checkNumberUpdated();
                                 });
      }

    });
  };

  // Only redirect when everything is done processing.
  $scope.checkNumberUpdated = function(){
    var updatedNum = 0;
    $scope.newGuide.stages.forEach(function(stage){
      if (stage.selected || stage.exists){
        updatedNum++;
      }
    });
    if (updatedNum === $scope.sent){
      $scope.newGuide.sending = false;
      localStorageService.remove('guide');
      window.location.href = '/guides/' + $scope.newGuide._id + '/';
    }
  };

  $scope.placeStageUpload = function(stage, image){
    if (!stage.pictures){
      stage.pictures = [];
    }
    stage.pictures.push({
      new: true,
      image_url: image
    });
  };

  $scope.placeStageActionUpload = function(action, image){
    if (!action.pictures){
      action.pictures = [];
    }
    action.pictures.push({
      new: true,
      image_url: image
    });
  };

  $scope.placeGuideUpload = function(image){
    $scope.newGuide.featured_image = image;
  };

  $scope.cancel = function(path){
    localStorageService.remove('guide');
    window.location.href = path || '/';
  };
}]);
