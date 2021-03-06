
if Meteor.isClient
  angular.module('kurea.web').controller 'IdleAchievements', [
    '$scope', '$stateParams', '$collection', '$subscribe', 'IdleCollections', 'PageTitle',
    ($scope, $stateParams, $collection, $subscribe, IdleCollections, PageTitle) =>
      $scope._ = window._
      $scope.playerName = $stateParams.playerName

      PageTitle.setTitle "Idle Lands - #{if $stateParams.playerName then "#{$stateParams.playerName} (Achievements)" else "Global Achievements"}"

      $scope.achievementTypeToIcon =
        'class': 'fa-child'
        'event': 'fa-info'
        'combat': 'fa-legal'
        'special': 'fa-gift'
        'personality': 'fa-group'
        'exploration': 'fa-compass'
        'progress': 'fa-signal'

      $scope.getAchievements = ->
        if $scope.playerName then $scope.player?[0].achievements else $scope.calculatedAchievements

      $scope.calculateAchievements = ->
        achievementFinalList = []
        calculatedAchievements = []

        _.each $scope.players, (player) -> calculatedAchievements.push player.achievements...

        groupedAchievements = _.groupBy calculatedAchievements, 'name'

        _.each (_.keys groupedAchievements), (key) ->
          achievement = groupedAchievements[key][0]
          achievement.achieved = groupedAchievements[key].length
          achievement.percent = ((parseInt achievement.achieved / $scope.players.length*100).toFixed 0)
          achievementFinalList.push achievement

        sortedAchievements = _.sortBy achievementFinalList, (achievement) -> achievement.name
        $scope.calculatedAchievements = sortedAchievements

      if $scope.playerName
        $subscribe.subscribe 'singlePlayer', $stateParams.playerName
        .then ->
          $collection IdleCollections.IdlePlayers, name: $stateParams.playerName
          .bind $scope, 'player'
      else
        $subscribe.subscribe 'achievementPlayers'
        .then ->
          $collection IdleCollections.IdlePlayers
          .bind $scope, 'players'

      $scope.$watch 'players', ->
        $scope.calculateAchievements()
  ]