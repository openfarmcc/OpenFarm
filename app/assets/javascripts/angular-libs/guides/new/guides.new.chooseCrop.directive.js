openFarmApp.directive('guidesChooseCrop' ,[
  function guidesChooseCrop() {
    return {
      restrict: 'A',
      scope: {
        texts: '=',
        guide: '=',
      },
      controller: ['$scope',
        function ($scope) {
          //Gets fired when user selects dropdown.
          $scope.cropSelected = function ($item, $model) {
            $scope.guide.crop = $item;
            $scope.crop_not_found = false;
            $scope.guide.crop.description = '';
          };

          //Gets fired when user resets their selection.
          $scope.clearCropSelection = function ($item, $model) {
            $scope.guide.crop = null;
            $scope.crop_not_found = false;

            focus('cropSelectionCanceled');
          };

          $scope.createCrop = function(){
            window.location.href = '/crops/new/?source=guide&name=' +
                                   $scope.query;
          };
        }
      ],
      templateUrl: '/assets/angular-libs/guides/new/guides.new.chooseCrop.template.html'
    };
  }
]);
