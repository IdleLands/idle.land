###
$("[data-toggle='offcanvas']").click(function(e) {
e.preventDefault();

//If window is small enough, enable sidebar push menu
if ($(window).width() <= 992) {
$('.row-offcanvas').toggleClass('active');
  $('.left-side').removeClass("collapse-left");
  $(".right-side").removeClass("strech");
  $('.row-offcanvas').toggleClass("relative");
} else {
//Else, enable content streching
$('.left-side').toggleClass("collapse-left");
$(".right-side").toggleClass("strech");
}
});
###

if Meteor.isClient
  angular.module('kurea.web').controller 'Nav', ['$scope', '$window', ($scope, $window) ->
    $scope.isSidebarCollapsed = no

    $scope.giveOffcanvasClasses = ->
      return yes if $window.innerWidth <= 992 and $scope.isSidebarCollapsed

    $scope.giveLeftSideClasses = ->
      return yes if $window.innerWidth <= 992 and $scope.is

    $scope.toggleCollapsed = ->
      $scope.isSidebarCollapsed = not $scope.isSidebarCollapsed




    #$scope.offcanvasClasses = ->
    #  return "active relative" if $window.innerWidth <= 992
#
    #$scope.leftSideClasses = ->
    #  return "" if $window.innerWidth <= 992
    #  return "collapse-left" if $scope.isSidebarCollapsed
#
    #$scope.rightSideClasses = ->
    #  return "" if $window.innerWidth <= 992
    #  return "stretch" if $scope.isSidebarCollapsed

  ]