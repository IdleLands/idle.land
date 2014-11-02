
if Meteor.isClient
  angular.module('kurea.web').controller 'IdleGuildSidebar', [
    '$scope', 'CurrentGuild'
    ($scope, CurrentGuild) =>

      $scope.$watch (-> CurrentGuild.getGuild()), (newVal, oldVal) ->
        return if newVal is oldVal
        $scope.guild = newVal
  ]