
if Meteor.isClient

  angular.module 'kurea.web', ['ui.router', 'angular-meteor', 'mgcrea.ngStrap', 'angularMoment', 'highcharts-ng']

  Meteor.startup ->
    angular.bootstrap document, ['kurea.web']

  angular.module('kurea.web').config ['$locationProvider', ($loc) ->
    $loc.html5Mode yes if window.history?.pushState
  ]