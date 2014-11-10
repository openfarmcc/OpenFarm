openFarmApp.controller('editGuideCtrl', ['$scope', '$http', 'guideService',
  function editGuideCtrl($scope, $http, guideService) {
    // setting this to true temporarily because
    // other wise the ajax loader doesn't load
    $scope.saving = true;

    $scope.guideId = getIDFromURL('guides') || GUIDE_ID;

    $scope.alerts = [];

    $scope.guide = {
      requirements : []
    };

    $scope.initGuide = function(){

      $scope.saving = false;
      // get the missing requirements
      $http.get('/api/requirement_options/')
          .success(function(response, status){
            angular.forEach(response.requirement_options, function(optionalReq){
              var reqExists = false;
              angular.forEach($scope.guide.requirements, function(existingReq){
                if (existingReq.name === optionalReq.name){
                  reqExists = true;
                  existingReq.status = 'existing';
                  existingReq.value = optionalReq.required;
                  existingReq.options = optionalReq.options;
                  existingReq.type = optionalReq.type;
                  existingReq.active = true;
                }
              });
              if (!reqExists){
                $scope.guide.requirements.push(optionalReq);
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
      $http.get('/api/stage_options/')
        .success(function(response, status){
          angular.forEach(response.stage_options, function(optionalStage){
            var stageExists = false;
            angular.forEach($scope.guide.stages, function(existingStage){
              if (existingStage.name === optionalStage.name){
                stageExists = true;
                existingStage.order = optionalStage.order;
                existingStage.status = 'existing';
              }
            });
            if (!stageExists){
              $scope.guide.stages.push(optionalStage);
            }
          });
        })
        .error(function(response, code){
          $scope.alerts.push({
            msg: code + ' error. We had trouble fetching all stage options.',
            type: 'warning'
          });
        });
    };

    $scope.setGuide = function(success, response, code){
      if (success){
        $scope.guide = response;
        $scope.initGuide();
      }
    };

    guideService.getGuide($scope.guideId, $scope.alerts, $scope.setGuide);

    $scope.setStatus = function(item){
      if (item.status){
        item.status = 'edited';
      }
    };

    $scope.saveGuide = function(){
      $scope.saving = true;
      if ($scope.guide.featured_image === '/assets/leaf-grey.png'){
        $scope.guide.featured_image = null;
      }
      $http.put('/api/guides/' + $scope.guide._id + '/', $scope.guide)
        .success(function (response, object) {
          console.log('success', object);
          $scope.saving = false;
          $scope.alerts.push({
            msg: 'Your guide has been updated!',
            type: 'success'
          });
        })
        .error(function (response, code) {
          angular.forEach(response, function(value, key){
            $scope.saving = false;
            $scope.alerts.push({
              msg: value,
              type: 'alert'
            });
          });

          $scope.saving = false;
        });
      
      angular.forEach($scope.guide.requirements, function(item){
        var data = {};
        if (item.status === undefined){
          // in the case where the status hasn't been
          // defined yet, it's a good bet that the
          // status doesn't exist yet.

          // is it active?
          if (item.active){
            console.log('newly active', item.value);
            data = {
              'name': item.name,
              'required': item.value,
              'guide_id': $scope.guide._id
            };
            $http.post('/api/requirements/', data)
              .success(function (response){
                // TODO: indicate that save happened
                // successfully
                item.status = 'saved';
              })
              .error(function (response, code){
                item.status = 'error';
                $scope.alerts.push({
                  msg: code + ' error. Could not create Requirement.',
                  type: 'warning'
                });
              });
          }
        }
        if (item.status === 'edited'){
          if (item.active){
            data = {
              name: item.name,
              required: item.value
            };
            $http.put('/api/requirements/' + item._id + '/', data)
              .success(function (response){
                item.status = 'saved';
                // TODO: indicate that save happened
                // successfully
              })
              .error(function (response, code){
                item.status = 'error';
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
        var data = {};

        if (item.status === undefined){
          // in the case where the status hasn't been
          // defined yet, it's a good bet that the
          // stage doesn't exist yet. in this case, create it,
          // and set status to created if instructions
          // exist.
          if (item.instructions){
            data = {
              'name': item.name,
              'instructions': item.instructions,
              'guide_id': $scope.guide._id
            };
            $http.post('/api/stages/', data)
              .success(function (response){
                // TODO: indicate that save happened
                // successfully.
                item.status = 'saved';
              })
              .error(function (response, code){
                item.status = 'error';
                $scope.alerts.push({
                  msg: code + ' error. Could not create Stage.',
                  type: 'warning'
                });
              });
          }
        } else if (item.status === 'edited'){
          console.log('edited');
          data = {
            name: item.name,
            instructions: item.instructions
          };
          $http.put('/api/stages/' + item._id + '/', data)
            .success( function (response){
              item.status = 'saved';
              // TODO: indicate that save happened
              // successfully.
            })
            .error(function (response, code){
              item.status = 'error';
              $scope.alerts.push({
                msg: code + ' error. Could not update Stage.',
                type: 'warning'
              });
            });
        }
    });
    };
}]);

openFarmApp.directive('focusMe',
  ['$timeout',
   '$parse',
   function($timeout, $parse) {
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
}]);