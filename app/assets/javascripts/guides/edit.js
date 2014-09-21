var editGuidesApp = angular.module('editGuidesApp', [
  'mm.foundation', 
  'ng-rails-csrf'
  ]);

editGuidesApp.controller('editGuideCtrl', ['$scope', '$http', 

  function guidesApp($scope, $http) {

    $scope.guide = {
      requirements : []
    };

    $scope.initGuide = function(){
      if (!$scope.guide.requirements.length){

        $http.get("/api/guide_requirement_options/")
          .success(function(response, status){
            // console.log(response.guide_requirement_options, status);
            $scope.guide.requirements = 
                response.guide_requirement_options;
          })

        // $scope.guide.requirements = [{
        //   value: 'Full Sun',
        //   type: "select",
        //   name: "Sun / Shade",
        //   options: ['Full Sun', 'Partial Sun', 'Shaded']
        // },{
        //   value: 7.5,
        //   type: "range",
        //   name: "pH",
        //   options: [0, 12, .5]
        // },{
        //   value: 20,
        //   type: "range",
        //   name: "Temperature",
        //   options: [-10, 50, 2]
        // },{
        //   value: 'Medium Loam',
        //   type: "select",
        //   name: "Soil",
        //   options: ['Medium Loam', 'Clay Loam', 'Silt', 'Silty Loam', 'Clay', 'Sandy Clay', 'Sandy Loam', 'Sand']
        // },{
        //   value: 'High Usage',
        //   type: "select",
        //   name: "Water",
        //   options: ['High Usage', 'Medium Usage', 'Low Usage']
        // },{
        //   value: 'Greenhouse',
        //   type: "select",
        //   name: "Location",
        //   options: ['Greenhouse', 'Potted', 'Outside']
        // },{
        //   value: 'Organic',
        //   type: "select",
        //   name: "Practices",
        //   options: ['Organic', 'Conventional', 'Biodynamic', 'Permaculture', 'Conventional', 'Hydroponic']
        // },{
        //   value: 'High',
        //   type: "select",
        //   name: "Time Commitment",
        //   options: ['High', 'Medium', 'Low']
        // },{
        //   value: 'High',
        //   type: "select",
        //   name: "Physical Strength",
        //   options: ['High', 'Medium', 'Low']
        // }]
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
        $scope.initGuide();
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
    };

    if (!$scope.guide.requirements){
      console.log('no requirements');

    }
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