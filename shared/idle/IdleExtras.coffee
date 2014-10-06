

if Meteor.isClient

  Meteor.subscribe 'allPlayers'
  Meteor.subscribe 'playerEvents'
  Meteor.subscribe 'analytics'
  Meteor.subscribe 'items'
  Meteor.subscribe 'monsters'

  ngMeteor.service 'IdleCollections', ->

    IdlePlayers = new Mongo.Collection "players"
    IdlePlayerEvents = new Mongo.Collection "playerEvents"
    IdleAnalytics = new Mongo.Collection "analytics"
    IdleMonsters = new Mongo.Collection "monsters"
    IdleItems = new Mongo.Collection "items"

    { IdlePlayers, IdlePlayerEvents, IdleAnalytics, IdleMonsters, IdleItems }

  ngMeteor.service 'IdleFilterData', ->
    filters = {}
    filterData =
      cache:
        map: {}
        profession: {}
        personality: {}
      sorted:
        map: {}
        profession: {}
        personality: {}
      stats: [
        {name: 'Level', key: 'level.__current'}
        {name: 'Luck',  key: '_baseStats.luck'}
        {name: 'STR',   key: '_baseStats.str'}
        {name: 'DEX',   key: '_baseStats.dex'}
        {name: 'AGI',   key: '_baseStats.agi'}
        {name: 'CON',   key: '_baseStats.con'}
        {name: 'INT',   key: '_baseStats.int'}
        {name: 'WIS',   key: '_baseStats.wis'}
        {name: 'HP',    key: 'hp.maximum'}
        {name: 'MP',    key: 'mp.maximum'}
        {name: 'Gold',  key: 'gold.__current'}
      ]
      classes: []
      maps: []

    loadFiltersFromPlayers: (players) ->
      filterData.cache.map = {}
      filterData.cache.profession = {}
      filterData.cache.personality = {}

      filterData.sorted.map = []
      filterData.sorted.profession = []
      filterData.sorted.personality = []

      _.each players, (player) ->
        filterData.cache.map[player.map] = 0 if not (player.map of filterData.cache.map)
        filterData.cache.profession[player.professionName] = 0 if not (player.professionName of filterData.cache.profession)

        filterData.maps.push player.map
        filterData.classes.push player.professionName

        filterData.cache.map[player.map]++
        filterData.cache.profession[player.professionName]++

        _.each player.personalityStrings, (personality) ->
          filterData.cache.personality[personality] = 0 if not (personality of filterData.cache.personality)
          filterData.cache.personality[personality]++

      filterData.sorted.map = _.sortBy (_.pairs filterData.cache.map), (mapArr) -> -mapArr[1]
      filterData.sorted.profession = _.sortBy (_.pairs filterData.cache.profession), (mapArr) -> -mapArr[1]
      filterData.sorted.personality = _.sortBy (_.pairs filterData.cache.personality), (mapArr) -> -mapArr[1]

      filterData.maps = (_.uniq filterData.maps).sort()
      filterData.classes = (_.uniq filterData.classes).sort()

    getFilters: -> filters
    setFilters: (newFilters) -> filters = newFilters
    getFilterData: -> filterData