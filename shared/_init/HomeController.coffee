
if Meteor.isClient
  angular.module('kurea.web').controller 'Home', ['$scope', 'PageTitle', ($scope, PageTitle) ->
    PageTitle.setTitle()
  ]