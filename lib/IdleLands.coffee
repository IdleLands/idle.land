
if Meteor.isClient
  angular.module('kurea.web').config ['$stateProvider',
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
        url: '/idle/stats'
        views:
          'content':
            template: UiRouter.template 'idleglobalstats'
            controller: 'IdleGlobalStats'

      .state 'idleglobalachievements',
        url: '/idle/achievements'
        views:
          'content':
            template: UiRouter.template 'idleachievements'
            controller: 'IdleAchievements'

      .state 'idleplayerachievements',
        url: '/idle/achievements/:playerName'
        views:
          'content':
            template: UiRouter.template 'idleachievements'
            controller: 'IdleAchievements'

      .state 'idleglobalanalytics',
        url: '/idle/analytics'
        views:
          'content':
            template: UiRouter.template 'idleanalytics'
            controller: 'IdleAnalytics'
          'sidebar':
            template: UiRouter.template 'idleanalyticssidebar'
            controller: 'IdleAnalyticsFilter'

      .state 'idleplayeranalytics',
        url: '/idle/analytics/:playerName'
        views:
          'content':
            template: UiRouter.template 'idleanalytics'
            controller: 'IdleAnalytics'
          'sidebar':
            template: UiRouter.template 'idleanalyticssidebar'
            controller: 'IdleAnalyticsFilter'

      .state 'idleplayerevents',
        url: '/idle/events/:playerName'
        views:
          'content':
            template: UiRouter.template 'idleevents'
            controller: 'IdleEvents'

      .state 'idleglobalevents',
        url: '/idle/events'
        views:
          'content':
            template: UiRouter.template 'idleevents'
            controller: 'IdleEvents'

      .state 'idleplayer',
        url: '/idle/stats/:playerName'
        views:
          'content':
            template: UiRouter.template 'idleplayer'
            controller: 'IdlePlayer'
          'sidebar':
            template: UiRouter.template 'idleplayersidebar'
            controller: 'IdlePlayerSidebar'

      .state 'idlespecialthanks',
        url: '/idle/thanks'
        views:
          'content':
            template: UiRouter.template 'idlespecialthanks'
            controller: 'IdleSpecialThanks'
          'sidebar':
            template: UiRouter.template 'idlespecialthankssidebar'
  ]