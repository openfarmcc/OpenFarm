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
  };

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

  // Ideally we'll find a way of including this function in
  // the stages directive.
  $scope.editSelectedStage = function(chosenStage){
    $scope.newGuide.stages.forEach(function(stage){
      stage.editing = false;
      if (chosenStage.name === stage.name){
        stage.editing = true;

        $scope.currentStage = chosenStage;
      }
    });
  };

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

  var loadExternalGuide = function(localGuide, existingGuide, practices){
    localGuide.exists = true;
    localGuide.practices = practices;
    localGuide.id = existingGuide.id;
    localGuide.featured_image = existingGuide.featured_image;
    $scope.s3upload = existingGuide.featured_image;
    localGuide.crop = existingGuide.crop;
    localGuide.name = existingGuide.name;
    localGuide.location = existingGuide.location;
    localGuide.overview = existingGuide.overview;
    localGuide.loadedStages = existingGuide.stages;

    var transferTimeSpan = function(defaultTS, remoteTS){
      var newTimeSpan = remoteTS || defaultTS;
      newTimeSpan.set_length = defaultTS.set_length;
      newTimeSpan.set_start_event = defaultTS.set_start_event;
      return newTimeSpan;
    };

    localGuide.time_span = transferTimeSpan(localGuide.time_span,
                                                 existingGuide.time_span);

    if (existingGuide.practices){
      localGuide.practices.forEach(function(practice){
        if (existingGuide.practices.indexOf(practice.slug) !== -1){
          practice.selected = true;
        }
      });
    }
    return localGuide;
  };

  var resetAlert = function(){
    $rootScope.alerts.push({
      msg: 'We noticed that you hadn\'t finished completing your guide, ' +
           'so we preloaded it.',
      type: 'info',
      action: 'Start from scratch?',
      cancelTimeout: true,
      actionFunction: function(index){
        $scope.newGuide = guideService.utilities.buildBlankGuide(
            null,
            [],
            practices
          );
        $scope.alerts.splice(index, 1);
        $scope.switchToStep(1);
        localStorageService.remove('guide');
      }
    });
  };

  // check what the guide source is.
  var checkingGuideSource = function() {
    return $q(function (resolve, reject) {
      var guide = null;
      var localGuide = localStorageService.get('guide');
       if ($scope.guideExists) {

      // else if we've found a localguide and it's not blank
      } else if (localGuide !== undefined && localGuide !== null &&
          !guideService.utilities.isBlankGuide(localGuide, practices)) {
        // if it's local storage, we've been here before, but first
        // check that the guide in localStorage isn't just a blank guide.
        guide = localGuide;
        guide.id = undefined;
        resetAlert();
        // There is some cross-scope polution going on here.
        // Clean it up. The stage thing is a mess.
        guide.stagesToBuildFromLocalStoredGuide = true;
        guide.stagesToBuildDefault = false;
        resolve(guide);

      // else, we start from scratch
      } else {
        guide = guideService.utilities.buildBlankGuide(null, [], practices);
        resolve(guide);
      }
    });
  };

  // First FIRST we need to get all of the defaults
  $q.all([
      defaultService.processedDetailOptions(),
      cropService.getCropWithPromise(getUrlVar('crop_id')),
      userService.getUserWithPromise(USER_ID),
    ])
  .then(function(data){
    var crop;

    var detail_options = data[0];
    $scope.options = detail_options;
    practices = detail_options.multiSelectPractices;

    if (data[1]) {
      crop = data[1];
      $scope.query = crop.name;
    }
    $scope.user = data[2];

    checkingGuideSource()
      .then(function(guide) {
        $scope.newGuide = guide;

        $scope.$watch('newGuide', function() {
          if (!$scope.guideExists){
            localStorageService.set('guide', $scope.newGuide);
          }
        }, true);

        $scope.$watch('newGuide.crop', function(afterValue){
          if (afterValue !== undefined && afterValue !== null &&
              ($scope.newGuide.name === undefined ||
               $scope.newGuide.name === '')) {
            $scope.newGuide.name = $scope.user.display_name +
                                   '\'s ' +
                                   $scope.newGuide.crop.name;
          }
        });
        $scope.newGuide.location = $scope.user.user_setting.location;
      },
      function(error) {
        console.log('an error', error);
      });
  }, function(error) {
    console.log('error', error);
  });

  // Methods to switch between steps

  var recalcHeight = function() {
    var $viewing = $('.step:not(.ng-hide)')

    var maxHeight = Math.max.apply(null, $(".step").map(function () {
        return $(this).height();
    }).get());

    if (maxHeight < 850) {
      maxHeight = 850;
    }

    $viewing.parent().height(maxHeight);
  };

  $scope.switchToStep = function(step){
    $rootScope.previousStep = $rootScope.step;
    $rootScope.step = step;

    recalcHeight();

    $location.hash($rootScope.step);
  };

  recalcHeight();

  // Sending methods

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
      if (image !== undefined &&
          image.image_url !== undefined &&
          image.image_url.indexOf('baren_field') === -1){
        featured_image = image.image_url;
      }
      if (featured_image !== null) {
        return [{
          'image_url': featured_image
        }];
      } else {
        return null;
      }
    };

    var data = {
      'id': $scope.newGuide.id || undefined,
      'attributes': {
        time_span: $scope.newGuide.time_span,
        name: $scope.newGuide.name,
        overview: $scope.newGuide.overview || null,
        location: $scope.newGuide.location || null,
        practices: practices
      },
      'images': defineFeaturedImage($scope.newGuide.featured_image),
      'crop_id': $scope.newGuide.crop.id
    };

    if (data.crop_id === null || data.crop_id === undefined) {
      data.crop_name = $scope.newGuide.crop.name;
    }

    if (data.featured_image === '/assets/leaf-grey.png'){
      data.featured_image = null;
    }

    return data;
  };

  $scope.submitForm = function () {
    $scope.startedSending = true;
    $scope.sending++;
    var params = { 'data': buildParametersFromScope() };

    var errorFunction = function() {
      $scope.startedSending = false;
      $scope.sending--;
    };

    if (params.data.id) {
      guideService.updateGuideWithPromise($scope.newGuide.id, params)
        .then($scope.sendStages, errorFunction);
    } else {
      guideService.createGuideWithPromise(params)
        .then($scope.sendStages, errorFunction);
    }

  };

  function createStageData (stage) {
    // TODO - this method
  }

  $scope.sendStages = function(guide){
    $scope.sending--;
    $scope.newGuide.id = guide.id;

    $scope.newGuide.stages.forEach(function(stage){

      var data = {};
      if (stage.selected) {
        data = {
          'attributes': {
            'name': stage.name,
            'order': stage.order,
            'stage_length': stageService.calcTimeLength(stage.stage_length,
                                           stage.length_type),
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
            'overview': stage.overview
          },
          'guide_id': guide.id,
          'actions': stage.stage_action_options.map(function(action, index){
                var img = null;
                if (action.pictures !== null && action.pictures !== undefined) {
                  img = action.pictures.filter(function(p){
                    return !p.deleted;
                  });
                }
                return { name: action.name,
                         images: img,
                         overview: action.overview,
                         time: stageService.calcTimeLength(action.time, action.length_type),
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
        stageService.createStageWithPromise({'data': data})
          .then(function (createdStage){
            createdStage.sent = true;
            $scope.sending--;
            $scope.checkNumberUpdated();
          })
          .catch(function (err) {

          });
      }
    });
  };

  // Only redirect when everything is done processing.
  $scope.checkNumberUpdated = function(){
    if ($scope.sending === 0){
      localStorageService.remove('guide');
      $scope.startedSending = false;
      window.location.href = '/guides/' + $scope.newGuide.id + '/';
    }
  };

  $scope.placeGuideUpload = function(image){
    $scope.newGuide.featured_image = {'image_url': image};
  };

  $scope.cancel = function(path){
    localStorageService.remove('guide');
    window.location.href = path || '/';
  };
}]);
