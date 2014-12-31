openFarmModule.factory('guideService', ['$http',
  function guideService($http) {
    // A regularly used pushToAlerts method
    var pushToAlerts = function (response, code, alerts){
      console.log(response, code);
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
    return {
      'getGuide': getGuide,
      'createGuide': createGuide,
      'updateGuide': updateGuide
    };
}]);

openFarmModule.directive('timeline', [
  function timeline(){
    var calculateStartOfYear = function(m){
      return moment('12 21', 'MM DD');
    };



    return {
      restrict: 'A',
      scope: true,
      controller: ['$scope', function($scope){
        var maxWidth,
            yearLength,
            firstDay,
            span,
            currentDay,
            day,
            today,
            todayIndex,
            daysRemainingInYear,
            remainderDays;

        $scope.days = [];
        $scope.dayWidth = 0;
        today = moment();

        maxWidth = $('.timeline-box').width();
        // The domain is maxWidth
        // The range is 364 days in a year
        yearLength = moment.duration(1, 'year').asDays();
        $scope.dayWidth = maxWidth/yearLength;

        // calculate year start time based on user preference/location
        firstDay = calculateStartOfYear(moment());

        for (var i = 0; i <= yearLength; i++) {
          // calculate if it's the start of the month
          currentDay = moment(firstDay.add(1, 'days'));
          day = {
            currentDay: currentDay,
          };
          if (currentDay.date() === 1){
            day.first = true;
          }
          if (currentDay.isSame(today, 'day') &&
              currentDay.isSame(today, 'month')){
            day.today = true;
            todayIndex = i;
          }
          $scope.days.push(day);
        }

        // Draw the lifetime
        $('.plantLifetime').css('left', todayIndex * $scope.dayWidth);
        // Deal with the overflow
        daysRemainingInYear = yearLength - todayIndex;
        if (daysRemainingInYear < $scope.plantLifetime){
          $('.plantLifetime').width(daysRemainingInYear * $scope.dayWidth);
          remainderDays = $scope.plantLifetime - daysRemainingInYear;
          console.log(remainderDays);
          $('.timelines')
            .append('<span class="plantLifetime overflow">');
          console.log($('.plantLifetime.overflow').width(remainderDays));
        } else {
          $('.plantLifetime').width($scope.plantLifetime * $scope.dayWidth);
        }


      }],
      templateUrl: '/assets/templates/_timeline.html'
    };
  }]);
