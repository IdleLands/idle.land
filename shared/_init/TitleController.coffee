
if Meteor.isClient

  angular.module('kurea.web').service 'PageTitle', ->
    pageTitle = defaultTitle = 'Idle Lands'

    setTitle: (title) -> pageTitle = if not title then defaultTitle else title
    getTitle: -> pageTitle

  angular.module('kurea.web').controller 'Title', ['$scope', 'PageTitle', ($scope, Title) ->
    $scope.pageTitle = ''
    $scope._title = Title

    $scope.$watch '_title.getTitle()', (newTitle) ->
      $scope.pageTitle = newTitle
  ]