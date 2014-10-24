var uploader = function() {
  return {
    restrict: 'A',
    controller: function () { alert('hi'); },
    template: 'Hello: {{ world }}'
  };
};

openFarmApp.directive('uploader', uploader);

openFarmApp.controller('fake', function($scope){
  $scope.hey = 'hi';
});

