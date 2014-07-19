
@Messages = new Meteor.Collection "Log_messages"


if Meteor.isServer
  Meteor.startup ->

if Meteor.isClient
  Router.configure
    layoutTemplate: 'master'

  Router.map ->
    @route "home", path: "/"
    @route "log", path: "/log"
    @route "idle", path: "/idle"