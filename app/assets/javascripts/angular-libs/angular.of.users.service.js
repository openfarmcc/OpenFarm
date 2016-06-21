openFarmModule.factory('userService', ['$http', '$q', 'gardenService',
  'alertsService',
  function userService($http, $q, gardenService, alertsService) {
    // get the user specified.

    return {
      'utilities': {
        'buildUser': buildUser
      },
      'getUser': getUser,
      'getUserWithPromise': getUserWithPromise,
      'updateUser': updateUser,
      'updateUserWithPromise': updateUserWithPromise,
      'setFavoriteCrop': setFavoriteCrop
    };

    // Should return User model:
    // {
    //   id: '',
    //   pictures: '',
    //   display_name: '',
    //   ...
    //   user_setting: {},
    //   gardens: []
    // }

    function checkIfIsObj (includedObj) {
      if (includedObj.id === this.objId) {
        // if (includedObj.type === 'user-setting' || includedObj.type === 'user_setting') {
        // }
        if (includedObj.type === 'garden') {
          this.arr.push(gardenService.buildGarden(includedObj));
        } else {
          this.arr.push(includedObj);
        }
      }
    }

    function checkEachRelationshipAndPush (obj) {
      var passedThis = {
        arr: this.arr,
        objId: obj.id
      };

      this.included.forEach(checkIfIsObj, passedThis);
    }

    function buildUser (data, included) {
      var user_setting,
          picture,
          gardens;
      var user = data.attributes;
      user.id = data.id;
      user.relationships = data.relationships;
      user.links = data.links;
      if(included) {
        // Can this be abstracted into a factory that other
        // services can use? TODO
        for (var key in data.relationships) {
          if (data.relationships.hasOwnProperty(key)) {
            user[key] = [];

            var passedThis = {
              arr: user[key],
              included: included
            };

            if (data.relationships[key].data &&
                data.relationships[key].data.length) {
              data.relationships[key].data.forEach(checkEachRelationshipAndPush, passedThis);
            } else if (data.relationships[key].data !== undefined) {
              included.forEach(checkIfIsObj, {
                arr: user[key],
                objId: data.relationships[key].data.id
              });
            }
          }
        }

      }
      if (user.user_setting && user.user_setting.length > 0) {
        user.user_setting = buildUserSetting(user.user_setting[0]);
      }
      user.gardens = gardens || [];

      return user;
    }

    function buildUserSetting (data) {
      var userSetting = data.attributes;
      return userSetting;
    }

    function getUser (userId, callback){
      var url = '/api/v1/users/' + userId;
      $http.get(url)
        .success(function (response) {
          return callback(true, buildUser(response.data, response.included));
        }).error(function (response, code) {
          alertsService.pushToAlerts(response, code);
          return callback(false, response, code);
        });
    }

    function getUserWithPromise (userId) {
      return $q(function (resolve, reject) {
        if (userId) {
          var url = '/api/v1/users/' + userId;
          $http.get(url)
            .success(function (response) {
              resolve(buildUser(response.data, response.included));
            }).error(function (response, code) {
              alertsService.pushToAlerts(response, code);
              reject(response, code);
            });
        } else {
          reject();
        }
      });
    }

    function setFavoriteCrop (userId, cropId, callback){
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

    function updateUser (userId, params, callback) {
      var data = { 'data': params };
      $http.put('/api/v1/users/' + userId + '/', data)
        .success(function(response) {
          return callback(true, buildUser(response.data, response.included));
        }).error(function (response, code) {
          alertsService.pushToAlerts(response.errors, code);
          return callback(false, response, code);
        });
    }

    function updateUserWithPromise (userId, params, callback) {
      var data = { 'data': params };
      return $q(function (resolve, reject) {
        $http.put('/api/v1/users/' + userId + '/', data)
          .success(function(response) {
            resolve(buildUser(response.data, response.included));
          }).error(function (response, code) {
            alertsService.pushToAlerts(response.errors, code);
            reject(response, code);
          });
        });
    }
}]);
