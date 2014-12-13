

if Meteor.isClient

  angular.module('kurea.web').controller 'IdlePets', [
    '$scope', '$collection', '$subscribe', '$stateParams', 'IdleCollections', 'PageTitle',
    ($scope, $collection, $subscribe, $stateParams, IdleCollections, PageTitle) =>

      PageTitle.setTitle "Idle Lands - Pet List"

      $scope.playerName = $stateParams.playerName
      filter = if $scope.playerName then {'owner.name': $scope.playerName} else {}

      $subscribe.subscribe 'allPets'
      .then ->
        $collection IdleCollections.IdlePets, filter
        .bind $scope, 'pets'

  ]
