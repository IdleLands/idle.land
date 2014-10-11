

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
      extraStats: _.sortBy [
        {name: 'Damage Dealt',            key: 'statistics.calculated total damage given'}
        {name: 'Damage Taken',            key: 'statistics.calculated damage received'}
        {name: 'Healing Received',        key: 'statistics.calculated heal received'}
        {name: 'Healing Given',           key: 'statistics.calculated total heals given'}
        {name: 'Steps Taken',             key: 'statistics.explore walk'}
        {name: 'Fled From Combat',        key: 'statistics.combat self flee'}
        {name: 'Events Experienced',      key: 'statistics.event'}
        {name: 'Cataclysms Experienced',  key: 'statistics.event cataclysms'}
        {name: 'Times Fallen',            key: 'statistics.explore transfer fall'}
        {name: 'Times Ascended',          key: 'statistics.explore transfer ascend'}
        {name: 'Times Descended',         key: 'statistics.explore transfer descend'}
        {name: 'Walls Walked Into',       key: 'statistics.explore hit wall'}
        {name: 'Items Sold',              key: 'statistics.event sellItem'}
        {name: 'Monster Battles',         key: 'statistics.event monsterbattle'}
        {name: 'Items Equipped',          key: 'statistics.event findItem'}
        {name: 'Switcheroos',             key: 'statistics.event flipStat'}
        {name: 'Enchantments',            key: 'statistics.event enchant'}
        {name: 'Class Changes',           key: 'statistics.player profession change'}
        {name: 'Times Gained XP',         key: 'statistics.player xp gain'}
        {name: 'Player Kills',            key: 'statistics.combat self kill'}
        {name: 'Player Deaths',           key: 'statistics.combat self killed'}
        {name: 'Attacks Made',            key: 'statistics.combat self attack'}
        {name: 'Attacks Deflected',       key: 'statistics.combat self deflect'}
        {name: 'Attacks Dodged',          key: 'statistics.combat self dodge'}
      ], (item) -> item.name
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