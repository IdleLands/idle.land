
if Meteor.isServer
  driver = new MongoInternals.RemoteCollectionDriver "mongodb://localhost:27017/idlelands"

  IdlePlayers = new Mongo.Collection "players", _driver: driver
  IdlePlayerEvents = new Mongo.Collection "playerEvents", _driver: driver
  IdleAnalytics = new Mongo.Collection "analytics", _driver: driver
  IdleMonsters = new Mongo.Collection "monsters", _driver: driver
  IdleItems = new Mongo.Collection "items", _driver: driver

  Meteor.publish 'allPlayers', ->

    yesterday = new Date
    yesterday.setDate yesterday.getDate() - 1

    IdlePlayers.find {$or: [ {lastLogin: {$gt: yesterday}}, {isOnline: yes} ]}, {sort: {'name': 1}}

  Meteor.publish 'playerEvents', ->
    IdlePlayerEvents.find()

  Meteor.publish 'analytics', ->
    IdleAnalytics.find()

  Meteor.publish 'monsters', ->
    IdleMonsters.find()

  Meteor.publish 'items', ->
    IdleItems.find()