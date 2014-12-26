
if Meteor.isClient
  angular.module('kurea.web').controller 'IdleCollectibles', [
    '$scope', '$stateParams', '$collection', '$subscribe', 'IdleCollections', 'PageTitle',
    ($scope, $stateParams, $collection, $subscribe, IdleCollections, PageTitle) =>
      $scope._ = window._
      $scope.playerName = $stateParams.playerName

      PageTitle.setTitle "Idle Lands - #{if $stateParams.playerName then "#{$stateParams.playerName} (Collectibles)" else "Global Collectibles"}"

      $scope.getCollectibles = ->
        if $scope.playerName then _.sortBy $scope.player?[0].collectibles, (col) -> col.name else $scope.calculatedCollectibles

      $scope.calculateCollectibles = ->
        collectibleFinalList = []
        calculatedCollectibles = []

        _.each $scope.players, (player) -> calculatedCollectibles.push player.collectibles...

        groupedCollectibles = _.groupBy calculatedCollectibles, 'name'

        _.each (_.keys groupedCollectibles), (key) ->
          collectible = groupedCollectibles[key][0]
          collectible.achieved = groupedCollectibles[key].length
          collectible.percent = ((parseInt collectible.achieved / $scope.players.length*100).toFixed 0)
          collectibleFinalList.push collectible

        sortedCollectibles = _.sortBy collectibleFinalList, (collectible) -> collectible.name
        $scope.calculatedCollectibles = sortedCollectibles

      if $scope.playerName
        $subscribe.subscribe 'singlePlayer', $stateParams.playerName
        .then ->
          $collection IdleCollections.IdlePlayers, name: $stateParams.playerName
          .bind $scope, 'player'
      else
        $subscribe.subscribe 'collectiblePlayers'
        .then ->
          $collection IdleCollections.IdlePlayers
          .bind $scope, 'players'

      $scope.$watch 'players', ->
        $scope.calculateCollectibles()
  ]