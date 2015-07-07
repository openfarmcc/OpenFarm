openFarmModule.factory('cropService', ['$http', '$log',
  function cropService($http, $log) {

    // Should return Crop model:
    // {
    //   id: '',
    //   pictures: '',
    //   binomial_name: '',
    //   ...
    // }

    var buildCrop = function(response) {
      var crop = response.data.attributes;
      crop.id = response.data.id;
      var pictures = response.included.filter(function(obj) {
        return obj.type === 'pictures';
      });
      crop.pictures = pictures;
      return crop;
    };

    // Builds Params according to JSON-API from the
    // front-end Crop model
    var buildParams = function(cropObject) {
      var data = {
        type: 'crops',
        id: cropObject.id,
        attributes: cropObject,
        relationships: {
          'pictures': cropObject.images,
        }
      };
      cropObject.images = null;
      return {'data': data};
    }

    // get the guide specified.
    var getCrop = function(cropId, alerts, callback){
      $http({
        url: '/api/v1/crops/' + cropId,
        method: 'GET'
      }).success(function (response) {
        return callback (true, buildCrop(response));
      }).error(function (response, code) {
        alerts.push({
          msg: code + ' error. Could not retrieve data from server. ' +
            'Please try again later.',
          type: 'warning'
        });
      });
    };

    var updateCrop = function(cropId, cropObject, alerts, callback){
      var url = '/api/v1/crops/' + cropId + '/';
      $log.debug(url);
      $http.put(url, buildParams(cropObject))
        .success(function (response) {
          return callback (true, buildCrop(response));
        })
        .error(function (response) {
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
