if Meteor.isClient
  angular.module('kurea.web').controller 'IdleBattleList', [
    '$scope', '$collection', '$subscribe', 'IdleCollections', 'PageTitle',
    ($scope, $collection, $subscribe, IdleCollections, PageTitle) =>
      PageTitle.setTitle "Idle Lands - Battle List"

      $subscribe.subscribe 'allBattles'
      .then ->
        $collection IdleCollections.IdleBattles
        .bind $scope, 'battles'

      $scope.countInvolvedMembers = (battle) ->
        _.reduce battle.teams, ((prev, team) -> prev + team.members.length), 0

      $scope.avgLevel = (battle) ->
        Math.round (_.reduce battle.teams, ((prev, team) ->
          prev + ((_.reduce team.members, ((prev, member) -> prev + member.level), 0) / team.members.length)
        ), 0) / battle.teams.length
  ]