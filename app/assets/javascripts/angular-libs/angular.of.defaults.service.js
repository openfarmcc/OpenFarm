openFarmModule.factory('defaultService', ['$http', '$q', 'alertsService',
  function defaultService($http, $q, alertsService) {

    var buildStageActionOption = function(data) {
      var stageActionOption = data.attributes
      return stageActionOption;
    };

    var buildStageOption = function(data) {
      var stageOption = data.attributes
      return stageOption;
    };

    var buildDetailOption = function(data) {
      var detailOption = data.attributes
      return detailOption;
    };

    var processedDetailOptions = function() {
      return $q(function(resolve, reject) {
        getDetailOptions()
          .then(function(detail_options) {
            var options = {
              'environment': [],
              'light': [],
              'soil': [],
              'practices': [],
              'multiSelectPractices': [],
              'multiSelectEnvironment': [],
              'multiSelectLight': [],
              'multiSelectSoil': []
            };

            detail_options.forEach(function(detail) {
              if (options[detail.category] !== undefined) {
                options[detail.category].push(detail.name);
              }
            });

            // TODO: so much code repetition here, how can we bring
            // that down?

            options.multiSelectPractices = options.practices.map(function(practice) {
              return {
                // TODO: make the slug creation more robust.
                'slug': practice.toLowerCase(),
                'label': practice,
                'selected': false
              };
            });

            options.multiSelectSoil = options.soil.map(function(soil) {
              return {
                // TODO: make the slug creation more robust.
                'slug': soil.toLowerCase(),
                'label': soil,
                'selected': false
              };
            });

            options.multiSelectEnvironment = options.environment.map(function(env) {
              return {
                // TODO: make the slug creation more robust.
                'slug': env.toLowerCase(),
                'label': env,
                'selected': false
              };
            });

            options.multiSelectLight = options.light.map(function(light) {
              return {
                // TODO: make the slug creation more robust.
                'slug': light.toLowerCase(),
                'label': light,
                'selected': false
              };
            });

            resolve(options)
          }, function(error) {
            console.log('error fetching processed detail options');
            reject(error)
          });

      });
    };

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
            reject(response);
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
      'processedDetailOptions': processedDetailOptions,
      'getDetailOptions': getDetailOptions,
      'getStageOptions': getStageOptions,
      'getStageActionOptions': getStageActionOptions
    };
}]);
