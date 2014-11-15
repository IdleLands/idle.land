if Meteor.isClient
  angular.module('kurea.web').factory 'CurrentBattle', ->
    battle = null

    getBattle: -> battle
    setBattle: (newP) -> battle = newP