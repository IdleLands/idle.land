
if Meteor.isClient

  angular.module('kurea.web').controller 'IdleAnalytics', [
    '$scope', '$collection', '$subscribe', '$stateParams', 'IdleCollections', 'IdleFilterData', 'PageTitle',
    ($scope, $collection, $subscribe, $stateParams, IdleCollections, Filters, PageTitle) ->

      $scope._ = window._
      $scope._filters = Filters
      $scope.filters = selectedFunction: 'avg'
      $scope.data = []
      $scope.sortedPlayers = {}

      $subscribe.subscribe 'analytics'

      $scope.playerName = $stateParams.playerName

      PageTitle.setTitle "Idle Lands - #{if $stateParams.playerName then "#{$stateParams.playerName} (Analytics)" else "Global Analytics"}"

      $collection IdleCollections.IdleAnalytics
      .bind $scope, 'playerSnapshots'

      if $scope.playerName
        $subscribe.subscribe 'singlePlayerAnalytics', $stateParams.playerName
        $collection IdleCollections.IdleAnalytics, name: $stateParams.playerName
        .bind $scope, 'individualSnapshots'

      $scope.options =
        options:
          title:
            text: "Idle Lands #{if $stateParams.playerName then "Analytics - #{$stateParams.playerName}" else "Global Analytics"}"

          chart:
            type: 'line'
            zoomType: 'x'
            backgroundColor: '#f9f9f9'

          series: []

          xAxis:
            allowDecimals: no

          tooltip:
            shared: yes
            headerFormat: "<h3><strong>Level {point.key}</strong></h3><br/>"

      $scope.decompose = (player, key) ->
        try
          return Math.round _.reduce (key.split "."), ((prev, cur) -> prev[cur]), player
        0

      $scope.functions =
        sum: (arr, stat) ->
          _.reduce arr, ((prev, cur) -> prev+$scope.decompose cur, stat), 0

        max: (arr, stat) ->
          _.chain(arr)
            .map (item) -> $scope.decompose item, stat
            .max()
            .value()

        min: (arr, stat) ->
          _.chain(arr)
          .map (item) -> $scope.decompose item, stat
          .min()
          .value()

        avg: (arr, stat) ->
          Math.round (($scope.functions.sum arr, stat) / arr.length)

      $scope.setUpDataForChart = ->
        $scope.options.series = [] if not $scope.options.series
        if $scope.options.series.length isnt $scope.data.length
          $scope.options.series = $scope.data
          return

        for i in [0...$scope.data.length]
          $scope.options.series[i].data = $scope.data[i].data
          $scope.options.series[i].name = $scope.data[i].name

      $scope.organizeData = ->
        $scope.data = _.map $scope.filters.chartStats, (stat) ->

          displayType = if $scope.filters?.selectedFunction then $scope.filters.selectedFunction else stat.type

          filterType =
            if $scope.filters?.selectedFunction then $scope.filters.selectedFunction
            else if stat.type is "player" then "avg"
            else stat.type

          array = if stat.type is "player" then $scope.individualPlayer else $scope.sortedPlayers
          return {name:'', data:[]} if not $scope.individualPlayer and stat.type is "player"

          name: "#{stat.name} (#{displayType})"
          data: _.map (_.keys array), (level) ->
            val = $scope.functions[filterType] array[level], stat.key
            if _.isNaN val then 0 else val

        $scope.setUpDataForChart()

      $scope.$watch '_filters.getFilters()', (newVal) ->
        $scope.filters = newVal
        $scope.organizeData()
      , yes

      $scope.$watch 'playerSnapshots', (newVal, oldVal) ->
        return if newVal is oldVal
        $scope.sortedPlayers = _.groupBy newVal, (player) -> player.level.__current
        $scope.organizeData()

      $scope.$watch 'individualSnapshots', (newVal, oldVal) ->
        return if newVal is oldVal
        $scope.individualPlayer = _.groupBy newVal, (player) -> player.level.__current
        $scope.organizeData()
  ]