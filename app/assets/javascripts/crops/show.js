openFarmApp.controller('showCropCtrl', [
  '$scope',
  '$http',
  'cropService',
  'gardenService',
  'userService',
  '$interval',
  function showCropCtrl($scope, $http, cropService, gardenService, userService, $interval) {
    $scope.alerts = [];
    $scope.s3upload = '';
    $scope.crop = {};
    $scope.userId = USER_ID || undefined;

    $scope.setCurrentUser = function(object) {
      $scope.currentUser = object;
    };

    var queryingFunction;

    $scope.setCrop = function(success, crop) {
      userService.getUserWithPromise($scope.userId).then($scope.setCurrentUser);

      $scope.crop = crop;

      if ($scope.crop.processing_pictures > 0) {
        $scope.processingPictures = true;
        queryingFunction = $interval(function() {
          $http.get('/api/v1/progress/pictures/crop/' + crop.id).then(function(result) {
            if (result.data.processing === 0) {
              $scope.stopQuerying();
            }
          });
        }, 2000);
      }
    };

    $scope.stopQuerying = function() {
      $interval.cancel(queryingFunction);
      $scope.processingPictures = false;
      cropService.getCrop($scope.crop.id, $scope.setCrop);
    };

    cropService.getCrop(getIDFromURL('crops'), $scope.setCrop);
  },
]);
