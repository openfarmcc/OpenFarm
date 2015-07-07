openFarmModule.factory('guideService', ['$http',
  function guideService($http) {
    // A regularly used pushToAlerts method
    var pushToAlerts = function (response, code, alerts){
      var msg = '';
    angular.forEach(response, function(value){
        msg += value;
      });
      alerts.push({
        msg: msg,
        type: 'warning'
      });
    };

    // get the guide specified.
    var getGuide = function(guideId, alerts, callback){
      $http({
        url: '/api/guides/' + guideId,
        method: 'GET'
      }).success(function (response) {
        return callback (true, response.guide);
      }).error(function (response, code) {
        pushToAlerts(response, code, alerts);
      });
    };

    var createGuide = function(params, alerts, callback){
      $http.post('/api/guides/', params).success(function (response) {
        return callback (true, response.guide);
      }).error(function (response, code) {
        pushToAlerts(response, code, alerts);
      });
    };

    var updateGuide = function(guideId, params, alerts, callback){
      $http.put('/api/guides/' + guideId + '/', params)
      .success(function (response) {
        return callback (true, response.guide);
      })
      .error(function (response, code) {
        pushToAlerts(response, code, alerts);
      });
    };

    var calculateStartOfYear = function(){
      // calculate year start time based on user preference/location
      return moment('01 01', 'MM DD');
    };

    var scaleSeasonsToDays = function(){
      // The domain is maxWidth of the seasons div. Probably could
      // be more flexible.
      // The range is # days in a year

      var maxWidth;

      maxWidth = $('.seasons').width();

      var scale = {
        'range': maxWidth,
        'domain': moment.duration(1, 'year').asDays(),
      };

      scale.convertPositionToWeek = function(position){
        var intPosition = parseInt(position, 10);
        var self = this;
        return Math.floor((intPosition/self.step / 7));
      };

      scale.convertWeekToPosition = function(week){
        var intWeek = parseInt(week, 10);
        var self = this;
        return self.step * 7 * (intWeek);
      };

      scale.step = scale.range / scale.domain;
      return scale;
    };

    var drawTimeline = function(timespan, callback){
      var firstDay,
          currentDay,
          day,
          today,
          todayIndex,
          days,
          scale;

      days = [];
      today = moment();

      scale = scaleSeasonsToDays();

      firstDay = currentDay = calculateStartOfYear();
      for (var i = 0; i <= scale.domain; i++) {
        // calculate if it's the start of the month

        day = {
          currentDay: currentDay,
        };
        if (currentDay.date() === 1){
          day.first = true;
        }
        if (currentDay.date() === today.date() &&
            currentDay.month() === today.month()){
          day.today = true;
          todayIndex = i;
        }
        days.push(day);
        currentDay = moment(currentDay.add(1, 'days'));
      }

      // Draw the lifetime at the right spot
      $('.plantLifetime')
        .css('left', scale.convertWeekToPosition(timespan.start_event));
      // // Deal with the overflow
      // daysRemainingInYear = yearLength - todayIndex;
      // if (daysRemainingInYear < plantLifetime){
      //   $('.plantLifetime').width(daysRemainingInYear * dayWidth);
      //   remainderDays = plantLifetime - daysRemainingInYear;
      //   $('.timelines')
      //     .append('<span class="plantLifetime overflow">');
      //   $('.plantLifetime.overflow').width(remainderDays);
      // } else {

        // This has a * 7 multiplier because we're assuming weeks.
        $('.plantLifetime')
          .width(scale.convertWeekToPosition(timespan.length));

        $('.plantLifetime').on('mouseup', function(){
          var left = $(this).css('left');
          var scaled = scale.convertPositionToWeek(left);
          timespan
            .set_start_event(scaled);
        });
      // }
      return callback(days, scale.step, scale);
    };
    return {
      'getGuide': getGuide,
      'createGuide': createGuide,
      'updateGuide': updateGuide,
      'drawTimeline': drawTimeline
    };
}]);

openFarmModule.directive('timeline', ['guideService',
  function timeline(guideService){
    return {
      restrict: 'A',
      scope: true,
      controller: ['$scope', function($scope){
        guideService.drawTimeline();
      }],
      templateUrl: '/assets/templates/_timeline.html'
    };
  }]);

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

openFarmApp.factory('focus', ['$rootScope', '$timeout',
  function ($rootScope, $timeout) {
    return function(name) {
      $timeout(function (){
        $rootScope.$broadcast('focusOn', name);
      });
    };
}]);

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
