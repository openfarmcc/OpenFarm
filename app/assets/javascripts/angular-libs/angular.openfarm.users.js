openFarmModule.factory('userService', ['$http', 'gardenService',
  function userService($http, gardenService) {
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
      var user = data.attributes;
      user.id = data.id;
      user.relationships = data.relationships;
      if(included) {
        // This can be done better.
        var user_setting = included.filter(function(obj) {
          return obj.type === 'user-settings';
        })

        var picture = included.filter(function(obj) {
          return obj.type === 'pictures';
        })

        var gardens = included.filter(function(obj) {
          return obj.type === 'gardens';
        }).map(function(garden) {
          return gardenService.utilities.buildGarden(garden);
        })

      }

      user.user_setting = buildUserSetting(user_setting[0]) || {};
      user.user_setting.picture = picture[0].attributes || {};
      user.gardens = gardens || [];

      return user;
    }

    var buildUserSetting = function(data) {
      var userSetting = data.attributes;
      return userSetting;
    }

    var getUser = function(userId, alerts, callback){
      $http({
        url: '/api/v1/users/' + userId,
        method: 'GET'
      }).success(function (response) {
        return callback (true, buildUser(response.data, response.included));
      }).error(function (response, code) {
        alerts.push({
          msg: response,
          type: 'warning'
        });
        return callback(false, response, code);
      });
    };

    var setFavoriteCrop = function(userId, cropId, alerts, callback){
      // wrapper function around put user
      var params = {
        'user': {},
        'user_setting': {
          'favorite_crop': cropId
        }
      }

      $http.put('/api/v1/users/' + userId + '/', params)
        .success(function(response) {
          return callback(true, buildUser(response.data, response.included));
        }).error(function (response, code) {
          alertsService.pushToAlerts(response, code, alerts);
          return callback(false, response, code);
        });
    }

    var updateUser = function(userId, params, alerts, callback) {
      $http.put('/api/v1/users/' + userId + '/', params)
        .success(function(response) {
          return callback(true, buildUser(response.data, response.included));
        }).error(function (response, code) {
          alertsService.pushToAlerts(response, code, alerts);
          return callback(false, response, code);
        });
    }

    return {
      'getUser': getUser,
      'updateUser': updateUser,
      'setFavoriteCrop': setFavoriteCrop
    };

}]);
