openFarmModule.directive('alerts', ['$timeout',
  function alerts($timeout) {
    return {
      restrict: 'A',
      require: '?ngModel',
      scope: {
        alerts: '='
      },
      controller: ['$scope',
        function ($scope) {
          $scope.closeAlert = function(index) {
            $scope.alerts.splice(index, 1);
          };
          $scope.$watch('alerts.length', function(){
            if ($scope.alerts.length){
              $timeout(function(){
                $scope.alerts = $scope.alerts.filter(function(alert){
                  return alert.cancelTimeout;
                });
              }, 3000);
            }
          });
      }],
      template:
        '<alert ng-cloak ' +
          'class="ng-cloak columns large-6 large-centered radius float" ' +
          'ng-repeat="alert in alerts" ' +
          'type="alert.type" close="closeAlert($index)">' +
            '<div class=""> {{alert.msg}} </div>' +
            '<a ng-if="alert.action" ' +
               'ng-click="alert.actionFunction($index)"> ' +
              '{{alert.action}} ' +
            '</a>' +
        '</alert>'
    };
  }]);
