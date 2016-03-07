openFarmApp.directive('ofLightboxModal', ['$http', '$modal', 'stageService',
  function ofLightboxModal ($http, $modal, stageService) {
    return {
      restrict: 'A',
      scope: {
        picture: '=ofLightboxModal',
        description: '='
      },
      controller: ['$scope',
        function ($scope) {
          $scope.open = function () {
            var modalInstance = $modal.open({
              template: '<img ng-src="{{picture.image_url}}"/><span ng-bind="description"></span>',
              controller: ['$scope', '$modalInstance', 'picture', 'description',
              function ($scope, $modalInstance, picture, description) {
                $scope.picture = picture
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
                picture: function () {
                  return $scope.picture
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
      template: "<span class='lightbox-thumbnail' style=background-image:url({{picture.medium_url}}) ng-click='open()'></span>"
    }
  }
])
