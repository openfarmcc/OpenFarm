openFarmApp.controller('showGuideCtrl', ['$scope', '$http', 'guideService',
    'userService',
  function showGuideCtrl($scope, $http, guideService, userService) {
    $scope.guide_id = getIDFromURL('guides') || GUIDE_ID;
    $scope.alerts = [];

    $scope.setUser = function(success, object, code){

      if (success){
        $scope.guide.user = object;
      } else {
        $scope.alerts.push({
          msg: code + ' error. Could not retrieve data from server. ' +
            'Please try again later.',
          type: 'warning'
        });
      }
    };

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
    };

    guideService.getGuide($scope.guide_id, $scope.setGuide);
  }]);