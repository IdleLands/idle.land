
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

      .state 'idleglobalcollectibles',
        url: '/s/collectibles'
        views:
          'content':
            template: UiRouter.template 'idlecollectibles'
            controller: 'IdleCollectibles'

      .state 'idleplayercollectibles',
        url: '/s/collectibles/:playerName'
        views:
          'content':
            template: UiRouter.template 'idlecollectibles'
            controller: 'IdleCollectibles'

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

      .state 'idleguildlist',
        url: '/s/guilds'
        views:
          'content':
            template: UiRouter.template 'idleguildlist'
            controller: 'IdleGuildList'

      .state 'idleguild',
        url: '/s/guild/:guildName'
        views:
          'content':
            template: UiRouter.template 'idleguild'
            controller: 'IdleGuild'
          'sidebar':
            template: UiRouter.template 'idleguildsidebar'
            controller: 'IdleGuildSidebar'

      .state 'idlebattlelist',
        url: '/s/battles'
        views:
          'content':
            template: UiRouter.template 'idlebattlelist'
            controller: 'IdleBattleList'

      .state 'idlebattle',
        url: '/s/battles/:battleName'
        views:
          'content':
            template: UiRouter.template 'idlebattle'
            controller: 'IdleBattle'
          'sidebar':
            template: UiRouter.template 'idlebattlesidebar'
            controller: 'IdleBattleSidebar'

      .state 'idlepets',
        url: '/s/pets'
        views:
          'content':
            template: UiRouter.template 'idlepets'
            controller: 'IdlePets'

      .state 'idleplayerpets',
        url: '/s/pets/:playerName'
        views:
          'content':
            template: UiRouter.template 'idlepets'
            controller: 'IdlePets'

      .state 'idleplayerpet',
        url: '/s/pets/:playerName/:petUid'
        views:
          'content':
            template: UiRouter.template 'idlepet'
            controller: 'IdlePet'
          'sidebar':
            template: UiRouter.template 'idlepetsidebar'
            controller: 'IdlePetSidebar'
  ]