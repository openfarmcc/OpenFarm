openFarmApp.directive('ofLightboxModal', ['$http', '$modal', 'stageService',
  function ofLightboxModal ($http, $modal, stageService) {
    return {
      restrict: 'A',
      scope: {
        thumbnailUrl: '@',
        displayUrl: '@',
        description: '@?'
      },
      controller: ['$scope',
        function ($scope) {
          $scope.open = function () {
            var modalInstance = $modal.open({
              template: '<img ng-src="{{displayUrl}}"/><span ng-bind="description"></span>',
              controller: ['$scope', '$modalInstance', 'displayUrl', 'description',
              function ($scope, $modalInstance, displayUrl, description) {
                $scope.displayUrl = displayUrl
                $scope.description = description

                $scope.reposition = function () {
                  $modalInstance.reposition()
                }

                $scope.ok = function () {
                  $modalInstance.close($scope.selected.item)
                }

                $scope.cancel = function () {
                  $modalInstance.dismiss('cancel')
                }

              }],
              resolve: {
                displayUrl: function () {
                  return $scope.displayUrl
                },
                description: function () {
                  return $scope.description
                }
              }
            })

            modalInstance.result.then(function (selectedItem) {
              $scope.selected = selectedItem
            }, function () {
              // $log.info('Modal dismissed at: ' + new Date());
            })
          }
        }
      ],
      template: "<img class='lightbox-thumbnail' ng-src='{{thumbnailUrl}}' ng-click='open()'/>"
    }
  }
])
