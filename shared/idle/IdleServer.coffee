
if Meteor.isServer

  driver = new MongoInternals.RemoteCollectionDriver "mongodb://localhost:27017/idlelands"
  IdlePlayers = new Mongo.Collection "players", _driver: driver
  IdleAnalytics = new Mongo.Collection "analytics", _driver: driver
  IdleGuilds = new Mongo.Collection "guilds", _driver: driver

  share.IdlePlayers = IdlePlayers
  share.IdleAnalytics = IdleAnalytics

  IdleMonsters = new Mongo.Collection "monsters", _driver: driver
  IdleItems = new Mongo.Collection "items", _driver: driver

  singlePlayerFields =
    pushbulletApiKey: 0
    password: 0
    tempSecureToken: 0

  analyticsFields =
    name: 1
    statistics: 1
    _statCache: 1
    level: 1
    hp: 1
    mp: 1
    gold: 1

  playerFields =
    _statCache: 1
    name: 1
    map: 1
    mapRegion: 1
    achievements: 1
    hp: 1
    mp: 1
    gold: 1
    level: 1
    professionName: 1
    isOnline: 1
    guild: 1
    personalityStrings: 1

  Meteor.publish 'allPlayers', ->

    yesterday = new Date
    yesterday.setDate yesterday.getDate() - 1

    IdlePlayers.find {$or: [ {lastLogin: {$gt: yesterday}}, {isOnline: yes} ]}, {sort: {'name': 1, 'level.__current': -1}, fields: playerFields}

  Meteor.publish 'singlePlayer', (playerName) ->
    IdlePlayers.find {name: playerName}, {fields: singlePlayerFields}

  Meteor.publish 'analytics', ->
    IdleAnalytics.find {}, {fields: analyticsFields}

  Meteor.publish 'singlePlayerAnalytics', (playerName) ->
    IdleAnalytics.find {name: playerName}, {fields: analyticsFields}

  Meteor.publish 'guilds', ->
    IdleGuilds.find {}

  Meteor.publish 'singleGuild', (guildName) ->
    IdleGuilds.find {name: guildName}

  Meteor.methods
    monsterCount: -> IdleMonsters.find().count()

    itemCount: ->
      ret = {}
      items = _.groupBy _.pluck IdleItems.find().fetch(), 'type'
      _.each (_.keys items), (itemType) ->
        ret[itemType] = items[itemType].length
      ret