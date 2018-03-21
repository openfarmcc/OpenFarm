openFarmApp.directive('ofShowAddStageToGuide', ['$q', 'defaultService', 'stageService',
  function ofShowAddStageToGuide ($q, defaultService, stageService) {
    return {
      restrict: 'A',
      scope: {
        existingStages: '=',
        guideId: '='
      },
      controller: ['$scope',
        function ($scope) {
          // Let's define everything publicly accessible up here
          $scope.stageOptions = [];
          // $scope.addStages = addStages;
          $scope.stagesSelected = false;

          // do all the setting up here

          defaultService.getStageOptions()
            .then(function (obj) {
              $scope.stageOptions = obj.filter(function (newStage) {
                if ($scope.existingStages !== undefined) {
                  var exists = false;
                  $scope.existingStages.forEach(function (existingStage) {
                    if (existingStage.name === newStage.name) {
                      exists = true;
                    }
                  });
                  return !exists;
                }
              });
            });

          // Any watching?

          $scope.$watch('stageOptions', function () {
            $scope.stagesSelected = false;
            $scope.stageOptions.forEach(function (stage) {
              if (stage.selected) {
                $scope.stagesSelected = true;
              }
            });
          }, true);

          // And definitions

          $scope.addStages = function () {
            var counter = 0;
            var promises = [];
            $scope.stageOptions.forEach(function (stage) {
              if (stage.selected) {
                var params = {'data': {
                  'attributes': {
                    'name': stage.name,
                    'order': stage.order
                  },
                  'guide_id': $scope.guideId

                }};
                counter += counter + 1;
                promises.push(stageService.createStageWithPromise(params));
              }
            });
            $q.all(promises)
              .then(function (data) {
                window.location.reload();
              }, function (error) {
                console.log('error', err);
              });

          };
        }
      ],
      templateUrl: '/assets/angular-libs/guides/show/guides.show.add-stage-to-guide.template.html'
    };
  }
]);
