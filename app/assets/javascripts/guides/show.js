openFarmApp.controller('showGuideCtrl', ['$scope', '$http', 'guideService',
    'userService', 'gardenService',
  function showGuideCtrl($scope,
                         $http,
                         guideService,
                         userService,
                         gardenService) {
    $scope.guideId = getIDFromURL('guides') || GUIDE_ID;
    $scope.userId = USER_ID || undefined;
    $scope.alerts = [];
    $scope.gardenCrop = {};

    $scope.setUser = function(success, object){
      if (success){
        $scope.guide.user = object;
      }
    };

    $scope.setCurrentUser = function(success, object){
      if (success){
        $scope.currentUser = object;

        $scope.currentUser.gardens.forEach(function(g){
          g.garden_crops.forEach(function(gc){
            if (gc.guide._id === $scope.guide._id){
              g.added = true;
              $scope.gardenCrop = gc;
            }
          });
        });

        // TODO: All of this needs to be encapsulated in something
        // Either it needs to happen through the API
        // or it needs to happen in a service.

        var locationType = '',
            averageSun = '',
            pH = '',
            soilType = '';

        $scope.currentUser.gardens.forEach(function(g){
          locationType = g.type;
          averageSun = g.average_sun;
          pH = g.ph;
          soilType = g.soil_type;
        });

        $scope.guide.basic_needs.forEach(function(b){
          if (b.value){
            b.count = 0;
            b.value.forEach(function(v){
              // This is a really simplistic way to do this
              // ideally we'd actually calculate this somewhere
              // else, and do it consistently.
              if (v === locationType ||
                  v === averageSun ||
                  v === pH ||
                  v === soilType){
                b.count += 1;
              }
            });
            if (b.value.length > 0){
              b.percent =  b.count / b.value.length;
            } else {
              b.percent = 0;
            }
            if (b.percent < 0.5){
              switch (b.name){
                case 'Sun / Shade':
                  b.tooltip = 'Low because you have ' + averageSun;
                  break;
                case 'Location':
                  b.tooltip = 'Low because your garden is ' + locationType;
                  break;
                case 'Soil Type':
                  b.tooltip = 'Low because you have ' + soilType + ' soil.';
                  break;
                case 'Practices':
                  b.tooltip = 'You don\'t follow these practices in any '+
                              'of your gardens';
                  break;
              }
            }

            if (b.percent >= 0.5 && b.percent < 0.75){
              switch (b.name){
                case 'Sun / Shade':
                  b.tooltip = 'Medium because you have ' + averageSun;
                  break;
                case 'Location':
                  b.tooltip = 'Medium because your garden is ' + locationType;
                  break;
                case 'Soil Type':
                  b.tooltip = 'Medium because you have ' + soilType + ' soil.';
                  break;
                case 'Practices':
                  b.tooltip = 'You follow some of these practices in '+
                              'your gardens';
                  break;
              }
            }

            if (b.percent >= 0.75){
              switch (b.name){
                case 'Sun / Shade':
                  b.tooltip = 'High because you have ' + averageSun;
                  break;
                case 'Location':
                  b.tooltip = 'High because your garden is ' + locationType;
                  break;
                case 'Soil Type':
                  b.tooltip = 'High because you have ' + soilType + ' soil.';
                  break;
                case 'Practices':
                  b.tooltip = 'You follow some of these practices in '+
                              'your gardens';
                  break;
              }
            }
          }
        });
        console.log($scope.guide.basic_needs);
      }
    };

    $scope.setGuide = function(success, object){
      if (success){

        if ($scope.userId){
          userService.getUser($scope.userId,
                              $scope.alerts,
                              $scope.setCurrentUser);
        }
        $scope.guide = object;
        userService.getUser($scope.guide.user_id,
                            $scope.alerts,
                            $scope.setUser);

        $scope.haveTimes = $scope.guide.stages
          .sort(function(a, b){ return a.order > b.order; })
          .filter(function(s){ return s.stage_length; });

        $scope.plantLifetime = $scope.haveTimes.reduce(function(pV, cV){
          return pV + cV.stage_length;
        }, 0);

        var light = [];
        var environment = [];
        var soil = [];
        $scope.guide.stages.forEach(function(s){
          s.light.forEach(function(l){
            if (l && light.indexOf(l) === -1){
              light.push(l);
            }
          });
          s.environment.forEach(function(e){
            if (e && environment.indexOf(e) === -1){
              environment.push(e);
            }
          });
          s.soil.forEach(function(s){
            if (s && soil.indexOf(s) === -1){
              soil.push(s);
            }
          });
        });

        // TODO: All of this needs to be encapsulated in something
        // Either it needs to happen on the API or it needs
        // to happen in a service.

        $scope.guide.basic_needs = [{
            'name': 'Sun / Shade',
            'icon': 'sun-shade',
            'value': light
          },{
            'name': 'pH Range',
            'icon': 'ph'
          },{
            'name': 'Temperature',
            'icon': 'temperature'
          },{
            'name': 'Soil Type',
            'icon': 'soil',
            'value': soil
          },{
            'name': 'Water Use',
            'icon': 'water'
          },{
            'name': 'Location',
            'icon': 'location',
            'value': environment
          },{
            'name': 'Practices',
            'icon': 'practices',
            'value': $scope.guide.practices
          },{
            'name': 'Time Commitment',
            'icon': 'time-commitment'
          },{
            'name': 'Physical Ability',
            'icon': 'physical-ability'
          },{
            'name': 'Time of Year',
            'icon': 'time-of-year'
          }
        ];
      }
    };

    $scope.toggleGarden = function(garden){
      garden.adding = true;
      if (!garden.added){
        var callback = function(success){
          if (success){
            garden.adding = false;
            garden.added = true;
          }
        };
        gardenService.addGardenCropToGarden(garden,
          $scope.guide,
          $scope.alerts,
          callback);
      } else {
        gardenService.deleteGardenCrop(garden,
          $scope.gardenCrop,
          $scope.alerts,
          function(){
            garden.adding = false;
            garden.added = false;
          });
      }

    };

    guideService.getGuide($scope.guideId, $scope.alerts, $scope.setGuide);
  }]);
