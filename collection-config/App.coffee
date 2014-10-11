
if Meteor.isClient
  ngMeteor.requires.push 'ui.router'
  ngMeteor.requires.push 'mgcrea.ngStrap'
  ngMeteor.requires.push 'angularMoment'
  ngMeteor.requires.push 'highcharts-ng'

  ngMeteor.config ['$locationProvider', ($loc) ->
    $loc.html5Mode yes if window.history?.pushState
  ]