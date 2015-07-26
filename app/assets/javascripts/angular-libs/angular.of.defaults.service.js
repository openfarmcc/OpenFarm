openFarmModule.factory('defaultService', ['$http', '$q', 'alertsService',
  function defaultService($http, $q, alertsService) {

    // Should return Stage model:
    // {
    //   id: '',
    //   name: '',
    //   location: '',
    //   ...
    //   stages: [],
    //
    // }

    var buildStageActionOption = function(data) {
      var stageActionOption = data.attributes
      return stageActionOption;
    }

    var buildStageOption = function(data) {
      var stageOption = data.attributes
      return stageOption;
    }

    var buildDetailOption = function(data) {
      var detailOption = data.attributes
      return detailOption;
    }

    var getDetailOptions = function() {
      return $q(function(resolve, reject) {
        $http.get('/api/v1/detail_options/')
          .success(function (response, code) {
            resolve(response.data.map(function(obj) {
              return buildDetailOption(obj)
            }));
          })
          .error(function (response, code) {
            alertsService.pushToAlerts(response, code);
          })
      })
    };

    var getStageOptions = function() {
      return $q(function(resolve, reject) {
        $http.get('/api/v1/stage_options/')
          .success(function (response, code) {
            resolve(response.data.map(function(obj) {
              return buildStageOption(obj)
            }));
          })
          .error(function (response, code) {
            alertsService.pushToAlerts(response, code);
          })
      })
    }

    var getStageActionOptions = function() {
      return $q(function(resolve, reject) {
        $http.get('/api/v1/stage_action_options/')
          .success(function (response, code) {
            resolve(response.data.map(function(obj) {
              return buildStageActionOption(obj)
            }));
          })
          .error(function (response, code) {
            alertsService.pushToAlerts(response, code);
          })
      })
    }

    return {
      'utilities': {
        'buildDetailOption': buildDetailOption,
        'buildStageOption': buildStageOption
      },
      'getDetailOptions': getDetailOptions,
      'getStageOptions': getStageOptions,
      'getStageActionOptions': getStageActionOptions
    };
}]);
