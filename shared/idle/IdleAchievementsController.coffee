
if Meteor.isClient
  ngMeteor.controller 'IdleAchievements', [
    '$scope', '$stateParams', '$collection', 'IdleCollections',
    ($scope, $stateParams, $collection, IdleCollections) =>
      $scope._ = window._

      $collection IdleCollections.IdlePlayers, name: $stateParams.playerName
      .bind $scope, 'player'
  ]