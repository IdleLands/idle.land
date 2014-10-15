
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

    IdlePlayers.find {$or: [ {lastLogin: {$gt: yesterday}}, {isOnline: yes} ]}, {sort: {'name': 1, 'level.__current': -1}}

  Meteor.publish 'playerEvents', (playerName) ->
    IdlePlayerEvents.find {player: playerName}, limit: 7, sort: {createdAt: -1}

  Meteor.publish 'singlePlayer', (playerName) ->
    IdlePlayers.find {name: playerName}

  Meteor.publish 'analytics', ->
    console.log "all"
    IdleAnalytics.find()

  Meteor.publish 'singlePlayerAnalytics', (playerName) ->
    IdleAnalytics.find {name: playerName}

  Meteor.publish 'monsters', ->
    IdleMonsters.find()

  Meteor.publish 'items', ->
    IdleItems.find()