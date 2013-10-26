'use strict';

/* Controllers */

function HomeCtrl($scope, $location, $window, $http, DocumentService) {

  $scope.existingDocs = DocumentService.documents();

  $scope.newDoc = function() {
    console.log("new doc");
    $location.path('/edit');
  };

  $scope.editDoc = function(doc) {
    $location.path('/edit/' + doc.id);
  }


  $scope.testBridge = function() {

    console.log("testBridge");

    $http.get('http://localhost:59123/hello').
      success(function(data, status, headers, config) {
        alert("response: " + JSON.stringify(data));
      })
      .error(function(data, status) {
        alert("error: " + data);
    });
  };

  $scope.$on('$viewContentLoaded', function() {

    console.log("viewContentLoaded");

  });
}

function EditCtrl($scope, $routeParams, $location, $window, DocumentService, ConstantsService) {
  

  $scope.doc = {};

}

angular.module('myApp.controllers', [])
 
  .controller('MyCtrl2', [function() {

  }]);