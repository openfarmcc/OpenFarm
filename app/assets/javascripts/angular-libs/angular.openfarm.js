var openFarmApp = angular.module('openFarmApp', [
  'mm.foundation',
  'ng-rails-csrf',
  'ngS3upload',
  'ngDragDrop',
  'ui.sortable',
  'LocalStorageModule',
  'openFarmModule'
]);

var openFarmModule = angular.module('openFarmModule', [
  'ngSanitize'
]);

openFarmApp.config(['localStorageServiceProvider',
  function (localStorageServiceProvider){
    localStorageServiceProvider
      .setPrefix('openFarm');
}]);

openFarmModule.factory('alertsService', ['$rootScope',
  function alertsService($rootScope) {
    $rootScope.alerts = [];
    return {
      pushToAlerts: function(response, code) {
        var msg_type = 'warning';
        if (['200','201','202'].indexOf(code) !== -1) {
          msg_type = 'success'
        }

        var msg = '';
        angular.forEach(response, function(obj){
            if (obj.title) {
              msg += obj.title;
            } else {
              msg += obj
            }
          });
        $rootScope.alerts.push({
          msg: msg,
          type: msg_type
        });
      }
    }
  }]);
