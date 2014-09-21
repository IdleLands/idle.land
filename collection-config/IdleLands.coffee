
if Meteor.isClient
  ngMeteor.config ['$stateProvider',
    ($stateProvider) ->
      $stateProvider
      .state 'idle',
        url: '/idle'
        views:
          'content':
            template: UiRouter.template 'idle'
            controller: 'Idle'
          'sidebar':
            template: UiRouter.template 'idle-sidebar'
            controller: 'IdleFilter'

      .state 'idleplayer',
        url: '/idle/:playerName'
        views:
          'content':
            template: UiRouter.template 'idleplayer'
            controller: 'IdlePlayer'
  ]