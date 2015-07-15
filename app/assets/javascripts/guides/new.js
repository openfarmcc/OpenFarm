openFarmApp.config(['$locationProvider', function($locationProvider) {
  $locationProvider.html5Mode(false).hashPrefix('!');
}]);

openFarmApp.controller('newGuideCtrl', ['$scope', '$http', '$q',
  'guideService', 'stageService', '$location', 'localStorageService',
  'alertsService', '$rootScope', 'cropService', 'defaultService', 'userService',
  function newGuideCtrl($scope, $http, $q, guideService, stageService,
                        $location, localStorageService, alertsService,
                        $rootScope, cropService, defaultService, userService) {

  $scope.$on('$locationChangeSuccess', function(){
    $rootScope.step = +$location.hash() || 1;
  });

  $scope.options = {
    'environment': [],
    'light': [],
    'soil': [],
    'practices': []
  }

  var practices = [];

  $scope.loadingThings = true;
  $scope.sending = 0;
  $scope.cropQuery = '';
  $scope.crops = [];
  $rootScope.step = +$location.hash() || 1;
  $scope.crop_not_found = false;
  $scope.addresses = [];
  $scope.hasEdited = [];
  $scope.existingGuideID = getIDFromURL('guides');
  $scope.guideExists = ($scope.existingGuideID &&
                        $scope.existingGuideID !== 'new');

  var processCropID = function(crop_id) {
    if (crop_id){
      cropService.getCrop(crop_id, function(success, crop) {
        if (success) {
          $scope.newGuide.crop = crop;
          $scope.query = crop.name;
        }
      });
    }
  };

  var loadExternalGuide = function(existingGuide, practices){
    $scope.newGuide.exists = true;
    $scope.newGuide.practices = practices;
    $scope.newGuide.id = existingGuide.id;
    $scope.newGuide.featured_image = existingGuide.featured_image;
    $scope.s3upload = existingGuide.featured_image;
    $scope.newGuide.crop = existingGuide.crop;
    $scope.newGuide.name = existingGuide.name;
    $scope.newGuide.location = existingGuide.location;
    $scope.newGuide.overview = existingGuide.overview;
    $scope.newGuide.loadedStages = existingGuide.stages;

    var transferTimeSpan = function(defaultTS, remoteTS){
      var newTimeSpan = remoteTS || defaultTS;
      newTimeSpan.set_length = defaultTS.set_length;
      newTimeSpan.set_start_event = defaultTS.set_start_event;
      return newTimeSpan;
    };

    $scope.newGuide.time_span = transferTimeSpan($scope.newGuide.time_span,
                                                 existingGuide.time_span);

    if (existingGuide.practices){
      $scope.newGuide.practices.forEach(function(practice){
        if (existingGuide.practices.indexOf(practice.slug) !== -1){
          practice.selected = true;
        }
      });
    }
    // processCropID(existingGuide.crop_id);
  };

  var resetAlert = function(){
    $rootScope.alerts.push({
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

  var checkGuideSource = function(externalGuide, practices, checkAlert){
    if (externalGuide !== undefined && externalGuide.id !== undefined) {
      loadExternalGuide(externalGuide, practices);
    } else {
      var localGuide = localStorageService.get('guide')
      if (localGuide && !localGuide.id){
        $scope.newGuide = localGuide;
        if (checkAlert){
          resetAlert();
        }
        // There is some cross-scope polution going on here.
        // Clean it up. The stage thing is a mess.
        $scope.newGuide.stagesToBuildFromLocalStoredGuide = true;
      } else {
        $scope.newGuide.stagesToBuildDefault = true;
      }
    }

    // AND FINALLY sets the guide name.
    $scope.$watch('newGuide.crop', function(afterValue){
      if (afterValue !== undefined &&
          ($scope.newGuide.name === undefined ||
           $scope.newGuide.name === ''))
      $scope.newGuide.name = $scope.user.display_name + "'s " + $scope.newGuide.crop.name;
    })
    $scope.newGuide.location = $scope.user.user_setting.location;
  };

  var buildNewGuide = function(crop){

    $scope.originalGuide = {
      name: '',
      crop: crop,
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
      start_time: moment().format('MMMM'),
      stagesToBuildFromLocalStoredGuide: false,
      stagesToBuildDefault: false
    };

    $scope.newGuide = angular.copy($scope.originalGuide);

    $scope.$watch('newGuide', function(){
      if (!$scope.guideExists){
        localStorageService.set('guide', $scope.newGuide);
      }
    }, true);

    $scope.loadingEverything = false;
  };

  // This starts loading everything!
  $q.all([
      defaultService.getDetailOptions(),
      guideService.getGuideWithPromise(getIDFromURL('guides')),
      cropService.getCropWithPromise(getUrlVar('crop_id')),
      userService.getUserWithPromise(USER_ID)
    ])
  .then(function(data){
    var externalGuide,
        crop,
        user;
    var detail_options = data[0];
    $scope.user = data[3];
    if ($scope.guideExists){
      externalGuide = data[1];
    }
    if (data[2]) {
      crop = data[2];
      $scope.query = crop.name;
    }


    detail_options.forEach(function(detail) {
      // var category = detail.category + 'Options';
      if ($scope.options[detail.category] !== undefined) {
        $scope.options[detail.category].push(detail.name);
      }
    });

    practices = $scope.options.practices.map(function(practice) {
      return {
        // TODO: make the slug creation more robust.
        'slug': practice.toLowerCase(),
        'label': practice,
        'selected': false
      };
    });
    buildNewGuide(crop);
    checkGuideSource(externalGuide, practices, true);
  }, function(error) {
    console.log('error', error);
  });

  $scope.switchToStep = function(step){
    $rootScope.step = step;
    $location.hash($rootScope.step);
    scrollToTop();
  };

  var scrollToTop = function(){
    window.scrollTo($('.guides').scrollTop(), 0);
  }

  $scope.nextStep = function(){
    if ($rootScope.step === 3){
      $scope.hasEditedStages = true;
    }
    $rootScope.step += 1;
    $location.hash($rootScope.step);
    scrollToTop();
  };

  $scope.previousStep = function(){
    $rootScope.step -= 1;
    $location.hash($rootScope.step);
    scrollToTop();
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

    var data = {
      'attributes': {
        time_span: $scope.newGuide.time_span,
        name: $scope.newGuide.name,
        overview: $scope.newGuide.overview || null,
        location: $scope.newGuide.location || null,
        featured_image: defineFeaturedImage($scope.newGuide.featured_image),
        practices: practices
      },
      'crop_id': $scope.newGuide.crop.id
    }



    if (data.crop_id === null) {
      data.crop_name = $scope.newGuide.crop.name;
    }

    if (data.featured_image === '/assets/leaf-grey.png'){
      data.featured_image = null;
    }

    return data;
  };

  $scope.submitForm = function () {
    $scope.sending++;
    var params = { 'data': buildParametersFromScope() };

    if ($scope.newGuide.id){
      // In this case the guide already existed,
      // so we need to put, not to post.
      // TODO: refactor the $scope.alerts thing
      // so that it cancels things if things go wrong
      params.data.id = $scope.newGuide.id;

      guideService.updateGuideWithPromise(params.data.id, params)
        .then($scope.sendStages);
    } else {
      guideService.createGuideWithPromise(params)
        .then($scope.sendStages)
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

  $scope.sendStages = function(guide){
    $scope.newGuide.id = guide.id;

    $scope.newGuide.stages.forEach(function(stage){

      var data;
      if (stage.selected) {
        data = {
          'attributes': {
            'name': stage.name,
            'order': stage.order,
            'stage_length': calcTimeLength(stage.stage_length, stage.length_type),
            'environment': stage.environment.filter(function(s){
                return s.selected;
              }).map(function(s){
                return s.label;
              }) || null,
            'soil': stage.soil.filter(function(s){
                return s.selected;
              }).map(function(s){
                return s.label;
              }) || null,
            'light': stage.light.filter(function(s){
                return s.selected;
              }).map(function(s){
                return s.label;
              }) || null,
          },
          'guide_id': guide.id,
          'actions': stage.stage_action_options.filter(function(a){
                return a.overview || a.time || (a.pictures && a.pictures.length > 0);
              }).map(function(action, index){
                var img = null;
                if(action.pictures !== null) {
                  img = action.pictures.filter(function(p){
                    return !p.deleted;
                   });
                }
                return { name: action.name,
                         images: img,
                         overview: action.overview,
                         time: calcTimeLength(action.time, action.length_type),
                         order: index };
              }) || null
        };
        if (stage.pictures){
          data.images = stage.pictures.filter(function(p){
            return !p.deleted;
          });
        }
      }

      // Go through all the possible changes on
      // each stage.
      if (stage.selected && !stage.exists){
        $scope.sending++;
        console.log('creating stage');
        stageService.createStageWithPromise({'data': data})
          .then(function(stage){
            stage.sent = true;
            $scope.sending--;
            $scope.checkNumberUpdated();
          });

      } else if (stage.selected && stage.exists){
        $scope.sending++;
        console.log('updating stage');
        stageService.updateStageWithPromise(stage.id, {'data': data})
          .then(function(stage){
             stage.sent = true;
             $scope.sending--;
             $scope.checkNumberUpdated();
           });

      } else if (stage.exists){
        $scope.sending++;
        console.log('deleting stage');
        stageService.deleteStageWithPromise(stage.id)
          .then(function(){
            stage.sent = true;
            $scope.sent ++;
            $scope.sending--;
            $scope.checkNumberUpdated();
          });
      }

    });
  };

  // Only redirect when everything is done processing.
  $scope.checkNumberUpdated = function(){
    if ($scope.sending === 0){
      localStorageService.remove('guide');
      window.location.href = '/guides/' + $scope.newGuide.id + '/';
    }
  };

  $scope.placeGuideUpload = function(image){
    $scope.newGuide.featured_image = image;
  };

  $scope.cancel = function(path){
    localStorageService.remove('guide');
    window.location.href = path || '/';
  };
}]);
