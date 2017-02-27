(function(angular) {
  'use strict';

  angular
      .module('openFarmApp')
      .directive('ofImagesUpload', ofImagesUpload)
      .controller('ImagesUploadController', ImagesUploadController);

  function ofImagesUpload() {
    return {
      restrict: 'E',
      templateUrl: '/assets/templates/angular.of.image_upload.template.html',
      replace: true,
      scope: {
        item: '=',
        imagesKey: '=',
        itemType: '='
      },
      controller: ImagesUploadController,
      controllerAs: 'vm',
      bindToController: true
    };
  }

  ImagesUploadController.$inject = ['$scope', '$http', 'Upload'];

  function ImagesUploadController($scope, $http, Upload) {
    var vm = this;

    vm.upload = upload;
    vm.uploadFiles = uploadFiles;
    vm.deletePicture = deletePicture;

    vm.uploading = false;

    // upload on file select or drop
    function upload (file) {
      vm.uploading = true;
      var destinationUri;
      var cropReference = '';
      var fileKey;

      $http.get('/api/aws/s3_access_token')
        .then(function (token_details) {

          var extension = file.name.split('.').pop();
          fileKey = 'temp/' + token_details.data.random_uuid + '.' + extension;
          if (token_details.data.bucket) {
            destinationUri = 'https://' + token_details.data.bucket + '.s3.amazonaws.com/';
            return uploadUsingS3(file, fileKey, token_details, destinationUri);
          } else {
            destinationUri = '/api/upload_file';
            return uploadToLocalSystem(file, vm.item, vm.itemType, destinationUri);
          }
        }).then(function (resp) {
          console.log(resp);
          vm.uploading = false;
          var imageUrl;
          if (resp.data.local) {
            imageUrl = resp.data.uri;
          } else {
            imageUrl = destinationUri + fileKey;
          }

          var newImage = {
            new: true,
            image_url: imageUrl
          };

          if (vm.item[vm.imagesKey]) {
            vm.item[vm.imagesKey].push(newImage);
          } else {
            vm.item[vm.imagesKey] = [newImage];
          }
        }, function (resp) {
          vm.uploading = false;
          console.log('Error status: ' + resp.status);
        }, function (evt) {
          var progressPercentage = parseInt(100.0 * evt.loaded / evt.total);
        });
    }
    // for multiple files:
    function uploadFiles (files) {
      var numOfFiles = files.length;
      if (files && files.length) {
        for (var i = 0; i < files.length; i++) {
          upload(files[i]);
        }
      }
    }

    function deletePicture($index, pic) {
      pic.deleted = true;
    }

    function uploadToLocalSystem (file, item, itemType, destinationUri) {
      return Upload.upload({
        url: '/api/local/upload_file',
        method: 'POST',
        // fields: { 'id': item.id, 'object_type': itemType },
        file: file,
        fileFormDataName: 'object[image]'
      });
    }

    function uploadUsingS3 (file, fileKey, token_details, s3Uri) {
      return Upload.upload({
        url: s3Uri,
        method: 'POST',
        data: {
          key: fileKey, // the key to store the file on S3, could be file name or customized
          AWSAccessKeyId: token_details.data.key,
          acl: 'public-read', // sets the access to the uploaded file in the bucket: private, public-read, ...
          policy: token_details.data.policy, // base64-encoded json policy (see article below)
          signature: token_details.data.signature, // base64-encoded signature based on policy string (see article below)
          "Content-Type": file.type !== '' ? file.type : 'application/octet-stream', // content type of the file (NotEmpty)
          filename: file.name, // this is needed for Flash polyfill IE8-9
          file: file
        }
      });
    }
  }
})(angular, window.appConfig);
