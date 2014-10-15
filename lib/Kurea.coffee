if Meteor.isServer
  Meteor.startup ->

if Meteor.isClient

  angular.module('kurea.web').config ['$stateProvider', '$urlRouterProvider',
    ($stateProvider, $urlRouterProvider) ->

      $urlRouterProvider.otherwise '/'

      $stateProvider
      .state 'home',
        url: '/'
        views:
          'content':
            template: UiRouter.template 'home'
            controller: 'Home'
  ]