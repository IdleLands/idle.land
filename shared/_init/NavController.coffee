
if Meteor.isClient
  angular.module('kurea.web').controller 'Nav', ['$scope', 'SidebarCollapse', ($scope, SidebarCollapse) ->
    $scope.isSidebarCollapsed = yes

    $scope.toggleCollapsed = ->
      $scope.isSidebarCollapsed = not $scope.isSidebarCollapsed
      SidebarCollapse.setCollapse $scope.isSidebarCollapsed


  ]