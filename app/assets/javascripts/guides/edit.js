var editGuidesApp = angular.module('editGuidesApp', [
  'mm.foundation', 
  'ng-rails-csrf'
  ]);

editGuidesApp.controller('editGuideCtrl', ['$scope', '$http', 

  function guidesApp($scope, $http) {

    $scope.alerts = [];

    $scope.guide = {
      requirements : []
    };

    $scope.initGuide = function(){
      if (!$scope.guide.requirements.length){

        $http.get("/api/requirement_options/")
          .success(function(response, status){
            $scope.guide.requirements = 
                response.requirement_options;
          })
      }
      if (!$scope.guide.stages.length){

        $http.get("/api/stage_options/")
          .success(function(response, status){
            $scope.guide.stages = 
                response.stage_options;
            console.log($scope.guide.stages);
          })
      }
    }

    // console.log($scope.guide);
    
    $scope.updateReq = function(req_name, value){
      console.log('changing');
      // console.log(req_name, value);
    }

    $scope.getGuide = function(){
      $http({
        url: '/api/guides/' + GUIDE_ID,
        method: "GET"
      }).success(function (response) {
        $scope.guide = response.guide;
        console.log($scope.guide);
        $scope.initGuide();
      }).error(function (response, code) {
        $scope.alerts.push({
          msg: code + ' error. Could not retrieve data from server. Please try again later.',
          type: 'warning'
        });
      });  
    } 

    $scope.getGuide();

    $scope.saveGuide = function(){
      $http.put('/api/guides/' + $scope.guide._id + "/", $scope.guide)
        .success(function (response) {
          console.log("success");
        })
        .error(function (response, code) {
          $scope.alerts.push({
            msg: code + ' error. Could not retrieve data from server. Please try again later.',
            type: 'warning'
          });
        })
    };

    if (!$scope.guide.requirements){
      console.log('no requirements');

    }
    // TODO: figure this out for the sake of code non-repeat
    $scope.closeAlert = function(index) {
      $scope.alerts.splice(index, 1);
    };
}]);

editGuidesApp.directive('focusMe', function($timeout, $parse) {
  return {
    //scope: true,   // optionally create a child scope
    link: function(scope, element, attrs) {
      var model = $parse(attrs.focusMe);
      scope.$watch(model, function(value) {
        if(value === true) { 
          $timeout(function() {
            element[0].focus(); 
          });
        }
      });
      element.bind('blur', function() {
         scope.$apply(model.assign(scope, false));
      });
    }
  };
});