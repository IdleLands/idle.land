
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
        url: '/s/'
      .state 'idle.urltwo',
        url: '/s/'

      .state 'idleglobalstats',
        url: '/s/stats'
        views:
          'content':
            template: UiRouter.template 'idleglobalstats'
            controller: 'IdleGlobalStats'

      .state 'idleglobalachievements',
        url: '/s/achievements'
        views:
          'content':
            template: UiRouter.template 'idleachievements'
            controller: 'IdleAchievements'

      .state 'idleplayerachievements',
        url: '/s/achievements/:playerName'
        views:
          'content':
            template: UiRouter.template 'idleachievements'
            controller: 'IdleAchievements'

      .state 'idleglobalanalytics',
        url: '/s/analytics'
        views:
          'content':
            template: UiRouter.template 'idleanalytics'
            controller: 'IdleAnalytics'
          'sidebar':
            template: UiRouter.template 'idleanalyticssidebar'
            controller: 'IdleAnalyticsFilter'

      .state 'idleplayeranalytics',
        url: '/s/analytics/:playerName'
        views:
          'content':
            template: UiRouter.template 'idleanalytics'
            controller: 'IdleAnalytics'
          'sidebar':
            template: UiRouter.template 'idleanalyticssidebar'
            controller: 'IdleAnalyticsFilter'

      .state 'idleplayerevents',
        url: '/s/events/:playerName'
        views:
          'content':
            template: UiRouter.template 'idleevents'
            controller: 'IdleEvents'

      .state 'idleglobalevents',
        url: '/s/events'
        views:
          'content':
            template: UiRouter.template 'idleevents'
            controller: 'IdleEvents'

      .state 'idleplayer',
        url: '/s/stats/:playerName'
        views:
          'content':
            template: UiRouter.template 'idleplayer'
            controller: 'IdlePlayer'
          'sidebar':
            template: UiRouter.template 'idleplayersidebar'
            controller: 'IdlePlayerSidebar'

      .state 'idlespecialthanks',
        url: '/s/thanks'
        views:
          'content':
            template: UiRouter.template 'idlespecialthanks'
            controller: 'IdleSpecialThanks'
          'sidebar':
            template: UiRouter.template 'idlespecialthankssidebar'
  ]