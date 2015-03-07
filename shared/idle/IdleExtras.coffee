
if Meteor.isClient

  angular.module('kurea.web').service 'IdleCollections', ->

    IdlePlayers = new Mongo.Collection "players"
    IdleAnalytics = new Mongo.Collection "analytics"
    IdleGuilds = new Mongo.Collection "guilds"
    IdleBattles = new Mongo.Collection "battles"
    IdlePets = new Mongo.Collection "pets"

    { IdlePlayers, IdleAnalytics, IdleGuilds, IdleBattles, IdlePets }

  angular.module('kurea.web').service 'IdleFilterData', ->
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
        {name: 'Luck',  key: '_statCache.luck'}
        {name: 'STR',   key: '_statCache.str'}
        {name: 'DEX',   key: '_statCache.dex'}
        {name: 'AGI',   key: '_statCache.agi'}
        {name: 'CON',   key: '_statCache.con'}
        {name: 'INT',   key: '_statCache.int'}
        {name: 'WIS',   key: '_statCache.wis'}
        {name: 'HP',    key: 'hp.maximum'}
        {name: 'MP',    key: 'mp.maximum'}
        {name: 'Gold',  key: 'gold.__current'}
      ]
      extraStats: _.sortBy [
        {name: 'Damage Dealt',            key: 'statistics.calculated total damage given'}
        {name: 'Damage Taken',            key: 'statistics.calculated total damage received'}
        {name: 'Healing Received',        key: 'statistics.calculated total healing received'}
        {name: 'Healing Given',           key: 'statistics.calculated total healing given'}
        {name: 'Gold Found',              key: 'statistics.calculated total gold gained'}
        {name: 'Gold Lost',               key: 'statistics.calculated total gold lost'}
        {name: 'XP Gained',               key: 'statistics.calculated total xp gained'}
        {name: 'XP Lost',                 key: 'statistics.calculated total xp lost'}
        {name: 'Steps Taken',             key: 'statistics.explore walk'}
        {name: 'Fled From Combat',        key: 'statistics.combat self flee'}
        {name: 'Events Experienced',      key: 'statistics.event'}
        {name: 'Cataclysms Experienced',  key: 'statistics.event cataclysms'}
        {name: 'Times Fallen',            key: 'statistics.explore transfer fall'}
        {name: 'Times Ascended',          key: 'statistics.explore transfer ascend'}
        {name: 'Times Descended',         key: 'statistics.explore transfer descend'}
        {name: 'Teleports Taken',         key: 'statistics.explore transfer teleport'}
        {name: 'Walls Walked Into',       key: 'statistics.explore hit wall'}
        {name: 'Items Sold',              key: 'statistics.player sellItem'}
        {name: 'Monster Battles',         key: 'statistics.event monsterbattle'}
        {name: 'Boss Kills',              key: 'statistics.event bossbattle win'}
        {name: 'Items Equipped',          key: 'statistics.event findItem'}
        {name: 'Switcheroos',             key: 'statistics.event flipStat'}
        {name: 'Enchantments',            key: 'statistics.event enchant'}
        {name: 'Class Changes',           key: 'statistics.player profession change'}
        {name: 'Times Gained XP',         key: 'statistics.player xp gain'}
        {name: 'Times Lost XP',           key: 'statistics.player xp lose'}
        {name: 'Treasures Found',         key: 'statistics.event treasurechest find'}
        {name: 'Player Kills',            key: 'statistics.combat self kill'}
        {name: 'Player Deaths',           key: 'statistics.combat self killed'}
        {name: 'Attacks Made',            key: 'statistics.combat self attack'}
        {name: 'Attacks Deflected',       key: 'statistics.combat self deflect'}
        {name: 'Attacks Dodged',          key: 'statistics.combat self dodge'}
        {name: 'Heaviest Attack',         key: 'statistics.calculated max damage given'}
        {name: 'Biggest Switcheroo',      key: 'statistics.calculated biggest switcheroo'}
        {name: 'Times Tempted Fate',      key: 'statistics.event providence'}
        {name: 'Lost Levels',             key: 'statistics.event levelDown'}
        {name: 'Most Submissions',        key: 'permanentAchievements.contentSubmissions'}
      ], (item) -> item.name
      classes: []
      maps: []
      achievements: []
      personalities: []
      guilds: []

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
        filterData.achievements.push (_.pluck player.achievements, 'name')...
        filterData.personalities.push player.personalityStrings...
        filterData.guilds.push player.guild if player.guild

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
      filterData.achievements = (_.uniq filterData.achievements).sort()
      filterData.personalities = (_.uniq filterData.personalities).sort()
      filterData.guilds = (_.uniq filterData.guilds).sort()

    getFilters: -> filters
    setFilters: (newFilters) -> filters = newFilters
    getFilterData: -> filterData