openFarmModule.factory('guideService', ['$http', '$q', 'alertsService',
  'stageService', 'userService',
  function guideService($http, $q, alertsService, stageService, userService) {

    // Should return Guide model:
    // {
    //   id: '',
    //   name: '',
    //   location: '',
    //   ...
    //   stages: [],
    //
    // }

    var buildGuide = function(data, included) {
      var stages,
          user,
          crop;
      var guide = data.attributes;
      guide.id = data.id;
      guide.relationships = data.relationships;
      guide.links = data.links;

      stages = included.filter(function(obj) {
        return obj.type === 'stages';
      }).map(function(stage) {
        return stageService.utilities.buildStage(stage);
      });

      user = included.filter(function(obj) {
        return obj.type === 'users';
      });

      if (user.length > 0) {
        guide.user = userService.utilities.buildUser(user[0]);
      }
      guide.stages = stages;
      return guide;
    }

    // Builds params according to JSON-API from the
    // front end Guide model.
    var buildParams = function(guideObject) {
      var data = {
        type: 'guides',
        id: guideObject.id,
        attributes: guideObject,
      }
      return {'data': data}
    }

    // get the guide specified. Out of Date. Use Promise Function
    // below
    var getGuide = function(guideId, callback){
      $http({
        url: '/api/v1/guides/' + guideId,
        method: 'GET'
      }).success(function (response) {
        return callback (true, buildGuide(response.data, response.included));
      }).error(function (response, code) {
        alertsService.pushToAlerts(response, code);
      });
    };
    // This function should replace the above function,
    // part of refactoring.
    var getGuideWithPromise = function(guideId) {
      return $q( function(resolve, reject) {
        if (guideId === "") {
          $http('/api/v1/guides/' + guideId)
          .success(function (response) {
            resolve(buildGuide(response.data, response.included));
          }).error(function (response, code) {
            alertsService.pushToAlerts(response, code);
            reject(response);
          });
        } else {
          resolve();
        }

      });
    };

    var createGuide = function(params, callback){
      $http.post('/api/v1/guides/', params).success(function (response) {
        return callback (true, buildGuide(response.data, response.included));
      }).error(function (response, code) {
        alertsService.pushToAlerts(response, code);
      });
    };

    var createGuideWithPromise = function(params) {
      return $q(function(resolve, reject) {
        $http.post('/api/v1/guides/', params).success(function (response) {
          resolve(buildGuide(response.data, response.included));
        }).error(function (response, code) {
          reject();
          alertsService.pushToAlerts(response, code);
        });
      });
    }

    var updateGuide = function(guideId, params, callback){
      $http.put('/api/v1/guides/' + guideId + '/', params)
        .success(function (response) {
          return callback (true, buildGuide(response.data, response.included));
        })
        .error(function (response, code) {
          alertsService.pushToAlerts(response, code);
        });
    };

    var updateGuideWithPromise = function(guideId, params) {
      return $q(function (resolve, reject) {
        $http.put('/api/v1/guides/' + guideId + '/', params)
          .success(function (response) {
            return resolve(buildGuide(response.data, response.included));
          })
          .error(function (response, code) {
            reject();
            alertsService.pushToAlerts(response, code);
          });
      });
    }

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
      'getGuideWithPromise': getGuideWithPromise,
      'updateGuideWithPromise': updateGuideWithPromise,
      'createGuideWithPromise': createGuideWithPromise,
      'createGuide': createGuide,
      'updateGuide': updateGuide,
      'drawTimeline': drawTimeline
    };
}]);
