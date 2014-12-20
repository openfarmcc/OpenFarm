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

