
if Meteor.isClient
  angular.module('kurea.web').controller 'IdlePlayer', [
    '$scope', '$stateParams', '$sce', '$collection', '$subscribe', 'IdleCollections', 'PageTitle', 'CurrentPlayer', 'CurrentMap'
    ($scope, $stateParams, $sce, $collection, $subscribe, IdleCollections, PageTitle, CurrentPlayer, CurrentMap) =>

      window.scrollTo 0,0

      $scope.$sce = $sce
      $scope._ = window._
      $scope.playerName = $stateParams.playerName
      $scope.currentMap = {}

      PageTitle.setTitle "Idle Lands - #{$scope.playerName} (Stats)"

      $subscribe.subscribe 'singlePlayer', $stateParams.playerName
      .then ->
        $collection IdleCollections.IdlePlayers, name: $stateParams.playerName
        .bind $scope, 'player'

      $scope.getPlayerTagline = (player) ->
        player.messages?.web

      $scope.setPlayerInSession = (player) ->
        Session.set 'player', player

      $scope.getEquipmentAndTotals = (player) ->
        items = $scope.getEquipment player

        test = _.reduce items, (prev, cur) ->
          for key, val of cur
            prev[key] = 0 if not (key of prev) and _.isNumber val
            prev[key] += val if _.isNumber val
          prev
        , {name: 'Equipment Stat Totals', type: 'EQUIPMENT', bgColor: 'bg-maroon', headerColor: 'primary'}

        items.unshift test

        lastCalc = player._statCache

        if lastCalc
          _.each (_.keys lastCalc), (key) -> lastCalc[key] = lastCalc[key].toFixed 1

          lastCalc.name = 'Last Cached Calculated Stats'
          lastCalc.type = 'CACHED'
          lastCalc.bgColor = 'bg-maroon'
          lastCalc.headerColor = 'primary'

          items.unshift lastCalc

        overflow = player.overflow

        if overflow
          _.each player.overflow, (item, index) ->
            item.headerColor = "success"
            item.bgColor = 'bg-green'
            item.bgClassColor = $scope.classToColor item.itemClass
            item.extraColor = 'bg-orange'
            item.extraText = "SLOT #{index}"
            items.push item

        items

      $scope.getEquipment = (player) ->
        base = _.sortBy player.equipment, (item) -> item.type

        _.each base, (item) ->
          item.bgColor = 'bg-aqua'
          item.bgClassColor = $scope.classToColor item.itemClass

        base

      $scope.classToColor = (itemClass) ->
        switch itemClass
          when 'newbie', 'Newbie' then return 'bg-maroon'
          when 'Normal', 'basic'  then return 'bg-gray'
          when 'pro'              then return 'bg-purple'
          when 'idle'             then return 'bg-rainbow'
          when 'godly'            then return 'bg-black'
          when 'custom'           then return 'bg-blue'

      $scope.equipmentStatArray = [
        {name: 'str', fa: 'fa-legal fa-rotate-90'}
        {name: 'dex', fa: 'fa-crosshairs'}
        {name: 'agi', fa: 'fa-bicycle'}
        {name: 'con', fa: 'fa-heart'}
        {name: 'int', fa: 'fa-mortar-board'}
        {name: 'wis', fa: 'fa-book'}
        {name: 'fire', fa: 'fa-fire'}
        {name: 'water', fa: 'icon-water'}
        {name: 'thunder', fa: 'fa-bolt'}
        {name: 'earth', fa: 'fa-leaf'}
        {name: 'ice', fa: 'icon-snow'}
        {name: 'luck', fa: 'fa-moon-o'}
      ]

      $scope.extendedEquipmentStatArray = $scope.equipmentStatArray.concat {name: 'sentimentality'},
        {name: 'piety'},
        {name: 'enchantLevel'},
        {name: '_calcScore'},
        {name: '_baseScore'}

      $scope.getPopoverFor = (player, stat) ->
        string = "<table class='table table-striped table-condensed'>"
        items = 0
        _.each player.equipment, (item) ->
          return if item[stat] is 0
          items++
          itemClass = if item[stat] < 0 then 'text-danger' else 'text-success'
          string += "<tr><td>#{item.name}</td><td class='#{itemClass}'>#{item[stat]}</td>"

        string += "<tr><td>No items are adding to this stat!</td></tr>" if items is 0

        string + "</table>"

      $scope.getExtraStats = (item) ->
        keys = _.filter (_.compact _.keys item), (key) -> _.isNumber item[key]

        _.each $scope.extendedEquipmentStatArray, (stat) ->
          keys = _.without keys, stat.name
          keys = _.without keys, "#{stat.name}Percent"

        keys = _.reject keys, (key) -> item[key] is 0

        _.map keys, (key) -> "#{key} (#{item[key]})"
        .join ', '

      $scope.getPersonalityString = (player) ->
        if player.personalityStrings?.length > 0 then (_.sortBy player.personalityStrings, (string) -> string).join ', ' else "No personalities selected"

      sprite = null
      game = null
      mapName = null
      newMapName = null

      ###
      want to reload maps?

      cd public/map
      find ../../../idle/assets/map/ -type f -print0 | xargs -0 cp -t .

      ###
      $scope.drawMap = (player) ->
        return if _.isEmpty $scope.currentMap

        newMapName = player.map if not newMapName

        if sprite
          sprite.x = (player.x*16)
          sprite.y = (player.y*16)
          game.camera.x = sprite.x
          game.camera.y = sprite.y

          if player.map isnt mapName
            newMapName = player.map
            mapName = player.map
            game.state.restart()

        phaserOpts =
          preload: ->
            @game.load.image "tiles", "../../img/tiles.png", 16, 16
            @game.load.spritesheet "interactables", "../../img/tiles.png", 16, 16
            @game.load.tilemap newMapName, null, $scope.currentMap.map, Phaser.Tilemap.TILED_JSON

          create: ->
            map = @game.add.tilemap newMapName
            map.addTilesetImage "tiles", "tiles"
            terrain = map.createLayer "Terrain"
            terrain.resizeWorld()
            map.createLayer "Blocking"

            for i in [1, 2, 12, 13, 14, 15, 18, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31, 32, 35]
              map.createFromObjects "Interactables", i, "interactables", i-1

            sprite = @game.add.sprite player.x*16, player.y*16, 'interactables', 12
            @game.camera.follow sprite

        return if (not player) or game
        game = new Phaser.Game '100%',300, Phaser.AUTO, 'map', phaserOpts
        null

      $scope.isHtmlStat = (player, stat) ->
        _.isObject player.statistics[stat]
        #stat in ['calculated kills', 'calculated kills by class', 'calculated class changes', 'calculated boss kills', 'calculated map changes']

      $scope.statsObj = (player, key) ->
        val = player.statistics[key] or 0

        buildHtmlFromObject = (obj, playerLink = no) ->
          _(_.keys obj).sortBy (key) ->
            -obj[key]
          .filter (key) ->
            not _.str.isBlank key
          .map (key) ->
            embedKey =  if playerLink then "<a href='#{key}'>#{key}</a>" else key
            "<li>#{embedKey} (#{obj[key]})</li>"
          .join ""

        return "<ul class='kills no-margin'>#{buildHtmlFromObject val, true}</ul>" if (_.isObject val) and key is 'calculated kills'
        return "<ul class='kills no-margin'>#{buildHtmlFromObject val, false}</ul>" if (_.isObject val) and key isnt 'calculated kills'
        parseInt val

      $scope.getStats = (player) ->
        _.sortBy (_.keys player.statistics or []), (v) -> v

      $scope.itemItemScore = (item) ->
        return 0 if not item._baseScore or not item._calcScore
        parseInt (item._calcScore / item._baseScore) * 100

      $scope.playerItemScore = (player, item) ->
        return 0 if not item._calcScore or not player._baseStats.itemFindRange
        parseInt (item._calcScore / player._baseStats.itemFindRange) * 100

      $scope.$watch 'player', (newVal, oldVal) ->
        return if newVal is oldVal
        CurrentPlayer.setPlayer newVal

      $scope.$watch (-> CurrentMap.getMap()), (newVal, oldVal) ->
        return if newVal is oldVal
        $scope.currentMap = newVal
  ]