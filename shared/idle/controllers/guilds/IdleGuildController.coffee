
if Meteor.isClient
  angular.module('kurea.web').controller 'IdleGuild', [
    '$scope', '$stateParams', '$collection', '$subscribe', 'IdleCollections', 'PageTitle', 'CurrentGuild'
    ($scope, $stateParams, $collection, $subscribe, IdleCollections, PageTitle, CurrentGuild) =>
      CurrentGuild.setGuild {}
      $scope.guild = null

      $scope.guildName = $stateParams.guildName
      PageTitle.setTitle "Idle Lands - #{$scope.guildName}"
      window.scrollTo 0,0

      $subscribe.subscribe 'singleGuild', $scope.guildName
      .then ->
        $collection IdleCollections.IdleGuilds
        .bind $scope, 'guilds'

      $subscribe.subscribe 'guildPlayers', $scope.guildName
      .then ->
        $collection IdleCollections.IdlePlayers
        .bind $scope, 'players'

      $scope.leader = []
      $scope.admins = []
      $scope.members = []

      $scope.refreshMembers = ->
        $scope.leader = _.map $scope.getLeader(), $scope.getRealPlayer
        $scope.admins = _.map $scope.getAdmins(), $scope.getRealPlayer
        $scope.members = _.map $scope.getMembers(), $scope.getRealPlayer

      $scope.getRealPlayer = (guildShell) ->
        return {} if not guildShell
        _.findWhere $scope.players, identifier: guildShell.identifier

      $scope.getLeader = ->
        return [] if not $scope.guild
        [_.findWhere $scope.guild.members, {identifier: $scope.guild.leader}]

      $scope.getAdmins = ->
        return [] if not $scope.guild
        _.filter $scope.guild.members, (member) -> member.isAdmin

      $scope.getMembers = ->
        return [] if not $scope.guild
        _.reject $scope.guild.members, (member) -> member.isAdmin

      $scope.isBuilt = (building) ->
        _.contains $scope.flatBuilt, building

      $scope.$watch 'guilds', (newVal, oldVal) ->
        return if newVal is oldVal
        $scope.guild = _.findWhere newVal, {name: $scope.guildName}
        CurrentGuild.setGuild $scope.guild

        $scope.flatBuilt = $scope.guild.currentlyBuilt.sm.concat $scope.guild.currentlyBuilt.md.concat $scope.guild.currentlyBuilt.lg

      $scope.$watch 'players', (newVal, oldVal) ->
        return if newVal is oldVal
        $scope.refreshMembers()

  ]