
if Meteor.isClient
  ngMeteor.controller 'Home', ['$scope', 'PageTitle', ($scope, PageTitle) ->
    PageTitle.setTitle()
  ]