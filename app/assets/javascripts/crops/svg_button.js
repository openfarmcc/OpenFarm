var MISSING_PROP =
  "You forgot to attach an `on-change=''` function to the <svg-button/> directive.";
openFarmApp
  .component('svgButton', {
    templateUrl: '/assets/templates/_svg_button.html',
    controller: ['$element', function ($element) {
      var $ctrl = this;
      var btn = $element.find("input")[0];
      btn
        .addEventListener("change", function (e) {
          var file = e.currentTarget.files[0];
          var reader = new FileReader();
          reader.onload = function (e) {
            var result = { $svg: reader.result };
            $ctrl.onChange ? $ctrl.onChange(result)
              : console.error(MISSING_PROP);
          }

          reader.readAsText(file);
        });
    }],
    bindings: {
      onChange: '&'
    }
  });
