var editGuidesApp = angular.module('editGuidesApp', [
  'mm.foundation',
  'ngS3upload',
  'ng-rails-csrf',
  'openFarmModule'
  ]);

editGuidesApp.controller('editGuideCtrl', ['$scope', '$http', 'guideService',
  function editGuidesApp($scope, $http, guideService) {

    $scope.alerts = [];

    $scope.guide = {
      requirements : []
    };

    $scope.initGuide = function(){
      // get the missing requirements
      $http.get("/api/requirement_options/")
          .success(function(response, status){
            angular.forEach(response.requirement_options, function(optional_r){
              var req_exists = false;
              angular.forEach($scope.guide.requirements, function(existing_r){
                if (existing_r.name === optional_r.name){
                  req_exists = true;
                  existing_r.status = "existing";
                  existing_r.value = existing_r.required;
                  existing_r.options = optional_r.options;
                  existing_r.type = optional_r.type;

                  existing_r.active = true;
                }
              });
              if (!req_exists){
                $scope.guide.requirements.push(optional_r);
              }
            });
          })
          .error(function(response, code){
            $scope.alerts.push({
              msg: code + ' error. We had trouble fetching all requirement options.',
              type: 'warning'
            });
          });
      // get the missing stages
      $http.get("/api/stage_options/")
        .success(function(response, status){
          angular.forEach(response.stage_options, function(optional_s){
            var stage_exists = false;
            angular.forEach($scope.guide.stages, function(existing_s){
              if (existing_s.name === optional_s.name){
                stage_exists = true;
                existing_s.order = optional_s.order;
                existing_s.status = "existing";
              }
            });
            if (!stage_exists){
              $scope.guide.stages.push(optional_s);
            }
          });
        })
        .error(function(response, code){
          $scope.alerts.push({
            msg: code + ' error. We had trouble fetching all stage options.',
            type: 'warning'
          });
        });
    }

    $scope.setGuide = function(success, response, code){
      if (success){
        $scope.guide = response;
        $scope.initGuide();
      } else {
        $scope.alerts.push({
          msg: code + ' error. Could not retrieve data from server. ' +
            'Please try again later.',
          type: 'warning'
        });
      }
    }

    guideService.getGuide(GUIDE_ID, $scope.setGuide);

    $scope.setStatus = function(item){
      if (item.status){
        item.status = 'edited';
      }
    }

    $scope.saveGuide = function(){
      $scope.saving = true;
      if ($scope.guide.featured_image === "/assets/leaf-grey.png"){
        $scope.guide.featured_image = null;
      }
      $http.put('/api/guides/' + $scope.guide._id + "/", $scope.guide)
        .success(function (response) {
          console.log("success");
          $scope.saving = false;

        })
        .error(function (response, code) {
          angular.forEach(response, function(value, key){
            console.log(key, value);
            $scope.alerts.push({
              msg: value,
              type: 'alert'
            });  
          });
          
          $scope.saving = false;
        });

      angular.forEach($scope.guide.requirements, function(item){
        if (item.status === undefined){
          // in the case where the status hasn't been
          // defined yet, it's a good bet that the
          // status doesn't exist yet.
          if (item.active){
            var data = {
              name: item.name,
              required: item.value,
              guide_id: $scope.guide._id
            }
            $http.post('/api/requirements/', data)
              .success(function (response){
                // TODO: indicate that save happened
                // successfully
              })
              .error(function (response, code){
                $scope.alerts.push({
                  msg: code + ' error. Could not create Requirement.',
                  type: 'warning'
                });
              })
          }
        }
        if (item.status === 'edited'){
          if (item.active){
            var data = {
              name: item.name,
              required: item.value
            }
            $http.put('/api/requirements/' + item._id + '/', data)
              .success(function (response){
                // TODO: indicate that save happened
                // successfully
              })
              .error(function (response, code){
                $scope.alerts.push({
                  msg: code + ' error. Could not update Requirement.',
                  type: 'warning'
                });
              });
          }
        }
        if ((item.status === 'existing' ||
             item.status === 'edited') &&
             !item.active){
          console.log('deleting', item);
          $http.delete('/api/requirements/' + item._id + '/')
            .success(function (response){
              // TODO: indicate that save happened
              // successfully
            })
            .error(function (response, code){
              $scope.alerts.push({
                msg: code + ' error. Could not update Requirement.',
                type: 'warning'
              });
            });
        }
        // TODO: else, if it's edited and not
        // active anymore, we should probably
        // remove the requirement.
      });
      angular.forEach($scope.guide.stages, function(item){
      if (item.status === undefined){
        // in the case where the status hasn't been
        // defined yet, it's a good bet that the
        // stage doesn't exist yet. in this case, create it,
        // and set status to created if instructions
        // exist.
        if (item.instructions){
          var data = {
            name: item.name,
            instructions: item.instructions,
            guide_id: $scope.guide._id
          }
          $http.post('/api/stages/', data)
            .success(function (response){
              // TODO: indicate that save happened
              // successfully.
            })
            .error(function (response, code){
              $scope.alerts.push({
                msg: code + ' error. Could not create Stage.',
                type: 'warning'
              });
            });
        }
      } else if (item.status === 'edited'){
        var data = {
          name: item.name,
          instructions: item.instructions
        }
        $http.put('/api/stages/' + item._id + '/', data)
          .success( function (response){
            // TODO: indicate that save happened
            // successfully.
          })
          .error(function (response, code){
            $scope.alerts.push({
              msg: code + ' error. Could not update Stage.',
              type: 'warning'
            });
          });
      }
    });
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