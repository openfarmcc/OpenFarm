openFarmModule.factory('userService', ['$http',
  function userService($http) {
    // get the guide specified.
    var getUser = function(userId, alerts, callback){
      $http({
        url: '/api/users/' + userId,
        method: 'GET'
      }).success(function (response) {
        return callback (true, response.user);
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

      $http.put('/api/users/' + userId + '/', params)
        .success(function(response) {
          return callback(true, response.user);
        }).error(function (response, code) {
          alerts.push({
            msg: response,
            type: 'warning'
          });
          return callback(false, response, code);
        });
    }

    var updateUser = function(userId, params, alerts, callback) {
      $http.put('/api/users/' + userId + '/', params)
        .success(function(response) {
          return callback(true, response.user);
        }).error(function (response, code) {
          alerts.push({
            msg: response,
            type: 'warning'
          });
          return callback(false, response, code);
        });
    }

    return {
      'getUser': getUser,
      'updateUser': updateUser,
      'setFavoriteCrop': setFavoriteCrop
    };

}]);
