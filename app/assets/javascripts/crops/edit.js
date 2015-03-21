openFarmApp.controller('editCropCtrl', ['$scope', '$http', 'cropService',
  function editCropCtrl($scope, $http, cropService) {
    $scope.alerts = [];
    $scope.s3upload = '';
    $scope.editCrop = {};
    var cropId = getIDFromURL('crops');

    var setCrop = function(success, crop){
      $scope.editCrop = crop;
    };

    cropService.getCrop(cropId, $scope.alerts, setCrop);

    $scope.submitForm = function(){
      $scope.editCrop.sending = true;

      var commonNames = $scope.editCrop.common_names;
      if (typeof $scope.editCrop.common_names === 'string'){
        commonNames = $scope.editCrop.common_names.split(/,+|\n+/)
                        .map(function(s){ return s.trim(); });
        if (commonNames !== null){
          commonNames = commonNames.filter(function(s){
            return s.length > 0;
          });
        }

      }

      var params = {
        crop: {
          common_names: commonNames,
          name: $scope.editCrop.name,
          description: $scope.editCrop.description || null,
          binomial_name: $scope.editCrop.binomial_name || null,
          sun_requirements: $scope.editCrop.sun_requirements || null,
          sowing_method: $scope.editCrop.sowing_method || null,
          spread: $scope.editCrop.spread || null,
          // days_to_maturity: $scope.editCrop.days_to_maturity || null,
          row_spacing: $scope.editCrop.row_spacing || null,
          height: $scope.editCrop.height || null,
        }
      };

      params.images = $scope.editCrop.pictures.filter(function(d){
        return !d.deleted;
      });

      var cropCallback = function(success, crop){
        $scope.editCrop.sending = false;
        $scope.editCrop = crop;
        window.location.href = '/crops/' + $scope.editCrop._id + '/';
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
      });
    };
  }]);
