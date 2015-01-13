if Meteor.isClient
  angular.module('kurea.web').factory 'BattleListFilters', ->
    battleFilters = {}

    getBattleFilters: -> battleFilters
    setBattleFilters: (newP) -> battleFilters = newP
