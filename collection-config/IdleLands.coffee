
if Meteor.isClient
  ngMeteor.config ['$stateProvider',
    ($stateProvider) ->
      $stateProvider
      .state 'idle',
        abstract: yes
        views:
          'content':
            template: UiRouter.template 'idle'
            controller: 'Idle'
          'sidebar':
            template: UiRouter.template 'idle-sidebar'
            controller: 'IdleFilter'

      .state 'idle.urlone',
        url: '/idle'
      .state 'idle.urltwo',
        url: '/idle/'

      .state 'idleglobalstats',
        url: '/idle/@'
        views:
          'content':
            template: UiRouter.template 'idleglobalstats'
            controller: 'IdleGlobalStats'

      .state 'idleplayer',
        url: '/idle/:playerName'
        views:
          'content':
            template: UiRouter.template 'idleplayer'
            controller: 'IdlePlayer'
  ]