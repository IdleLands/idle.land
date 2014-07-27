
#@Messages = new Meteor.Collection "Log_messages"
if process?.env.ROOT_URL.indexOf('2543') isnt -1
  IdleMeteor = DDP.connect "http://localhost:10023"
else
  IdleMeteor = DDP.connect "http://kurea.link:10023"

IdleMeteor.subscribe "players"
#TODO Fallback
IdlePlayers = @IdlePlayers = new Meteor.Collection "players", connection: IdleMeteor

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
      player = IdlePlayers.findOne {name:@params.name}
      return if not player
      player.personalityString = if player.personalityStrings?.length > 0 then player.personalityStrings.join '' else "No personalities selected"
      player.equipment = _.sortBy player.equipment, (item) -> item.type
      Session.set "player", player
      player.statsArray = _.sortBy (_.keys player.statistics or []), (v) -> v
      player