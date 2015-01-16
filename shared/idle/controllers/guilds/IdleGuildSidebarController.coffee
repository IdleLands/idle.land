
if Meteor.isClient
  angular.module('kurea.web').controller 'IdleGuildSidebar', [
    '$scope', 'CurrentGuild'
    ($scope, CurrentGuild) =>

      $scope.nameToIcon = (name) ->
        switch name
          when "Strength"     then return "fa-legal fa-rotate-90"
          when "Agility"      then return "fa-bicycle"
          when "Constitution" then return "fa-heart"
          when "Dexterity"    then return "fa-crosshairs"
          when "Fortune"      then return "icon-money"
          when "Intelligence" then return "fa-mortar-board"
          when "Luck"         then return "fa-moon-o"
          when "Wisdom"       then return "fa-book"

      $scope.$watch (-> CurrentGuild.getGuild()), (newVal, oldVal) ->
        return if newVal is oldVal
        $scope.guild = newVal
  ]