openFarmApp.controller('editCropCtrl', ['$scope', '$http', 'cropService',
  function newGuideCtrl($scope, $http, cropService) {
    $scope.alerts = [];
    $scope.s3upload = '';
    $scope.editCrop = {};
    var setCrop = function(success, crop){
      $scope.editCrop = crop;
    };
    cropService.getCrop(getIDFromURL('crops'), $scope.alerts, setCrop);
    $scope.submitForm = function(){
      $scope.editCrop.sending = true;
      var params = {
        crop: {
          name: $scope.editCrop.name,
          description: $scope.editCrop.description || null,
          binomial_name: $scope.editCrop.binomial_name || null,
          sun_requirements: $scope.editCrop.sun_requirements || null,
          sowing_method: $scope.editCrop.sowing_method || null,
          spread: $scope.editCrop.spread || null,
          days_to_maturity: $scope.editCrop.days_to_maturity || null,
          row_spacing: $scope.editCrop.row_spacing || null,
          height: $scope.editCrop.height || null,
        }
      };

      if ($scope.s3upload){
        params.images = [$scope.s3upload];
      }
      var cropCallback = function(success, crop){
        $scope.editCrop.sending = false;
        console.log('successfully updated crop', crop);
      };

      cropService.updateCrop($scope.editCrop._id,
                             params,
                             $scope.alerts,
                             cropCallback);
    };

    $scope.removeImage = function(){
    };
  }]);
