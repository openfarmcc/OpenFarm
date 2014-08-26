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

    //Typeahead search for crops
    $scope.search = function () {
      $http({
        url: '/api/crops',
        method: "GET",
        params: {query: $scope.query}
      }).success(function(r){
        $scope.crops = r;
      })
      .error(function(r){
        alert('Could not retrieve data from server. Please try again later.');
      });
    };

    //Gets fired when user selects dropdown.
    $scope.cropSelected = function ($item, $model, $label) {
      $scope.new_guide.crop = $item;
    };

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
