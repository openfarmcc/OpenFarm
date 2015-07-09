openFarmModule.factory('gardenService', ['$http','alertsService',
  function gardenService($http, alertsService) {

    // Should return Guide model:
    // {
    //   id: '',
    //   name: '',
    //   location: '',
    //   ...
    //   stages: [],
    //
    // }
    var buildGarden = function(data, included) {
      var garden = data.attributes;
      garden.relationships = data.relationships;
      if (included) {
        var garden_crops = included.filter(function(obj) {
          return obj.type === 'garden_crops';
        });
      }
      garden.garden_crops = garden_crops || [];
      return garden;
    }

    var buildParams = function(gardenObject) {
      var data = {
        type: 'gardens',
        id: gardenObject.id,
        attributes: gardenObject
      }
      return {'data': data}
    }

    var saveGarden = function(garden, callback){
      var url = '/api/v1/gardens/' + garden._id;
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
          alertsService.pushToAlerts(['Updated your garden!'], status)
          if (callback){
            return callback(true, response, object);
          }
        })
        .error(function (response, code){
          alertsService.pushToAlerts(response, status)
          if (callback){
            return callback(false, response, code);
          }
        });
    };

    var createGarden = function(garden, callback){
      var url = '/api/v1/gardens';
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
        .success(function (response, status) {
          alertsService.pushToAlerts(['Created Your Garden!'], status)
          if (callback){
            return callback(true,
                            buildGarden(response.data, response.included),
                            status);
          }
        })
        .error(function (response, code){
          alertsService.pushToAlerts(response, code);
          if (callback){
            return callback(false, response, code);
          }
        });
    };

    var saveGardenCrop = function(garden, gardenCrop, callback){
      // TODO: this is on pause until there's a way to
      // actually add crops and guides to a garden.
      var url = garden.relationships.garden_crops.links.related;
      $http.put(url, gardenCrop)
        .success(function (response, object) {
          alertsService.pushToAlerts(['Saved your garden crop!'], '200')
          if (callback){
            return callback(true, response, object);
          }
        })
        .error(function (response, code){
          alertsService.pushToAlerts(response, status)
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
      var url = garden.relationships.garden_crops.links.related;
      $http.post(url, data)
        .success(function(response, object){
          alertsService.pushToAlerts(['Added crop to garden!'], '200')
          if (callback){
            return callback(true, response, object);
          }
        })
        .error(function(response, code){
          alertsService.pushToAlerts(response, code)
          if (callback){
            // TODO: We need to make these consistent. What do these functions
            // return?
            return callback(false, response, code);
          }
        });
    };

    var deleteGardenCrop = function(garden, gardenCrop, callback){
      var url = '/api/v1/gardens/'+ garden._id +
                '/garden_crops/' + gardenCrop._id;
      $http.delete(url)
        .success(function(response, object){
          alertsService.pushToAlerts(['Deleted crop.'], status)
          if (callback){
            return callback(true, response, object);
          }
        })
        .error(function(response, code){
          alertsService.pushToAlerts(response, code);
          if (callback){
            return callback(false, response, code);
          }
        });
    };

    var deleteGarden = function(garden, callback){
      var url = '/api/v1/gardens/' + garden._id;
      $http.delete(url)
        .success(function(response, object){
          alertsService.pushToAlerts(['Deleted garden.'], status)
          if (callback){
            return callback(true, response, object);
          }
        })
        .error(function(response, code){
          alertsService.pushToAlerts(response, code, alerts);
          if (callback){
            return callback(false, response, code);
          }
        });
    };
    return {
      'utilities': {
        'buildGarden': buildGarden,
        'buildParams': buildParams
      },
      'saveGarden': saveGarden,
      'createGarden': createGarden,
      'deleteGarden': deleteGarden,
      'saveGardenCrop': saveGardenCrop,
      'addGardenCropToGarden': addGardenCropToGarden,
      'deleteGardenCrop': deleteGardenCrop
    };
}]);

openFarmModule.directive('addToGardens', ['$rootScope', 'gardenService',
  function($rootScope, gardenService) {
    console.log($rootScope);
    return {
      restrict: 'A',
      scope: {
        gardens: '=gardens',
        crop: '=crop',
      },
      link: function(scope, element, attr){
        scope.toggleGarden = function(garden){
          garden.adding = true;

          if (!garden.added){

            var callback = function(success){
              if (success){
                garden.adding = false;
                garden.added = true;
              }
            };
            gardenService.addGardenCropToGarden(garden,
              'crop',
              scope.crop,
              callback);
          } else {
            gardenService.deleteGardenCrop(garden,
              scope.gardenCrop,
              function(){
                garden.adding = false;
                garden.added = false;
              });
          }
        };
      },
      templateUrl: '/assets/templates/_add_to_gardens.html'
    }
  }])
