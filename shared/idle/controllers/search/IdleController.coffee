

if Meteor.isClient

  angular.module('kurea.web').filter 'hasAchievement', ->
    (players, achievement) ->
      return players if not achievement
      _.filter players, (player) -> _.findWhere player.achievements, {name: achievement}

  angular.module('kurea.web').filter 'hasPersonality', ->
    (players, personality) ->
      return players if not personality
      _.filter players, (player) -> _.contains player.personalityStrings, personality

  angular.module('kurea.web').controller 'Idle', [
    '$scope', '$collection', '$subscribe', 'IdleFilterData', 'IdleCollections', 'PageTitle',
    ($scope, $collection, $subscribe, Filters, IdleCollections, PageTitle) =>

      PageTitle.setTitle "Idle Lands - Player List"

      $scope._filters = Filters
      $scope.filters = statName: 'Level', stat: 'level.__current', name: '', profession: '', map: ''

      $subscribe.subscribe 'allPlayers'
      .then ->
        $collection IdleCollections.IdlePlayers
        .bind $scope, 'players'

      $scope.filteredPlayers = ->
        return 0 if not $scope.filtered
        return 0 if $scope.filtered.length is $scope.players.length
        $scope.players.length - $scope.filtered.length

      $scope.hasAchievement = (player, achievement) ->
        return yes if not achievement or not player
        _.findWhere player.achievements, {name: achievement}

      $scope.allPlayers = ->
        $scope.players

      $scope.decompose = (player, key) ->
        try
          Math.round _.reduce (key.split "."), ((prev, cur) -> prev[cur]), player

      $scope.$watch '_filters.getFilters()', (newVal, oldVal) ->
        return if newVal is oldVal
        $scope.filters = newVal
      , yes

      $scope.$watch 'players', (newVal, oldVal) ->
        return if newVal is oldVal or newVal.length is 0
        $scope._filters.loadFiltersFromPlayers newVal

  ]
