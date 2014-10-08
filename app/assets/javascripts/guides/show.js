var showGuidesApp = angular.module('showGuidesApp', [
  'mm.foundation',
  'ngS3upload',
  'ng-rails-csrf',
  'openFarmModule'
  ]);

showGuidesApp.controller('showGuideCtrl', ['$scope', '$http', 'guideService',
    'userService',
  function showGuidesApp($scope, $http, guideService, userService) {

    $scope.setUser = function(success, object, code){
      console.log(object)

      if (success){
        $scope.guide.user = object;
      } else {
        $scope.alerts.push({
          msg: code + ' error. Could not retrieve data from server. ' +
            'Please try again later.',
          type: 'warning'
        });
      }
    }

    $scope.setGuide = function(success, object, code){
      if (success){
        $scope.guide = object;
        userService.getUser($scope.guide.user_id, $scope.setUser);
      } else {
        $scope.alerts.push({
          msg: object + ' error. Could not retrieve data from server. ' +
            'Please try again later.',
          type: 'warning'
        });
      }
    }

    guideService.getGuide(GUIDE_ID, $scope.setGuide);
  }]);