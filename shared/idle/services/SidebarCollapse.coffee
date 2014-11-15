if Meteor.isClient
  angular.module('kurea.web').factory 'SidebarCollapse', ->
    collapse = yes

    getCollapse: -> collapse
    setCollapse: (newP) -> collapse = newP
