openFarmApp.directive('formChecker', function(){
  return {
    // scope: {
    //   'formId': '=',
    //   'formStage': '='
    // },
    require: '^form',
    link: function(scope, element, attr){
      // loop through each stage
      var rootParent = scope.$parent.$parent.$parent;

      scope.$watch('$parent.stage', function(){
        var allDone = [];
        rootParent.stages.forEach(function(stage){
          if (stage.selected){
            stage.where.forEach(function(opt){
              if (opt.selected){
                stage.edited = true;
              }
            });
            stage.light.forEach(function(opt){
              if (opt.selected){
                stage.edited = true;
              }
            });
            stage.soil.forEach(function(opt){
              if (opt.selected){
                stage.edited = true;
              }
            });

            allDone.push(stage.edited ? true : false);
          }
        });
        var tracker = true;
        allDone.forEach(function(isDone){
          if (!isDone){
            tracker = false;
          }
        });

        rootParent.stageThreeTracker = tracker;
      }, true);


    }
  };
});

openFarmApp.directive('stageButtons', [
  function stageButtons(){
    return {
      restrict: 'A',
      scope: {
          abledBool: '&',
          nextFunction: '='
      },
      controller: ['$scope', '$element', '$attrs',
       function ($scope, $element, $attrs){
        $scope.abledText = $attrs.abledText || 'Continue';
        $scope.disabledText =
          $attrs.disabledText || 'You can\'t continue yet.';
        $scope.cancelText = $attrs.cancelText || 'Cancel.';
        $scope.cancelUrl = $attrs.cancelUrl || '/';
        $scope.backText = $attrs.backText || undefined;

        $scope.previousStep = $scope.$parent.previousStep;
        $scope.nextStep = $scope.nextFunction || $scope.$parent.nextStep;
      }],
      template:
        '<div class="button-wrapper row">' +
          '<div class="columns large-12">' +
            '<a class="button small secondary left"' +
              ' name="back"' +
              ' href="{{ cancelUrl }}"' +
              ' ng-click="cancel(cancelUrl)">{{ cancelText }}</a>' +
            '<input class="button small secondary left"' +
              ' ng-if="backText"' +
              ' name="back"' +
              ' type="submit"' +
              ' value="{{ backText }}"' +
              ' ng-click="previousStep()">' +
            '<input class="button small right"' +
              ' name="commit"' +
              ' type="submit"' +
              ' value="{{ abledBool() ? disabledText : abledText }}"' +
              ' ng-disabled="!(abledBool())"' +
              ' ng-click="nextStep()"/>' +
          '</div>' +
        '</div>'
    };
}]);

openFarmApp.controller('newGuideCtrl', ['$scope', '$http',
  function newGuideCtrl($scope, $http) {
  $scope.alerts = [];
  $scope.crops = [];
  $scope.step = 1;
  $scope.crop_not_found = false;
  $scope.addresses = [];
  $scope.stages = [];
  $scope.hasEdited = [];

  $scope.newGuide = {
    name: '',
    crop: undefined,
    overview: '',
    selectedStages: [],
    practices: [
      {slug: 'organic', label: 'Organic', selected: false},
      {slug: 'permaculture', label: 'Permaculture', selected: false},
      {slug: 'conventional', label: 'Conventional', selected: false},
      {slug: 'hydroponic', label: 'Hydroponic', selected: false},
      {slug: 'intensive', label: 'Intensive', selected: false}
    ]
  };

  $http.get('/api/stage_options/')
    .success(function(response){
      $scope.stages = response.stage_options;
      $scope.newGuide.stages = $scope.stages
        .map(function(item){
          item.selected = false;
          item.where = [
            {slug: 'outside', label: 'Outside', selected: false},
            {slug: 'potted', label: 'Potted', selected: false},
            {slug: 'greenhouse', label: 'Greenhouse', selected: false},
            {slug: 'indoors', label: 'Indoors', selected: false}
          ];
          item.light = [
            {slug: 'full_sun', label: 'Full Sun', selected: false},
            {slug: 'partial_sun', label: 'Partial Sun', selected: false},
            {slug: 'shaded', label: 'Shaded', selected: false},
            {slug: 'darkness', label: 'Darkness', selected: false}
          ];
          item.soil = [
            {slug: 'potting', label: 'Potting', selected: false},
            {slug: 'loam', label: 'Loam', selected: false},
            {slug: 'sandy_loam', label: 'Sandy Loam', selected: false},
            {slug: 'clay_loam', label: 'Clay Loam', selected: false},
            {slug: 'sand', label: 'Sand', selected: false},
            {slug: 'clay', label: 'Clay', selected: false}
          ];
          return item;
        });

    })
    .error(function(response, code){
      $scope.alerts.push({
        msg: code + ' error. We had trouble fetching all stage options.',
        type: 'warning'
      });
    });

  $scope.$watch('stagesForm', function(){
    console.log($scope.stagesForm);
  });

  $scope.$watch('newGuide.stages', function(){
    $scope.newGuide.selectedStages = [];
    if ($scope.newGuide.stages){
      $scope.newGuide.stages
        .forEach(function(item, index){
          if (item.selected){
            item.originalIndex = index;
            $scope.newGuide.selectedStages.push(item);
          }
        });
    }

    $scope.newGuide.selectedStages.sort(function(a, b){
      return a.order > b.order;
    });
  }, true);

  $scope.$watch('step', function(afterValue){
    if (afterValue === 3){
      var selectedSet = false;
      $scope.newGuide.selectedStages.forEach(function(stage){
        if (stage.selected && !selectedSet){
          // hacked hack is a hack
          $scope.newGuide.stages[stage.originalIndex].editing = true;
          selectedSet = true;
        } else {
          $scope.newGuide.stages[stage.originalIndex].editing = false;
        }
      });
    }
  });

  if (getUrlVar("crop_id")){
    $http.get('/api/crops/' + getUrlVar("crop_id"))
      .success(function(r){
        $scope.newGuide.crop = r.crop;
        $scope.query = r.crop.name;
      })
      .error(function(r, e){
        $scope.alerts.push({
          msg: e,
          type: 'alert'
        });
        console.log(e);
      });
  }

  //Typeahead search for crops
  $scope.search = function () {
    // be nice and only hit the server if
    // length >= 3
    if ($scope.query.length >= 3){
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

  $scope.createCrop = function(){
    window.location.href = '/crops/new/?name=' + $scope.query;
  };

  $scope.nextStep = function(){
    $scope.step += 1;
  };

  $scope.previousStep = function(){
    $scope.step -= 1;
  };

  $scope.editSelectedStage = function(stage){
    $scope.newGuide.selectedStages.forEach(function(item){
      item.editing = false;
      if (stage === item){
        item.editing = true;
      }
    });
  };

  // The submit process.
  // Get the practices and clean them up.
  // Set up the parameters.
  // Post! & forward if successful

  $scope.submitForm = function () {
    var practices = [];
    angular.forEach($scope.newGuide.practices, function(value, key){
      console.log(value);
      if (value.selected){
        practices.push(value.slug);
      }
    }, practices);
    console.log(practices);
    var params = {
      name: $scope.newGuide.name,
      crop_id: $scope.newGuide.crop._id,
      overview: $scope.newGuide.overview || null,
      location: $scope.newGuide.location || null,
      featured_image: $scope.newGuide.featured_image || null,
      practices: practices
    };
    console.log('sending params', params );
    $http.post('/api/guides/', params)
      .success(function (r) {
        var guide = r.guide;
        // window.location.href = "/guides/" + r.guide._id + "/edit/";
        var sent = 0;
        $scope.newGuide.stages.forEach(function(stage){
          if (stage.selected){
            var stageParams = {
              name: stage.name,
              guide_id: guide._id,
              length: stage.length || null,
              where: stage.where.filter(function(s){
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
                }) || null
            };

            $http.post('/api/stages/', stageParams)
              .success(function(r){
                // TODO: Redirect the page when all stages
                // are done.
                sent++;
                console.log('completed sending', sent);
                if (sent === $scope.newGuide.selectedStages.length){
                  window.location.href = "/guides/" + guide._id + "/edit/";
                }
                console.log('sent one stage', r);
              })
              .error(function(r){
                $scope.alerts.push({
                  msg: r.error,
                  type: 'alert'
                });
                console.log(r);
              })
          }
        });
      });
      .error(function (r) {
        $scope.alerts.push({
          msg: r.error,
          type: 'alert'
        });
      });
  };

  // Any function returning a promise object can be used to load values asynchronously

  $scope.cancel = function(path){
    window.location.href = path || '/';
  };
}]);
