'use strict';

// Declare app level module which depends on filters, and services

angular.module('myApp', [
  'myApp.controllers',
  'myApp.filters',
  'myApp.services',
  'myApp.directives'
]).
config(function ($routeProvider, $locationProvider) {
  $routeProvider.
    when('/emojipets', {
      templateUrl: 'partials/emojipets',
      controller: 'EmojiPetsCtrl'
    }).
    when('/about', {
      templateUrl: 'partials/about',
      controller: 'AboutCtrl'
    }).
    otherwise({
      redirectTo: '/emojipets'
    });

  $locationProvider.html5Mode(true);
});
