
if Meteor.isClient
  angular.module('kurea.web').controller 'IdleBattleSidebar', [
    '$scope', 'CurrentBattle'
    ($scope, CurrentBattle) =>

      $scope.$watch (-> CurrentBattle.getBattle()), (newVal, oldVal) ->
        return if newVal is oldVal
        $scope.battle = newVal

      $scope.countInvolvedMembers = ->
        _.reduce $scope.battle?.teams, ((prev, team) -> prev + team.members.length), 0

      $scope.avgLevel = ->
        Math.round (_.reduce $scope.battle?.teams, ((prev, team) ->
          prev + ((_.reduce team.members, ((prev, member) -> prev + member.level), 0) / team.members.length)
        ), 0) / $scope.battle?.teams.length
  ]