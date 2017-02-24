var openFarmApp = angular.module('openFarmApp', [
  'mm.foundation',
  'ng-rails-csrf',
  'ngFileUpload',
  '720kb.socialshare',
  'ngDragDrop',
  'ui.sortable',
  'LocalStorageModule',
  'ngTagsInput',
  'ngSanitize'
]);

openFarmApp.config(['localStorageServiceProvider',
  function (localStorageServiceProvider){
    localStorageServiceProvider
      .setPrefix('openFarm');
}]);

openFarmApp.factory('alertsService', ['$rootScope',
  function alertsService($rootScope) {
    $rootScope.alerts = [];
    return {
      pushToAlerts: function(response, code) {
        var msg_type = 'warning';
        var msg = '';
        if (['200','201','202'].indexOf(code) !== -1) {
          msg_type = 'success';
        }
        if (code >= 400 && code < 500) {
          msg_type = 'alert';
        }

        console.log(response, code);
        if (response) {
          msg = response.map(function(obj){
            if (obj.title) {
              return obj.title;
            } else {
              return obj;
            }
          }).join(', ');
        } else {
          msg = ['An unknown error occurred. Please contact an administrator ',
                 'with details. hi@openfarm.cc'].join('');
        }

        $rootScope.alerts.push({
          msg: msg,
          type: msg_type
        });
      }
    };
  }]);
