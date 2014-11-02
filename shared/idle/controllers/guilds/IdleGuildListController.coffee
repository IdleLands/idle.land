if Meteor.isClient
  angular.module('kurea.web').controller 'IdleGuildList', [
    '$scope', '$collection', '$subscribe', 'IdleCollections', 'PageTitle',
    ($scope, $collection, $subscribe, IdleCollections, PageTitle) =>
      PageTitle.setTitle "Idle Lands - Guild List"

      $subscribe.subscribe 'guilds'
      .then ->
        $collection IdleCollections.IdleGuilds
        .bind $scope, 'guilds'
  ]