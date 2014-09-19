var editGuidesApp = angular.module('editGuidesApp', [
  'mm.foundation', 
  'ng-rails-csrf'
  ]);

editGuidesApp.controller('editGuideCtrl', ['$scope', '$http', 
  function guidesApp($scope, $http) {

    $scope.getGuide = function(){
      $http({
        url: '/api/guides/' + GUIDE_ID,
        method: "GET"
      }).success(function (response) {
        $scope.guide = response.guide;
        console.log($scope.guide);
      }).error(function (response, code) {
        // ToDo: make a dynamic alert.
        alert(code + ' error. Could not retrieve data from server.' + 
              ' Please try again later.');
      });  
    } 

    $scope.getGuide();

    $scope.saveGuide = function(){
      $http.put('/api/guides/' + $scope.guide._id + "/", $scope.guide)
      .success(function (response) {
        console.log("success");
      })
      .error(function (response, code) {
        // ToDo: make a dynamic alert.
        alert(code + ' error. Could not retrieve data from server.' + 
              ' Please try again later.');
      })
    }
}]);

editGuidesApp.directive('focusMe', function($timeout, $parse) {
  return {
    //scope: true,   // optionally create a child scope
    link: function(scope, element, attrs) {
      var model = $parse(attrs.focusMe);
      scope.$watch(model, function(value) {
        console.log('value=',value);
        if(value === true) { 
          $timeout(function() {
            element[0].focus(); 
          });
        }
      });
      // to address @blesh's comment, set attribute value to 'false'
      // on blur event:
      element.bind('blur', function() {
         console.log('blur');
         scope.$apply(model.assign(scope, false));
      });
    }
  };
});