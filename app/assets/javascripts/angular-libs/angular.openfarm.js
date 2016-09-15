var openFarmApp = angular.module('openFarmApp', [
  'mm.foundation',
  'ng-rails-csrf',
  'ngS3upload',
  'ngDragDrop',
  'ui.sortable',
  'LocalStorageModule',
  'openFarmModule',
  'ngTagsInput'
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
        if (code >= 400 && code < 500) {
          msg_type = 'alert'
        }

        console.log(response)
        var msg = response.map(function(obj){
          if (obj.title) {
            return obj.title;
          } else {
            return obj
          }
        }).join(', ');
        $rootScope.alerts.push({
          msg: msg,
          type: msg_type
        });
      }
    }
  }]);
