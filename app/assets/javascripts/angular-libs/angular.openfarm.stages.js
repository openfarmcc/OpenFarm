openFarmModule.factory('stageService', ['$http',
  function stageService($http) {
    // A regularly used pushToAlerts method

    var createStage = function(params, alerts, callback){
      $http.post('/api/stages/', params)
      .success(function (response) {
        console.log('response:', response);
        return callback (true, response.stage);
      }).error(function (response, code) {
        pushToAlerts(response, code, alerts);
      });
    };

    var updateStage = function(stageId, params, alerts, callback){
      $http.put('/api/stages/' + stageId + '/', params)
      .success(function (response) {
        return callback (true, response.stage);
      })
      .error(function (response, code) {
        pushToAlerts(response, code, alerts);
      });
    };

    var deleteStage = function(stageId, alerts, callback){
      $http.delete('/api/stages/' + stageId + '/')
      .success(function(response){
        return callback (true, response);
      })
      .error(function(r){
        pushToAlerts(response, code, alerts);
      });
    };

    return {
      // 'getGuide': getStage,
      'deleteStage': deleteStage,
      'createStage': createStage,
      'updateStage': updateStage
    };
}]);
