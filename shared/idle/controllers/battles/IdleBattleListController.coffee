if Meteor.isClient
  angular.module('kurea.web').controller 'IdleBattleList', [
    '$scope', '$collection', '$subscribe', 'IdleCollections', 'BattleListFilters', 'PageTitle',
    ($scope, $collection, $subscribe, IdleCollections, BattleListFilters, PageTitle) =>
      PageTitle.setTitle "Idle Lands - Battle List"

      $subscribe.subscribe 'allBattles'
      .then ->
        $collection IdleCollections.IdleBattles
        .bind $scope, 'battles'

      $scope.memberFilter = '';

      $scope.getVisibleBattles = ->
        return $scope.battles if not $scope.memberFilter

        _.filter $scope.battles, (battle) ->
          members = _.reduce battle.teams, ((prev, team) -> prev.push (_.map team.members, (member) -> member.name)...; prev), []
          (_.filter members, (member) -> -1 isnt member.indexOf $scope.memberFilter).length > 0

      $scope.countInvolvedMembers = (battle) ->
        _.reduce battle.teams, ((prev, team) -> prev + team.members.length), 0

      $scope.avgLevel = (battle) ->
        Math.round (_.reduce battle.teams, ((prev, team) ->
          prev + ((_.reduce team.members, ((prev, member) -> prev + member.level), 0) / team.members.length)
        ), 0) / battle.teams.length

      $scope.$watch (->BattleListFilters.getBattleFilters()), (newVal, oldVal) ->
        return if newVal is oldVal
        $scope.memberFilter = newVal.name
      , yes
  ]