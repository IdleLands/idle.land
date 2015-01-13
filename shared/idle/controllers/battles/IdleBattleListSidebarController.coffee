
if Meteor.isClient
  angular.module('kurea.web').controller 'IdleBattleListSidebar', [
    '$scope', 'BattleListFilters'
    ($scope, BattleListFilters) =>

      $scope.editing = {}

      $scope.$watch 'editing', (newVal, oldVal) ->
        return if newVal is oldVal
        BattleListFilters.setBattleFilters newVal
      , yes
  ]