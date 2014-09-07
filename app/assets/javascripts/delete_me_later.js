var s3upload = angular.module('s3upload', ['ngS3upload']);

var s3upload_controller = function ($scope) {
  $scope.bucket= "farmbot";
  $scope.q = {};
  $scope.hello = "world!";
};

s3upload.controller('s3ctrl', ['$scope', s3upload_controller]);
