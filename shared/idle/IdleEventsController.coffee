
if Meteor.isClient

  ngMeteor.controller 'IdleEvents', [
    '$scope', '$collection', '$stateParams', 'IdleCollections', 'IdleFilterData', 'PageTitle',
    ($scope, $collection, $stateParams, IdleCollections, Filters, PageTitle) ->

      $scope._ = window._
      $scope._filters = Filters
      $scope.filters = selectedFunction: 'avg'
      $scope.data = []
      $scope.sortedPlayers = {}

      $scope.playerName = $stateParams.playerName

      PageTitle.setTitle "Idle Lands - #{if $scope.playerName then "#{$scope.playerName} (Analytics)" else "Global Analytics"}"

      $collection IdleCollections.IdlePlayerEvents
      .bind $scope, 'playerEvents'

      #if $scope.playerName
      #  $collection IdleCollections.IdleAnalytics, name: $scope.playerName
      #  .bind $scope, 'individualSnapshots'

      timeInterval = 1000*60*15

      $scope.options =
        options:
          title:
            text: "Idle Lands #{if $scope.playerName then "Event Frequency - #{$scope.playerName}" else "Global Event Frequency"}"

          chart:
            type: 'line'
            zoomType: 'x'
            backgroundColor: '#f9f9f9'

          series: []

          legend:
            enabled: no

          xAxis:
            type: 'datetime'
            minRange: timeInterval
            allowDecimals: no

          yAxis:
            text: 'Event Frequency'

      $scope.setUpDataForChart = ->
        $scope.options.series = [] if not $scope.options.series
        if $scope.options.series.length isnt $scope.data.length
          $scope.options.series = $scope.data
          return

        for i in [0...$scope.data.length]
          $scope.options.series[i].data = $scope.data[i].data
          $scope.options.series[i].name = $scope.data[i].name

      $scope.organizeData = ->

        formattedData = _.map (_.keys $scope.formattedData), (key) -> [new Date(parseInt(key)*timeInterval), $scope.formattedData[key].length]

        $scope.data = [
          {type: 'area', data: formattedData, name: 'Events', pointInterval: timeInterval, pointStart: new Date().setHours(-24) }
        ]

        $scope.setUpDataForChart()

      $scope.$watch 'playerEvents', (newVal, oldVal) ->
        return if newVal is oldVal
        $scope.formattedData = _.groupBy newVal, (event) -> Math.floor +(event.createdAt) / (timeInterval)
        $scope.organizeData()

      #$scope.$watch 'individualSnapshots', (newVal, oldVal) ->
      #  return if newVal is oldVal
      #  $scope.individualPlayer = _.groupBy newVal, (player) -> player.level.__current
      #  $scope.organizeData()
  ]