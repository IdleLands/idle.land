
if Meteor.isClient

  ngMeteor.service 'PageTitle', ->
    pageTitle = defaultTitle = 'Kurea Web Interface'

    setTitle: (title) -> pageTitle = if not title then defaultTitle else title
    getTitle: -> pageTitle

  ngMeteor.controller 'Title', ['$scope', 'PageTitle', ($scope, Title) ->
    $scope.pageTitle = ''
    $scope._title = Title

    $scope.$watch '_title.getTitle()', (newTitle) ->
      $scope.pageTitle = newTitle
  ]