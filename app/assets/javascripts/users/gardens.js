// Going to start transitioning to Backbone I think
// as I learn more about it.

var Garden = Backbone.Model.extend({
  // Default Garden attribute values 
  defaults: {
    name: '',
    isPublic: false,
    image: '',
    description: '',
    gardenExtras: [],
    crops: []
  }
});
openFarmApp.controller('gardenCtrl', ['$scope', '$http', 'userService',
  function gardenCtrl($scope, $http, userService) {
    console.log('hi');
    $scope.setUser = function(success, user){
      $scope.gardens = user.gardens;
    };
    userService.getUser(USER_ID, $scope.setUser);
}]);
