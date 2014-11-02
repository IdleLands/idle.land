if Meteor.isClient
  angular.module('kurea.web').factory 'CurrentGuild', ->
    guild = null

    getGuild: -> guild
    setGuild: (newP) -> guild = newP