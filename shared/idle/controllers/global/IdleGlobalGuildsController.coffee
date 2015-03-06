
if Meteor.isClient

  angular.module('kurea.web').controller 'IdleGlobalGuilds', [
    '$scope', '$collection', '$subscribe', '$methods', 'IdleFilterData', 'IdleCollections', 'PageTitle',
    ($scope, $collection, $subscribe, $methods, Filters, IdleCollections, PageTitle) ->

      PageTitle.setTitle "Idle Lands - Global Guilds"

      $scope.cached = {}

      $scope._ = window._

      $subscribe.subscribe 'guilds'
      .then ->
        $collection IdleCollections.IdleGuilds
        .bind $scope, 'guilds'

      $scope._filters = Filters
      $scope.filters = {}

      $scope.getMaxOfBuilding = (stat) ->
        list = _.filter $scope.guilds, (guild) -> _.isNumber guild.buildingLevels[stat]
        sorted = (_.sortBy list, (guild) -> guild.buildingLevels[stat]).reverse()

        head: sorted[0]
        runnerups: sorted[1..3]

      $scope.remainderToString = (runnerups, building) ->
        "Notable Mentions<br><br>" +
        _.map runnerups, (guild) ->
          "#{guild.name} (#{guild.buildingLevels[building]})"
        .join '<br>'

      $scope.getPercentContribution = (key) ->
        my = $scope.getMaxOfBuilding(key).head.buildingLevels[key]
        total = $scope.totalLevels[key]
        val = (my/total*100).toFixed 3
        if _.isNaN (my/total) then 0 else val

      $scope.decompose = (player, key) ->
        try
          return _.reduce (key.split "."), ((prev, cur) -> prev[cur]), player
        0

      $scope.calcBuildingTotals = ->
        ret = {}

        _.each $scope.guilds, (guild) ->
          for building, level of guild.buildingLevels
            ret[building] = 0 unless ret[building]
            ret[building] += level if level

        ret

      $scope.$watch 'guilds', (newVal, oldVal) ->
        return if newVal is oldVal

        $scope.totalLevels = $scope.calcBuildingTotals()
  ]