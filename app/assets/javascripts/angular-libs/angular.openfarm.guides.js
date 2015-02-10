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
