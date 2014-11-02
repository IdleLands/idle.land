if Meteor.isClient
  angular.module('kurea.web').factory 'CurrentPlayer', ->
    player = null

    getPlayer: -> player
    setPlayer: (newP) -> player = newP