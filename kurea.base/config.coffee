
@Messages = new Meteor.Collection "Log_messages"
@Players = []

if Meteor.isServer
  Meteor.startup ->

if Meteor.isClient
  Router.configure
    layoutTemplate: 'master'

  Router.map ->
    @route "home", path: "/"
    @route "log", path: "/log"
    @route "idle", path: "/idle"
    #@route "idle.player", path: "/idle/:name", data: => @Players.findOne @params.name