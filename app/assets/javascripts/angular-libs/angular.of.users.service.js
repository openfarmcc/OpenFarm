openFarmModule.factory('userService', ['$http', '$q', 'gardenService',
  'alertsService',
  function userService($http, $q, gardenService, alertsService) {
    // get the user specified.

    // Should return User model:
    // {
    //   id: '',
    //   pictures: '',
    //   display_name: '',
    //   ...
    //   user_setting: {},
    //   gardens: []
    // }
    var buildUser = function(data, included) {
      var user_setting,
          picture,
          gardens;
      var user = data.attributes;
      user.id = data.id;
      user.relationships = data.relationships;
      user.links = data.links;
      if(included) {
        // This can be done better.
        user_setting = included.filter(function(obj) {
          return obj.type === 'user-settings';
        })

        picture = included.filter(function(obj) {
          return obj.type === 'pictures';
        })

        gardens = included.filter(function(obj) {
          return obj.type === 'gardens';
        }).map(function(garden) {
          return gardenService.utilities.buildGarden(garden);
        })

      }
      if (user_setting && user_setting.length > 0) {
        user.user_setting = buildUserSetting(user_setting[0]);
      }
      user.gardens = gardens || [];

      return user;
    }

    var buildUserSetting = function(data) {
      var userSetting = data.attributes;
      return userSetting;
    }

    var buildPicture = function(data) {
      return data.attributes;
    }

    var getUser = function(userId, callback){
      var url = '/api/v1/users/' + userId;
      $http.get(url)
        .success(function (response) {
          return callback(true, buildUser(response.data, response.included));
        }).error(function (response, code) {
          alertsService.pushToAlerts(response, code);
          return callback(false, response, code);
        });
    };

    var getUserWithPromise = function(userId) {
      return $q(function (resolve, reject) {
        var url = '/api/v1/users/' + userId;
        $http.get(url)
          .success(function (response) {
            resolve(buildUser(response.data, response.included));
          }).error(function (response, code) {
            alertsService.pushToAlerts(response, code);
            reject(response, code);
          });
      })
    }

    var setFavoriteCrop = function(userId, cropId, callback){
      // wrapper function around put user
      var params = {
        'attributes': {},
        'user_setting': {
          'favorite_crop': cropId
        }
      }

      $http.put('/api/v1/users/' + userId + '/', { 'data': params } )
        .success(function(response) {
          return callback(true, buildUser(response.data, response.included));
        }).error(function (response, code) {
          alertsService.pushToAlerts(response, code);
          return callback(false, response, code);
        });
    }

    var updateUser = function(userId, params, callback) {
      var data = { 'data': params }
      $http.put('/api/v1/users/' + userId + '/', data)
        .success(function(response) {
          return callback(true, buildUser(response.data, response.included));
        }).error(function (response, code) {
          alertsService.pushToAlerts(response.errors, code);
          return callback(false, response, code);
        });
    }

    return {
      'utilities': {
        'buildUser': buildUser
      },
      'getUser': getUser,
      'getUserWithPromise': getUserWithPromise,
      'updateUser': updateUser,
      'setFavoriteCrop': setFavoriteCrop
    };

}]);
