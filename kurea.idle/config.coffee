
Players = @Players = new Meteor.Collection "players"
PlayerLogMessages = @PlayerLogsMessages = new Meteor.Collection "playerEvents"

Meteor.publish "players", ->
  do Players.find

Meteor.publish "playerEvents", ->
  do PlayerLogsMessages.find

if Meteor.isServer
  Meteor.startup ->