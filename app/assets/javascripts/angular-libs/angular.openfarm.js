var openFarmModule = angular.module('openFarmModule', ['ngSanitize']);

openFarmModule.factory('guideService', ['$http', 
  function guideService($http) {
    
    // get the guide specified.
    var getGuide = function(guide_id, callback){
      $http({
        url: '/api/guides/' + guide_id,
        method: "GET"
      }).success(function (response) {
        return callback (true, response.guide);
      }).error(function (response, code) {
        return callback(false, response, code)
      });
    };
    return {
      "getGuide": getGuide
    };
}]);

openFarmModule.factory('userService', ['$http', 
  function userService($http) {
    
    // get the guide specified.
    var getUser = function(user_id, callback){
      $http({
        url: '/api/users/' + user_id,
        method: "GET"
      }).success(function (response) {
        return callback (true, response.user);
      }).error(function (response, code) {
        return callback(false, response, code)
      });
    };
    return {
      "getUser": getUser
    };
}]);

openFarmModule.directive('markdown', ['$sanitize', 
  function markdown($sanitize) {
    var converter = new Showdown.converter();
    return {
        restrict: 'A',
        link: function (scope, element, attrs) {
            function renderMarkdown() {
                var htmlText = converter.makeHtml(scope.$eval(attrs.markdown)  || '');
                element.html($sanitize(htmlText));
            }
            scope.$watch(attrs.markdown, function(){
                renderMarkdown();
            });
            renderMarkdown();
        }
    }
}]);



