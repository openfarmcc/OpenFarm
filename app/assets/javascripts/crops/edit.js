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

      params.images = $scope.editCrop.pictures.filter(function(d){

        if (!d.deleted){ return true; }
      });

      var cropCallback = function(success, crop){
        $scope.editCrop.sending = false;
        $scope.editCrop = crop;
      };

      cropService.updateCrop($scope.editCrop._id,
                             params,
                             $scope.alerts,
                             cropCallback);
    };

    $scope.placeCropUpload = function(image){
      $scope.editCrop.pictures.push({
        new: true,
        image_url: image
      })
    }

    // $scope.$watch('s3upload', function(){
    //   if ($scope.s3upload){
    //     $scope.editCrop.pictures.push({
    //       new: true,
    //       image_url: $scope.s3upload
    //     });
    //     console.log($scope.s3upload);
    //   }
    // });
  }]);
