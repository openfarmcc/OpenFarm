openFarmApp.controller("cropCtrl", [
  "$scope",
  "$http",
  "cropService",
  function cropCtrl($scope, $http, cropService) {
    $scope.s3upload = "";
    $scope.crop = {};

    var cropId = getIDFromURL("crops");

    $scope.iscompanionrequired = false;

    $scope.loadTags = loadTags;
    $scope.submitForm = submitForm;
    $scope.addSvg = addSvg;
    $scope.addCompanionCrop = addCompanionCrop;
    $scope.removeCompanionCrop = removeCompanionCrop;

    activate();

    function activate() {
      if (cropId !== "new" && cropId !== undefined && cropId !== "") {
        cropService.getCropWithPromise(cropId).then(function (crop) {
          $scope.crop = crop;

          // flatten companions
          $scope.crop.companions = $scope.crop.companions.map(function (companion) {
            companion.attributes.id = companion.id;
            return companion.attributes;
          });
        });
      } else {
        $scope.crop = {
          is_new: true,
          pictures: [],
        };
      }
    }

    function addSvg($svg) {
      $scope.crop.svg_icon = $svg;
    }

    function addCompanionCrop(crop) {
      if (!$scope.crop.companions) {
        $scope.crop.companions = [];
      }
      $scope.crop.companions.push(crop);
    }

    function removeCompanionCrop(idx) {
      $scope.crop.companions.splice(idx, 1);
    }

    function loadTags(query) {
      return $http.get("/api/v1/tags/" + query).then(function (tag_data) {
        return tag_data.data;
      });
    }

    function submitForm() {
      $scope.crop.sending = true;

      var commonNames = $scope.crop.common_names;
      if (typeof $scope.crop.common_names === "string") {
        commonNames = $scope.crop.common_names.split(/,+|\n+/).map(function (s) {
          return s.trim();
        });
        if (commonNames !== null) {
          commonNames = commonNames.filter(function (s) {
            return s.length > 0;
          });
        }
      }

      var tags_array = $scope.crop.tags_array.map(function (obj) {
        return obj.text;
      });

      $scope.crop.companions = $scope.crop.companions || [];

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
        svg_icon: $scope.crop.svg_icon,
        companions: $scope.crop.companions
          .map(function (crop) {
            return crop.id;
          })
          .filter(function (crop) {
            return crop;
          }),
      };

      if ($scope.crop.pictures !== undefined) {
        crop.images = $scope.crop.pictures.filter(function (d) {
          return !d.deleted;
        });
      }

      var cropCallback = function (success) {
        $scope.crop.sending = false;
        if (success) {
          window.location.href = "/crops/" + $scope.crop.id + "/";
        }
      };

      if ($scope.crop.is_new) {
        cropService.createCropWithPromise(crop).then(function (crop) {
          $scope.crop.sending = false;
          window.location.href = "/crops/" + crop.id + "/";
        });
      } else {
        cropService.updateCrop($scope.crop.id, crop, cropCallback, function (err) {
          console.log("err", err);
        });
      }
    }
  },
]);
