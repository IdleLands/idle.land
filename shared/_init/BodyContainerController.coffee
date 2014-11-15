
if Meteor.isClient
  angular.module('kurea.web').controller 'BodyContainer', ['$scope', 'SidebarCollapse', ($scope, SidebarCollapse) ->
    $scope.isSidebarCollapsed = yes

    $scope.$watch (->SidebarCollapse.getCollapse()), (newVal, oldVal) ->
      return if newVal is oldVal
      $scope.isSidebarCollapsed = newVal
    , yes
  ]