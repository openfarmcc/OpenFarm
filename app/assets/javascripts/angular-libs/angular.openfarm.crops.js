openFarmModule.factory('cropService', ['$http',
  function cropService($http) {
    // get the guide specified.
    var getCrop = function(cropId, alerts, callback){
      $http({
        url: '/api/crops/' + cropId,
        method: 'GET'
      }).success(function (response) {
        return callback (true, response.crop);
      }).error(function (response, code) {
        alerts.push({
          msg: code + ' error. Could not retrieve data from server. ' +
            'Please try again later.',
          type: 'warning'
        });
      });
    };

    var updateCrop = function(cropId, params, alerts, callback){
      $http.put('/api/crops/' + cropId + '/', params)
      .success(function (response) {
        return callback (true, response.crop);
      })
      .error(function (response, code) {
        console.log(response, code);
        var msg = '';
        angular.forEach(response, function(value){
          msg += value;
        });
        alerts.push({
          msg: msg,
          type: 'warning'
        });
      });
    };
    return {
      'getCrop': getCrop,
      'updateCrop': updateCrop
    };
}]);
