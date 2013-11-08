'use strict';

/* Controllers */

angular.module('myApp.controllers', []).
  
  controller('AppCtrl', function ($scope, $http, $location) {

    $scope.isActive = function (viewLocation) { 
        return viewLocation === $location.path();
    };

  }).
  controller('EmojiPetsCtrl', function ($scope, $timeout) {

    $scope.bearImagePath = "images/BEAR_eyes.png";
    $scope.bearWinkImagePath = "images/BEAR_wink_eyes.png";

    $scope.bearImageSrc = $scope.bearImagePath;

    $scope.bearWink = function() {
      $scope.bearImageSrc = $scope.bearWinkImagePath;

      $timeout(function() {
        $scope.$apply(function () {
          $scope.bearImageSrc = $scope.bearImagePath;                  
        });
      }, 400);
    }

  }).
  controller('AboutCtrl', function ($scope) {
    // write Ctrl here

  });
