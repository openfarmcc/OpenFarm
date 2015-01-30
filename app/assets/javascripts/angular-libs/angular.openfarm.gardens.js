openFarmModule.factory('gardenService', ['$http',
  function gardenService($http) {
    var saveGarden = function(garden, alerts, callback){
      var url = '/api/gardens/' + garden._id;
      var data = {
        images: garden.pictures ? garden.pictures.filter(function(p){
          return !p.deleted;
        }) : [],
        garden: {
          description: garden.description || null,
          type: garden.type || null,
          location: garden.location || null,
          average_sun: garden.average_sun || null,
          ph: garden.ph || null,
          soil_type: garden.soil_type || null
        }
      };
      $http.put(url, data)
        .success(function (response, object) {
          alerts.push({
            'type': 'success',
            'msg': 'Success!'
          });
          if (callback){
            return callback(true, response, object);
          }
        })
        .error(function (response, code){
          alerts.push({
            'type': 'alert',
            'msg': response
          });
          if (callback){
            return callback(false, response, code);
          }
        });
    };

    var createGarden = function(garden, alerts, callback){
      var url = '/api/gardens';
      var data = {
        images: garden.pictures ? garden.pictures.filter(function(p){
          return !p.deleted;
        }) : [],
        name: garden.name,
        garden: {
          description: garden.description || null,
          type: garden.type || null,
          location: garden.location || null,
          average_sun: garden.average_sun || null,
          ph: garden.ph || null,
          soil_type: garden.soil_type || null
        }
      };
      $http.post(url, data)
        .success(function (object, status) {
          alerts.push({
            'type': 'success',
            'msg': 'Success!'
          });
          if (callback){
            return callback(true, object.garden, status);
          }
        })
        .error(function (response, code){
          alerts.push({
            'type': 'alert',
            'msg': response
          });
          if (callback){
            return callback(false, response, code);
          }
        });
    };

    var saveGardenCrop = function(garden, gardenCrop, alerts, callback){
      // TODO: this is on pause until there's a way to
      // actually add crops and guides to a garden.
      var url = '/api/gardens/'+ garden._id +
                '/garden_crops/' + gardenCrop._id;
      $http.put(url, gardenCrop)
        .success(function (response, object) {
          alerts.push({
            'type': 'success',
            'msg': 'Success!'
          });
          if (callback){
            return callback(true, response, object);
          }
        })
        .error(function (response, code){
          alerts.push({
            'type': 'alert',
            'msg': response
          });
          if (callback){
            return callback(false, response, code);
          }
        });
    };

    var addGardenCropToGarden = function(garden,
      adding,
      object,
      alerts,
      callback){
      var data = {};
      data[adding + '_id'] = object._id;
      $http.post('/api/gardens/' + garden._id +'/garden_crops/', data)
        .success(function(response, object){
          alerts.push({
            'type': 'success',
            'msg': 'Success!'
          });
          if (callback){
            return callback(true, response, object);
          }
        })
        .error(function(response, code){
          alerts.push({
            'type': 'alert',
            'msg': response
          });
          if (callback){
            // TODO: I need to make these consistent. What do these functions
            // return?
            return callback(false, response, code);
          }
        });
    };

    var deleteGardenCrop = function(garden, gardenCrop, alerts, callback){
      var url = '/api/gardens/'+ garden._id +
                '/garden_crops/' + gardenCrop._id;
      $http.delete(url)
        .success(function(response, object){
          alerts.push({
            'type': 'success',
            'msg': 'Deleted crop',
          });
          if (callback){
            return callback(true, response, object);
          }
        })
        .error(function(response, code){
          alerts.push({
            'type': 'alert',
            'msg': response
          });
          if (callback){
            return callback(false, response, code);
          }
        });
    };

    var deleteGarden = function(garden, alerts, callback){
      var url = '/api/gardens/' + garden._id;
      $http.delete(url)
        .success(function(response, object){
          alerts.push({
            'type': 'success',
            'msg': 'Deleted garden',
          });
          if (callback){
            return callback(true, response, object);
          }
        })
        .error(function(response, code){
          alerts.push({
            'type': 'alert',
            'msg': response
          });
          if (callback){
            return callback(false, response, code);
          }
        });
    };
    return {
      'saveGarden': saveGarden,
      'createGarden': createGarden,
      'deleteGarden': deleteGarden,
      'saveGardenCrop': saveGardenCrop,
      'addGardenCropToGarden': addGardenCropToGarden,
      'deleteGardenCrop': deleteGardenCrop
    };
}]);
