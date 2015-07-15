openFarmModule.factory('stageService', ['$http', '$q', 'alertsService',
  function stageService($http, $q, alertsService) {

    // Should return Stage model:
    // {
    //   id: '',
    //   name: '',
    //   location: '',
    //   ...
    //   stages: [],
    //
    // }

    var buildStage = function(data, included) {
      console.log("building stage");
      var stage = data.attributes;
      console.log(data);
      if (data.relationships.stage_actions.data.length == 0) {
        stage.stage_actions = [];
      } else {
        // TODO: we'll need to go fetch these from the
        // server.
      }

      return stage;
    }

    var createStage = function(params, callback){
      $http.post('/api/v1/stages/', params)
        .success(function (response) {
          return callback (true, buildStage(response.stage, response.included));
        }).error(function (response, code) {
          alertsService.pushToAlerts(response, code);
        });
    };

    var createStageWithPromise = function(params) {
      return $q(function (resolve, reject) {
        $http.post('/api/v1/stages/', params)
          .success(function (response) {
            resolve(buildStage(response.data, response.included));
          }).error(function (response, code) {
            reject();
            alertsService.pushToAlerts(response, code);
          });
      })
    }

    var updateStage = function(stageId, params, callback){
      $http.put('/api/v1/stages/' + stageId + '/', params)
        .success(function (response) {
          return callback (true, response.stage);
        })
        .error(function (response, code) {
          alertsService.pushToAlerts(response, code);
        });
    };

    var updateStageWithPromise = function(stageId, params) {
      return $q(function (resolve, reject) {
        $http.post('/api/v1/stages/' + stageId + '/', params)
          .success(function (response) {
            resolve(buildStage(response.data));
          }).error(function (response, code) {
            reject();
            alertsService.pushToAlerts(response, code);
          });
      })
    }

    var deleteStage = function(stageId, callback){
      $http.delete('/api/v1/stages/' + stageId + '/')
        .success(function(response){
          return callback (true, response);
        })
        .error(function(r){
          alertsService.pushToAlerts(response, code);
        });
    };

    var deleteStageWithPromise = function(stageId) {
      return $q(function (resolve, reject) {
        $http.delete('/api/v1/stages/' + stageId, params)
          .success(function (response) {
            resolve();
          }).error(function (response, code) {
            reject();
            alertsService.pushToAlerts(response, code);
          });
      })
    }

    return {
      // 'getGuide': getStage,
      'utilities': {
        'buildStage': buildStage
      },
      'createStageWithPromise': createStageWithPromise,
      'updateStageWithPromise': updateStageWithPromise,
      'deleteStageWithPromise': deleteStageWithPromise,
      'deleteStage': deleteStage,
      'createStage': createStage,
      'updateStage': updateStage
    };
}]);
