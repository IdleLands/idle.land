
if Meteor.isClient

  ngMeteor.controller 'IdleAnalyticsFilter', ['$scope', '$alert', 'IdleFilterData', '$stateParams', ($scope, $alert, Filters, $stateParams) ->

    $scope._filterData = Filters.getFilterData()
    $scope.playerName = $stateParams.playerName
    $scope.allFilters = $scope._filterData.stats.concat $scope._filterData.extraStats...

    defaultType = if $scope.playerName then 'player' else 'avg'

    $scope.editing =
      selectedFunction: ''
      newFilter: type: 'avg', key: '_baseStats.luck'
      chartStats: [
        { name: "STR",  key: "_baseStats.str",  type: defaultType }
        { name: "INT",  key: "_baseStats.int",  type: defaultType }
        { name: "DEX",  key: "_baseStats.dex",  type: defaultType }
        { name: "CON",  key: "_baseStats.con",  type: defaultType }
        { name: "WIS",  key: "_baseStats.wis",  type: defaultType }
        { name: "AGI",  key: "_baseStats.agi",  type: defaultType }
        { name: "Luck", key: "_baseStats.luck", type: defaultType }
      ]

    $scope.clearSelection = ->
      $scope.editing.selectedFunction = ''

    $scope.toggleFilterBox = ->
      $scope.editing._showFilterBox = not $scope.editing._showFilterBox

    $scope.toggleCurrentFilterBox = ->
      $scope.editing._showCurrentFilterBox = not $scope.editing._showCurrentFilterBox

    $scope.addNewFilterAll = ->
      _.each ['avg', 'min', 'max', 'sum'], (method) ->
        $scope.editing.newFilter.type = method
        $scope.addNewFilter()

    $scope.addNewFilter = ->
      {key, type} = $scope.editing.newFilter

      $scope.editing.newFilter.type = 'player' if $scope.editing.classification is 'player'

      $scope.editing.newFilter.name = (_.findWhere $scope.allFilters, {key: key}).name

      item = _.findWhere $scope.editing.chartStats, {key: key, type: $scope.editing.newFilter.type}
      if item
        $alert
          content: "A filter \"#{$scope.editing.newFilter.name} (#{type})\" already exists."
          container: '#bad-data-alert'
          type: 'warning'
          duration: 2
        return

      $scope.editing.chartStats.push _.clone $scope.editing.newFilter

    $scope.removeFilter = (stat) ->
      $scope.editing.chartStats = _.without $scope.editing.chartStats, stat

    $scope.$watch 'editing', (newVal) ->
      Filters.setFilters newVal
    , yes
  ]