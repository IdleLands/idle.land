
#@Messages = new Meteor.Collection "Log_messages"

global = @
if Meteor.isServer
  Meteor.startup ->

if Meteor.isClient
  Router.configure
    layoutTemplate: 'master'

  Router.map ->
    @route "home", path: "/"
    #@route "log", path: "/log"
    @route "idle", path: "/idle"
    @route "idle.player", path: "/idle/:name", data: ->
      player = IdlePlayers.findOne {name: @params.name}
      return if not player
      player.personalityString = if player.personalityStrings?.length > 0 then player.personalityStrings.join '' else "No personalities selected"
      player.equipment = _.sortBy player.equipment, (item) -> item.type
      Session.set "player", player
      player.statsArray = _.sortBy (_.keys player.statistics or []), (v) -> v
      global.globalGauge = null if global.globalGauge
      player