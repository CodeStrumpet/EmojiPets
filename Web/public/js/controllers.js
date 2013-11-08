'use strict';

/* Controllers */

angular.module('myApp.controllers', []).
  
  controller('AppCtrl', function ($scope, $http, $location) {

    $scope.isActive = function (viewLocation) { 
        return viewLocation === $location.path();
    };

  }).
  controller('EmojiPetsCtrl', function ($scope) {
    // write Ctrl here

  }).
  controller('AboutCtrl', function ($scope) {
    // write Ctrl here

  });
