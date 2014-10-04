var showGuidesApp = angular.module('showGuidesApp', [
  'mm.foundation',
  'ngS3upload',
  'ng-rails-csrf',
  'openFarmModule'
  ]);

showGuidesApp.controller('showGuideCtrl', ['$scope', '$http', 'guideService',
  function showGuidesApp($scope, $http, guideService) {

    $scope.setGuide = function(success, object){
      if (success){
        console.log(object);
        $scope.guide = object;
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