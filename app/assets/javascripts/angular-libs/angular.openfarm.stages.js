openFarmModule.factory('stageService', ['$http', 'alertsService',
  function stageService($http, alertsService) {

    // Should return Stage model:
    // {
    //   id: '',
    //   name: '',
    //   location: '',
    //   ...
    //   stages: [],
    //
    // }

    var buildStage = function(data) {
      var stage = data.attributes
      return stage;
    }

    var createStage = function(params, alerts, callback){
      $http.post('/api/v1/stages/', params)
        .success(function (response) {
          return callback (true, response.stage);
        }).error(function (response, code) {
          alertsService.pushToAlerts(response, code, alerts);
        });
    };

    var updateStage = function(stageId, params, alerts, callback){
      $http.put('/api/v1/stages/' + stageId + '/', params)
        .success(function (response) {
          return callback (true, response.stage);
        })
        .error(function (response, code) {
          alertsService.pushToAlerts(response, code, alerts);
        });
    };

    var deleteStage = function(stageId, alerts, callback){
      $http.delete('/api/v1/stages/' + stageId + '/')
        .success(function(response){
          return callback (true, response);
        })
        .error(function(r){
          alertsService.pushToAlerts(response, code, alerts);
        });
    };

    return {
      // 'getGuide': getStage,
      'utilities': {
        'buildStage': buildStage
      },
      'deleteStage': deleteStage,
      'createStage': createStage,
      'updateStage': updateStage
    };
}]);
