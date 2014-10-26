// Click button to select file
// Get s3 key ===========================
    // var handleKey = function(resp, stat){
    //     options.s3 = resp
    //   };
    // var fail = function(resp, stat){
    //   alert(resp.error);
    // };
    // $http
    //   .get("/api/aws/s3_access_token")
    //   .success(handleKey)
    //   .error(fail);
// upload to s3
// attach temp URL to specified scope var
(function(openFarmModule, openFarmApp){
  var options = {};

  var directiveObject = {
    restrict: 'A',
    compile: function($scope, el, attr) {
      debugger;
      // el.addEventListener("change", handleFiles, false);
      // $scope[attr.uploader] = url; // Set the URL into the scope.
    }
  }

  var directive = function ($http) {
    return directiveObject;
  }

  openFarmModule.directive('uploader', ['$http', directive]);


  openFarmApp.controller('testbed', function($scope){
    // debugger;
  });


})(openFarmModule, openFarmApp)