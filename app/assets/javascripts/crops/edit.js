openFarmApp.controller('cropCtrl', ['$scope', '$http', 'cropService', 'Upload',
  function cropCtrl($scope, $http, cropService, Upload) {
    $scope.s3upload = '';
    $scope.crop = {};
    var cropId = getIDFromURL('crops');
    if (cropId !== 'new' && cropId !== undefined) {
      cropService.getCropWithPromise(cropId)
        .then(function(crop){
          $scope.crop = crop;
        });
    } else {
      $scope.crop = {
        'is_new': true,
        'pictures': []
      };
    }

    $scope.loadTags = function(query) {
      return $http.get('/api/v1/tags/' + query).then(function(tag_data){
        return tag_data.data;
      });
    };

    $scope.submitForm = function(){
      $scope.crop.sending = true;

      var commonNames = $scope.crop.common_names;
      if (typeof $scope.crop.common_names === 'string'){
        commonNames = $scope.crop.common_names.split(/,+|\n+/)
                        .map(function(s){ return s.trim(); });
        if (commonNames !== null){
          commonNames = commonNames.filter(function(s){
            return s.length > 0;
          });
        }
      }

      var tags_array = $scope.crop.tags_array.map(function(obj) {
        return obj.text;
      });

      var crop = {
        common_names: commonNames,
        name: $scope.crop.name,
        description: $scope.crop.description || null,
        binomial_name: $scope.crop.binomial_name || null,
        sun_requirements: $scope.crop.sun_requirements || null,
        growing_degree_days: $scope.crop.growing_degree_days || null,
        sowing_method: $scope.crop.sowing_method || null,
        spread: $scope.crop.spread || null,
        row_spacing: $scope.crop.row_spacing || null,
        height: $scope.crop.height || null,
        taxon: $scope.crop.taxon || null,
        tags_array: tags_array,
      };

      if ($scope.crop.pictures !== undefined){
        crop.images = $scope.crop.pictures.filter(function(d){
          return !d.deleted;
        });
      }

      var cropCallback = function(success, crop){
        $scope.crop.sending = false;
        if (success) {
          window.location.href = '/crops/' + $scope.crop.id + '/';
        }
      };

      if ($scope.crop.is_new) {
        cropService.createCropWithPromise(crop)
          .then(function(crop) {
            $scope.crop.sending = false;
            window.location.href = '/crops/' + crop.id + '/';
          });
      } else {
        cropService.updateCrop($scope.crop.id,
                               crop,
                               cropCallback, function(err) {
                                console.log('err', err);
                               });
      }
    };
  }]);
