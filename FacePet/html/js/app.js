'use strict';


// Declare app level module which depends on filters, and services
angular.module('myApp', ['myApp.filters', 'myApp.services', 'myApp.directives', 'myApp.controllers']).
  config(['$routeProvider', '$locationProvider', function($routeProvider, $locationProvider) {
    $routeProvider.
      when('/', {
        templateUrl: 'partials/home.html', 
        controller: 'HomeCtrl'
      }).
      when('/index', {
        templateUrl: 'partials/home.html', 
        controller: 'HomeCtrl'
      }).
      when('/edit/', {
        templateUrl: 'partials/edit.html',
        controller: 'EditCtrl'
      }).
      when('/edit/:docId', {
        templateUrl: 'partials/edit.html',
        controller: 'EditCtrl'
      }).
      otherwise({
        redirectTo: '/',
        resolve: {}
      });
      //$locationProvider.html5Mode(true);
  }]);
