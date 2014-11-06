openFarmApp.controller('showGuideCtrl', ['$scope', '$http', 'guideService',
    'userService', 'gardenService',
  function showGuideCtrl($scope,
    $http,
    guideService,
    userService,
    gardenService) {
    $scope.guide_id = getIDFromURL('guides') || GUIDE_ID;
    $scope.alerts = [];

    $scope.setUser = function(success, object, code){
      if (success){
        $scope.guide.user = object;
      }
    };

    $scope.setCurrentUser = function(success, object, code){
      if (success){
        $scope.current_user = object;
      }
    };

    $scope.setGuide = function(success, object, code){
      if (success){
        $scope.guide = object;
        userService.getUser($scope.guide.user_id, $scope.alerts, $scope.setUser);
      }
    };

    $scope.addToGarden = function(garden){
      garden.adding = true;
      var callback = function(success, response){
        if (success){
          garden.adding = false;
          garden.added = true;
        }
      };
      gardenService.addGardenCropToGarden(garden,
        $scope.guide,
        $scope.alerts,
        callback);
    };

    userService.getUser(USER_ID, $scope.alerts, $scope.setCurrentUser);

    guideService.getGuide($scope.guide_id, $scope.alerts, $scope.setGuide);
  }]);