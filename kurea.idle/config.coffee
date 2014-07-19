
Players = @Players = new Meteor.Collection "players"

Meteor.publish "players", ->
  do Players.find

if Meteor.isServer
  Meteor.startup ->