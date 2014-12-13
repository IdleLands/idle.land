if Meteor.isClient
  angular.module('kurea.web').factory 'CurrentPet', ->
    pet = null

    getPet: -> pet
    setPet: (newP) -> pet = newP
