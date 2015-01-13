
if Meteor.isServer

  IdlePlayers = new Mongo.Collection "players"
  IdleAnalytics = new Mongo.Collection "analytics"
  IdleGuilds = new Mongo.Collection "guilds"
  IdleBattles = new Mongo.Collection "battles"
  IdlePets = new Mongo.Collection "pets"

  IdleMonsters = new Mongo.Collection "monsters"
  IdleItems = new Mongo.Collection "items"

  share.IdlePlayers = IdlePlayers
  share.IdleAnalytics = IdleAnalytics

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

  guildFields =
    name: 1
    professionName: 1
    isOnline: 1
    identifier: 1
    lastLogin: 1
    level: 1

  globalStatsFields =
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
    statistics: 1
    registrationDate: 1
    xp: 1
    equipment: 1

  collectibleFields =
    collectibles: 1

  achievementFields =
    achievements: 1

  petListFields =
    isActive: 1
    level: 1
    name: 1
    type: 1
    owner: 1
    createdAt: 1
    professionName: 1

  Meteor.publish 'allPets', (filter = {}) ->
    IdlePets.find filter, {sort: {name: 1}, fields: petListFields}

  Meteor.publish 'singlePet', (petUid) ->
    IdlePets.find {createdAt: petUid}

  Meteor.publish 'guildPlayers', (guildName) ->
    IdlePlayers.find {guild: guildName}, {fields: guildFields}

  Meteor.publish 'allPlayers', ->

    yesterday = new Date
    yesterday.setDate yesterday.getDate() - 1

    IdlePlayers.find {$or: [ {lastLogin: {$gt: yesterday}}, {isOnline: yes} ]}, {sort: {'name': 1, 'level.__current': -1}, fields: playerFields}

  Meteor.publish 'globalStatsPlayers', ->

    yesterday = new Date
    yesterday.setDate yesterday.getDate() - 1

    IdlePlayers.find {$or: [ {lastLogin: {$gt: yesterday}}, {isOnline: yes} ]}, {sort: {'name': 1, 'level.__current': -1}, fields: globalStatsFields}

  Meteor.publish 'collectiblePlayers', ->

    yesterday = new Date
    yesterday.setDate yesterday.getDate() - 1

    IdlePlayers.find {$or: [ {lastLogin: {$gt: yesterday}}, {isOnline: yes} ]}, {fields: collectibleFields}

  Meteor.publish 'achievementPlayers', ->

    yesterday = new Date
    yesterday.setDate yesterday.getDate() - 1

    IdlePlayers.find {$or: [ {lastLogin: {$gt: yesterday}}, {isOnline: yes} ]}, {fields: achievementFields}

  Meteor.publish 'allBattles', ->
    IdleBattles.find {}

  Meteor.publish 'singleBattle', (name) ->
    IdleBattles.find {name: name}

  Meteor.publish 'singlePlayer', (playerName) ->
    IdlePlayers.find {name: playerName}, {fields: singlePlayerFields}

  Meteor.publish 'analytics', ->

    twoWeeksAgo = new Date
    twoWeeksAgo.setDate twoWeeksAgo.getDate() - 14

    IdleAnalytics.find {saveTime: {$gt: twoWeeksAgo}}, {fields: analyticsFields}

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
