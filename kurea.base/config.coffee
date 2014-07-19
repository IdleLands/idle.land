
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
    @route "idle.player", path: "/idle/:name", data: -> IdlePlayers.findOne {name:@params.name}