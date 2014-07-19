
@Messages = new Meteor.Collection "Log_messages"

IdleMeteor = DDP.connect "http://localhost:10023"
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
    @route "log", path: "/log"
    @route "idle", path: "/idle"
    @route "idle.player", path: "/idle/:name", data: ->
      player = IdlePlayers.findOne {name:@params.name}
      return if not player
      player.personalityString = if player.personalityStrings.length > 0 then player.personalityStrings.join '' else "No personalities selected"
      player.equipment = _.sortBy player.equipment, (item) -> item.type
      player

  UI.registerHelper 'partial', (templateName, options) ->
    console.log new Spacebars.SafeString Template[templateName]
    console.log templateName
    console.log options
    console.log Template[templateName]
    new Spacebars.SafeString Template[templateName](options.hash)