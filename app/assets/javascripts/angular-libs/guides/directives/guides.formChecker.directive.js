openFarmApp.directive('formChecker', function(){
  return {
    require: '^form',
    scope: {
      stage: '=formChecker'
    },
    link: function(scope, element, attr){
      // loop through each stage
      scope.$watch('stage', function(){
        if (scope.stage.selected){
          scope.stage.edited = false;
          scope.stage.environment.forEach(function(opt){
            if (opt.selected){
              scope.stage.edited = true;
            }
          });
          scope.stage.light.forEach(function(opt){
            if (opt.selected){
              scope.stage.edited = true;
            }
          });
          scope.stage.soil.forEach(function(opt){
            if (opt.selected){
              scope.stage.edited = true;
            }
          });
        }
      }, true);
    }
  };
});
