openFarmApp.directive("guideStageOverview", [
  function guideStageOverview() {
    return {
      restrict: "A",
      scope: {
        stage: "=",
        texts: "=",
        viewingStageOverview: "=guideStageOverview",
      },
      controller: [
        "$scope",
        function ($scope) {
          $scope.placeStageUpload = function (stage, image) {
            if (!stage.pictures) {
              stage.pictures = [];
            }
            stage.pictures.push({
              new: true,
              image_url: image,
            });
          };

          $scope.$watch("viewingStageOverview", function () {});
        },
      ],
      templateUrl: "/assets/angular-libs/guides/new/guides.new.guideStageOverview.template.html",
    };
  },
]);
