
function callFunctionOnCurrentScope(theFunction, args) {

  console.log(theFunction);

  // get Angular scope from the known DOM element
  var e = $("#angularViewContainer");
  if (e.children().length > 0) {
    scope = angular.element(e.children()[0]).scope();

    // update the model with a wrap in $apply(fn) which will refresh the view for us
    scope.$apply(function() {
      scope[theFunction](args);
    });
  }
}
