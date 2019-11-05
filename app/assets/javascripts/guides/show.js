openFarmApp.controller('showGuideCtrl', [
  '$scope',
  '$http',
  'guideService',
  '$q',
  'userService',
  'gardenService',
  'cropService',
  'stageService',
  'defaultService',
  'alertsService',
  function showGuideCtrl(
    $scope,
    $http,
    guideService,
    $q,
    userService,
    gardenService,
    cropService,
    stageService,
    defaultService,
    alertsService
  ) {
    $scope.guideId = getIDFromURL('guides') || GUIDE_ID;
    $scope.userId = USER_ID || undefined;
    $scope.gardenCrop = {};

    $scope.favoriteGuide = favoriteGuide;
    $scope.placeGuideUpload = placeGuideUpload;

    $scope.toggleEditingGuide = function(optionalSetToValue) {
      if (optionalSetToValue === undefined) {
        $scope.editing = !$scope.editing;
      } else {
        $scope.editing = optionalSetToValue;
      }
      $scope.saved = false;
    };

    $scope.setGuideUser = function(success, object) {
      if (success) {
        $scope.guide.user = object;
      }
    };

    $scope.publish = function() {
      $scope.guide.draft = false;
      $scope.saveGuideChanges();
    };

    $scope.saveGuideChanges = function() {
      var params = {
        data: {
          attributes: {
            overview: $scope.guide.overview,
            name: $scope.guide.name,
            location: $scope.guide.location,
            draft: $scope.guide.draft,
            featured_image: 0,
            practices: $scope.practices
              .filter(function(practice) {
                return practice.selected === true;
              })
              .map(function(practice) {
                return practice.slug;
              }),
          },
          images: $scope.guide.pictures,
        },
      };

      guideService.updateGuideWithPromise($scope.guide.id, params).then(
        function(response) {
          $scope.setGuide(response);

          $scope.toggleEditingGuide(false);
        },
        function(response) {
          console.log('error updating guide', response);
        }
      );
    };

    $scope.guideUpdate = function() {
      guideService.getGuideWithPromise($scope.guideId).then($scope.setGuide);
    };

    $scope.setCurrentUser = function(success, object) {
      if (success) {
        $scope.currentUser = object;

        $scope.currentUser.gardens.forEach(function(g) {
          g.garden_crops.forEach(function(gc) {
            if (gc.guide && gc.guide._id === $scope.guide._id) {
              g.added = true;
              $scope.gardenCrop = gc;
            }
          });
        });

        if ($scope.guide.basic_needs) {
          $scope.guide.basic_needs.forEach(function(b) {
            if (b.percent < 0.5) {
              switch (b.name) {
                case 'Sun / Shade':
                  b.tooltip = 'Low compatibility with "' + b.garden + '" because it gets ' + b.user;
                  break;
                case 'Location':
                  b.tooltip = 'Low compatibility with "' + b.garden + '" because it is ' + b.user;
                  break;
                case 'Soil Type':
                  b.tooltip = 'Low compatibility with "' + b.garden + '" because it has ' + b.user + ' soil';
                  break;
                case 'Practices':
                  b.tooltip =
                    'Low compatibility with "' +
                    b.garden +
                    '" because you don\'t follow ' +
                    b.user +
                    ' practices there';
                  break;
              }
            }

            if (b.percent >= 0.5 && b.percent < 0.75) {
              switch (b.name) {
                case 'Sun / Shade':
                  b.tooltip = 'Medium compatibility with "' + b.garden + '" because it gets ' + b.user;
                  break;
                case 'Location':
                  b.tooltip = 'Medium compatibility with "' + b.garden + '" because it is ' + b.user;
                  break;
                case 'Soil Type':
                  b.tooltip = 'Medium compatibility with "' + b.garden + '" because it has ' + b.user + ' soil';
                  break;
                case 'Practices':
                  b.tooltip =
                    'Medium compatibility with "' +
                    b.garden +
                    '" because you follow ' +
                    b.user +
                    ' and other practices there';
                  break;
              }
            }

            if (b.percent >= 0.75) {
              switch (b.name) {
                case 'Sun / Shade':
                  b.tooltip = 'High compatibility with "' + b.garden + '" because it gets ' + b.user;
                  break;
                case 'Location':
                  b.tooltip = 'High compatibility with "' + b.garden + '" because it is ' + b.user;
                  break;
                case 'Soil Type':
                  b.tooltip = 'High compatibility with "' + b.garden + '" because it has ' + b.user + ' soil';
                  break;
                case 'Practices':
                  b.tooltip =
                    'High compatibility with "' + b.garden + '" because you follow only ' + b.user + ' practices there';
                  break;
              }
            }
          });
        }

        $scope.inFavorites = false;
        $scope.currentUser.favorited_guides.forEach(function(g) {
          if (g.id === $scope.guide.id) {
            $scope.inFavorites = true;
          }
        });
      }
    };

    $scope.setGuide = function(object) {
      $scope.guide = object;

      if ($scope.userId) {
        userService.getUser($scope.userId, $scope.setCurrentUser);
      }

      if ($scope.guide.user !== undefined) {
        userService.getUser($scope.guide.user.id, $scope.setGuideUser);
      }

      setPractices($scope.guide.practices);

      $scope.$watch('guide.stages', function() {
        if ($scope.guide.stages !== undefined) {
          // This is a hack because stages get built from the
          // API. This is kind of flawed still at the moment,
          // and probably a suitable place to do the next refactor.
          // All of these services can probably be "promise-fied"
          // Basically what's happening here is we're making sure that
          // guides.stages isn't just made up from yet-to-be-loaded stages
          // $scope.isNotUndefined = $scope.guide.stages.filter(function(s) {
          //   return undefined !== s
          // }).length === $scope.guide.stages.length;
          // $scope.haveTimes = $scope.guide.stages
          //   .sort(function(a, b){ return a.order > b.order; })
          //   .filter(function(s){ return s.stage_length; });
          // $scope.plantLifetime = $scope.haveTimes.reduce(function(pV, cV){
          //   return pV + cV.stage_length;
          // }, 0);
        }
      });
    };

    $scope.practicesList = function() {
      if ($scope.practices) {
        return $scope.practices
          .filter(function(p) {
            return p.selected;
          })
          .map(function(p) {
            return p.slug;
          })
          .join(', ');
      }
    };

    function setPractices(guidePractices) {
      $q.all([
        defaultService.processedDetailOptions(),
        cropService.getCropWithPromise($scope.guide.relationships.crop.data.id),
      ]).then(function(data) {
        $scope.options = data[0];
        $scope.practices = data[0].multiSelectPractices;
        $scope.practices.forEach(function(practice) {
          if ($scope.guide.practices !== null && guidePractices.indexOf(practice.slug.toLowerCase()) > -1) {
            practice.selected = true;
          }
        });

        $scope.guide.crop = data[1];
      });
    }

    function favoriteGuide(guideId) {
      if (!$scope.currentUser) {
        alertsService.pushToAlerts(['You need to log in to mark your favorite'], 401);
      } else {
        $scope.updatingFavoritedGuides = true;
        var favorited_guide_ids =
          $scope.currentUser.favorited_guides.map(function(g) {
            return g.id;
          }) || [];
        var index = favorited_guide_ids.indexOf(guideId);
        if (index === -1) {
          favorited_guide_ids.push(guideId);
        } else {
          favorited_guide_ids.splice(index, 1);
        }

        var params = {
          favorited_guide_ids: favorited_guide_ids,
        };

        if ($scope.currentUser.user_setting.picture && !$scope.currentUser.user_setting.picture.deleted) {
          params.featured_image = $scope.currentUser.user_setting.picture.image_url || null;
        } else {
          params.featured_image = null;
        }

        userService
          .updateUserWithPromise($scope.currentUser.id, params)
          .then(function(user) {
            $scope.updatingFavoritedGuides = false;
            $scope.setCurrentUser(true, user);
          })
          .catch(function(response, code) {});
      }
    }

    function placeGuideUpload(image) {
      $scope.guide.featured_image = { image_url: image };
    }

    guideService.getGuideWithPromise($scope.guideId).then($scope.setGuide);
  },
]);
