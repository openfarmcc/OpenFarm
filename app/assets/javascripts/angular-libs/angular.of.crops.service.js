openFarmModule.factory('cropService', ['$http', '$q', '$log', 'alertsService',
  function cropService($http, $q, $log, alertsService) {

    // Should return Crop model:
    // {
    //   id: '',
    //   pictures: '',
    //   binomial_name: '',
    //   ...
    // }

    var buildCrop = function(data, included) {
      var pictures;
      var crop = data.attributes;
      crop.id = data.id;
      crop.relationships = data.relationships;
      crop.links = data.links;

      if (included) {
        pictures = included.filter(function(obj) {
          return obj.type === 'pictures';
        }).map(function(pic) {
          return pic.attributes;
        })
      }

      crop.pictures = pictures || [];
      return crop;
    };

    // Builds Params according to JSON-API from the
    // front-end Crop model
    var buildParams = function(cropObject) {
      var data = {
        type: 'crops',
        id: cropObject.id,
        attributes: cropObject,
        images: cropObject.images
      };
      cropObject.images = null;
      return {'data': data};
    }

    // get the guide specified.
    var getCrop = function(cropId, callback){
      $http({
        url: '/api/v1/crops/' + cropId,
        method: 'GET'
      }).success(function (response) {
        return callback (true, buildCrop(response.data, response.included));
      }).error(function (response, code) {
        alertsService.pushToAlerts(response, code);
      });
    };

    var getCropWithPromise = function(cropId) {
      return $q(function (resolve, reject) {
        if (cropId !== undefined && cropId !== '') {
          $http({
            url: '/api/v1/crops/' + cropId,
            method: 'GET'
          }).success(function (response) {
            resolve(buildCrop(response.data, response.included));
          }).error(function (response, code) {
            reject();
            alertsService.pushToAlerts(response, code);
          });
        } else {
          resolve();
        }
      });
    }

    var createCropWithPromise = function(cropObject) {
      var url = '/api/v1/crops/';
      return $q(function (resolve, reject) {
        $http.post(url, buildParams(cropObject))
          .success(function(response) {
            resolve(buildCrop(response.data, response.included))
          })
          .error(function(response) {
            console.log(response);
            alertsService.pushToAlerts(response.errors);
            reject();
          })
      })
    }

    var updateCrop = function(cropId, cropObject, callback){
      var url = '/api/v1/crops/' + cropId + '/';
      $http.put(url, buildParams(cropObject))
        .success(function (response) {
          return callback (true, buildCrop(response.data, response.included));
        })
        .error(function (response) {
          alertsService.pushToAlerts(response.errors);
        });
    };
    return {
      'utilities': {
        'buildCrop': buildCrop,
        'buildParams': buildParams,
      },
      'getCrop': getCrop,
      'getCropWithPromise': getCropWithPromise,
      'updateCrop': updateCrop,
      'createCropWithPromise': createCropWithPromise
    };
}]);
