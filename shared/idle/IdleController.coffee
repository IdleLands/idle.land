

if Meteor.isClient

  ngMeteor.controller 'Idle', ['$scope', '$collection', 'IdleFilterData', 'IdleCollections', ($scope, $collection, Filters, IdleCollections) =>

    $scope._filters = Filters
    $scope.filters = statName: 'Level', stat: 'level.__current', name: '', profession: '', map: ''

    $collection IdleCollections.IdlePlayers, {}, sort: 'level.__current': -1
    .bind $scope, 'players'

    $scope.filteredPlayers = ->
      return 0 if not $scope.filtered
      return 0 if $scope.filtered.length is $scope.players.length
      $scope.players.length - $scope.filtered.length

    $scope.allPlayers = ->
      $scope.players

    $scope.decompose = (player, key) ->
      try
        _.reduce (key.split "."), ((prev, cur) -> prev[cur]), player

    $scope.$watch '_filters.getFilters()', (newVal, oldVal) ->
      return if newVal is oldVal
      $scope.filters = newVal
    , yes

    $scope.$watch 'players', (newVal, oldVal) ->
      return if newVal is oldVal or newVal.length is 0
      $scope._filters.loadFiltersFromPlayers newVal

  ]
