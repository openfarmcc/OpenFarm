openFarmApp.directive('lifetimeChange', [
  function lifetimeChange(){
    return {
      restrict: 'A',
      scope: {
        timespan: '=timespan',
        calendarScale: '='
      },
      controller: ['$scope', '$element', '$attrs',
        function($scope, $element, $attrs){
          var diffX = -1;

          var calculateDifference = function(x, offset){
            // calculates the offset to maintain the difference between
            // where the user clicked and where they're dragging to.
            return x - offset;
          };

          var jumpToWeekStarts = function(position, scale){
            // Makes sure that the newPosition jumps to the relevant week.
            var weekWidth = scale.step * 7;
            return scale.convertPositionToWeek(position) * weekWidth;
          };

          var dictateLength = function(x, diffX, scale, leftOffset){
            // A function that constrains the length based on days of the year
            var newPosition = x - diffX;

            leftOffset = leftOffset || 0;

            if (newPosition >= 0 && newPosition <= scale.range - leftOffset){
              return jumpToWeekStarts(newPosition, scale);
            }
            if (newPosition < 0){
              return 0;
            }
            if (newPosition > scale.range - leftOffset){
              return scale.range - leftOffset;
            }
          };

          var lengthChangeHandler = function(e){
            var element = e.data.element;
            var scale = e.data.scale;
            var direction = e.data.direction;
            var x = e.pageX - element.parent().parent().offset().left;
            var oldLeftX = parseInt(element.parent().css('left'), 10) || 0;
            var oldRightX = parseInt(element.parent().css('width'), 10);
            var newWidth = oldRightX;

            if (diffX === -1){
              var offset = (direction === 'left' ? oldLeftX : oldRightX);
              diffX = calculateDifference(x, offset);
            }
            // Calculate new things based on direction;
            if (direction === 'left'){

              var newLeft = dictateLength(x, diffX, scale);

              element.parent().css('left', newLeft);

              // This needs to be made more functional
              $scope
                .timespan
                .set_start_event(scale.convertPositionToWeek(newLeft));

              var newLeftX = parseInt(element.parent().css('left'), 10);


              // But we also need to set the new length.
              var previousWidth = parseInt(element.parent().css('width'), 10);
              // The new width will be the previous width minus
              // the difference in length.
              newWidth = previousWidth + oldLeftX - newLeftX;

            } else {
              newWidth = dictateLength(x, diffX, scale, oldLeftX);
            }

            element.parent().css('width', newWidth);

            // this needs to be made more functional

            $scope
              .timespan
              .set_length(scale.convertPositionToWeek(newWidth));
          };

          $element.on('mousedown', function(){
            $(document).bind('mousemove.lifetime',
              {
                'direction': $attrs.lifetimeChange,
                'element': $element,
                'scale': $scope.calendarScale,
                'timespan': $scope.timespan
              },
              lengthChangeHandler);
          });


          $(document).on('mouseup', function(){
            $(document).unbind('mousemove.lifetime', lengthChangeHandler);
          });
        }]
    };
  }]);

