
if Meteor.isClient

  angular.module('kurea.web').controller 'IdleGlobalStats', [
    '$scope', '$collection', '$subscribe', '$methods', 'IdleFilterData', 'IdleCollections', 'PageTitle',
    ($scope, $collection, $subscribe, $methods, Filters, IdleCollections, PageTitle) ->

      PageTitle.setTitle "Idle Lands - Global Stats"

      $scope.cached = {}

      $scope._ = window._
      $subscribe.subscribe 'globalStatsPlayers'
      .then ->
        $collection IdleCollections.IdlePlayers
        .bind $scope, 'players'

      $subscribe.subscribe 'guilds'
      .then ->
        $collection IdleCollections.IdleGuilds
        .bind $scope, 'guilds'

      $scope._filters = Filters
      $scope.filters = {}

      $scope.topEquipment = []

      $scope.statisticsToShow = _.sortBy (Filters.getFilterData().extraStats.concat [
        {name: 'Personalities', key: '__personalities'}
        {name: 'Achievements', key: '__achievements'}
        {name: 'Guild Taxes', key: '__guildtax'}
        {name: 'Guild Donations', key: '__guilddonations'}
        {name: 'Collectibles', key: '__collectibles'}
      ]), (stat) -> stat.name

      $scope.getMaxOfStat = (stat) ->
        list = _.filter $scope.players, (player) -> _.isNumber $scope.decompose player, stat
        sorted = (_.sortBy list, (player) -> player._stat = $scope.decompose player, stat).reverse()

        head: sorted[0]
        runnerups: sorted[1..3]
        #tail: sorted[-1]
        #tailerups: sorted[-2..-4]
        #all: sorted

      $scope.setMaxOnAllStats = ->
        _.each $scope.filters.stats, (stat) =>
          stat.max = @getMaxOfStat stat.key

      $scope.getOrderedByXpPercent = ->
        playerList = _.filter $scope.players, (player) -> player.xp.__current < player.xp.maximum
        _.sortBy playerList, (player) -> -(player.xp.__current / player.xp.maximum) or 0

      $scope.getOrderedByJoinTime = ->
        _.sortBy $scope.players, (player) -> -player.registrationDate.getTime() or 0

      $scope.remainderToString = (runnerups) ->
        "Notable Mentions<br><br>" +
        _.map runnerups, (player) ->
          "#{player.name} (#{_.str.numberFormat player._stat})"
        .join '<br>'

      $scope.getPercentContribution = (key) ->
        my = @maxFromStatistics(key).head?._stat
        total = @totalFromStatistics key
        val = (my/total*100).toFixed 3
        if _.isNaN (my/total) then 0 else val

      $scope.getStatFor = (player, key) ->
        switch key
          when "__personalities" then player.personalityStrings?.length
          when "__achievements" then player.achievements?.length
          when "__collectibles" then player.collectibles?.length
          when "__guilddonations" then _.reduce (_.values player.statistics?["calculated guild donations"] or []), ((prev, val) -> prev+val), 0
          when "__guildtax" then _.reduce (_.values player.statistics?["calculated guild taxes paid"] or []), ((prev, val) -> prev+val), 0
          else $scope.decompose player, key

      $scope.totalFromStatistics = (key) ->
        (_.reduce $scope.players, ((prev, player) => prev+((@getStatFor player, key) or 0)), 0) or 0

      $scope.maxFromStatistics = (key) ->
        sorted = (_.sortBy $scope.players, (player) => player._stat = (@getStatFor player, key) or 0).reverse()

        head: sorted[0]
        runnerups: sorted[1..3]
        #tail: sorted[-1]
        #tailerups: sorted[-2..-4]
        #all: sorted

      $scope.decompose = (player, key) ->
        try
          return _.reduce (key.split "."), ((prev, cur) -> prev[cur]), player
        0

      $scope.topEquipmentDisplayOrder = [
        'str'
        'agi'
        'dex'
        'con'
        'int'
        'wis'
        'luck'
      ]
      $scope.getTopEquipment = ->
        $scope.topEquipment = []
        _.each $scope.players, (player) ->
          _.each player.equipment, (item) -> item.owner = player.name
          $scope.topEquipment = $scope.topEquipment.concat player.equipment

        $scope.topEquipment = (_.sortBy (_.compact $scope.topEquipment), (item) -> -item?._calcScore or 0)[0..10]

      $scope.setupPieCharts = ->
        {map, profession, personality} = $scope.filters.sorted

        baseOptions =
          title:
            text: ''
          options:
            credits: no
            chart:
              type: 'pie'

        $scope.personalityChart = _.extend (_.clone baseOptions), title: {text: 'Top 10 Personalities'}, series: [{
          name: 'Using'
          data: personality[0..10]
        }]

        $scope.professionChart = _.extend (_.clone baseOptions), title: {text: 'Top 10 Classes'}, series: [{
          name: 'Representing'
          data: profession[0..10]
        }]

        $scope.mapChart = _.extend (_.clone baseOptions), title: {text: 'Top 10 Maps'}, series: [{
          name: 'On Map'
          data: map[0..10]
        }]

      $scope.$watch 'players', (newVal, oldVal) ->
        return if not newVal or newVal.length is 0 or newVal is oldVal
        $scope._filters.loadFiltersFromPlayers newVal
        $scope.getTopEquipment()

      $scope.$watch '_filters.getFilterData()', (newVal, oldVal) ->
        return if newVal is oldVal
        $scope.filters = newVal
        $scope.setupPieCharts()
      , yes
  ]