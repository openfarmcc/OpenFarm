var guidesApp = angular.module('guidesApp', 
  ['mm.foundation']
  );

guidesApp.controller('newGuideCtrl', 
  function guidesApp($scope, $http){
    
    $scope.crops = [];

    $scope.new_guide = {
      name : '',
      crop : undefined,
      overview : '',
      user : USER_ID
    };

    $http.get("/crops.json")
      .success(function(r){
        $scope.crops = r;
      })
      .error(function(r){
        // TODO: add a data alert
      });

    $scope.submitForm = function(){
      var crop_id;

      for(var i in $scope.crops){
        var c = $scope.crops[i];
        if (c.name === $scope.new_guide.crop){
          crop_id = c._id.$oid;
        }
      }

      var data = {};
      data.guide = $scope.new_guide;
      data.guide.crop_id = crop_id;
      data.authenticity_token = AUTH_TOKEN;

      $http.post("/guides", data)
        .success(function(r){
          console.log("success", r);
        })
        .error(function(r){
          console.log("error", r);
        });
    }
    // Add the csrftoken to the document;
    // $http.defaults.headers.common['X-CSRFToken'] = encodeURIComponent(AUTH_TOKEN);
  });
