
if Meteor.isClient

  ngMeteor.controller 'IdleGlobalStats', [
    '$scope', '$collection', 'IdleFilterData', 'IdleCollections', 'PageTitle',
    ($scope, $collection, Filters, IdleCollections, PageTitle) ->

      PageTitle.setTitle "Idle Lands - Global Stats"

      $scope._ = window._
      $collection IdleCollections.IdlePlayers
      .bind $scope, 'players'

      $collection IdleCollections.IdleMonsters
      .bind $scope, 'monsters'

      $collection IdleCollections.IdleItems
      .bind $scope, 'items'

      $scope._filters = Filters
      $scope.filters = {}

      $scope.cached = {}
      $scope.topEquipment = []

      $scope.statisticsToShow = _.sortBy Filters.getFilterData().extraStats.concat [
        {name: 'Personalities', key: '__personalities'}
        {name: 'Achievements', key: '__achievements'}
      ]..., (stat) -> stat.name

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
        _.sortBy $scope.players, (player) -> -(player.xp.__current / player.xp.maximum)

      $scope.getOrderedByJoinTime = ->
        _.sortBy $scope.players, (player) -> -player.registrationDate.getTime()

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

        $scope.topEquipment = (_.sortBy $scope.topEquipment, (item) -> -item._calcScore)[0..10]

      $scope.$watch 'players', (newVal, oldVal) ->
        return if newVal.length is 0 or newVal is oldVal
        $scope._filters.loadFiltersFromPlayers newVal
        $scope.getTopEquipment()

      $scope.$watch '_filters.getFilterData()', (newVal, oldVal) ->
        return if newVal is oldVal
        $scope.filters = newVal
      , yes

      $scope.$watch 'monsters', (newVal, oldVal) ->
        return if newVal is oldVal
        $scope.cached.monsters = newVal.length

      $scope.$watch 'items', (newVal, oldVal) ->
        return if newVal is oldVal
        items = _.groupBy _.pluck newVal, 'type'
        _.each (_.keys items), (itemType) ->
          $scope.cached[itemType] = items[itemType].length
  ]