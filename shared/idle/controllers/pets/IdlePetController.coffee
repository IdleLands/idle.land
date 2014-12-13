
if Meteor.isClient
  angular.module('kurea.web').controller 'IdlePet', [
    '$scope', '$stateParams', '$sce', '$collection', '$subscribe', 'IdleCollections', 'PageTitle', 'CurrentPet',
    ($scope, $stateParams, $sce, $collection, $subscribe, IdleCollections, PageTitle, CurrentPet) =>

      window.scrollTo 0,0

      $scope.$sce = $sce
      $scope._ = window._

      $scope.formatGift = (key, gift) ->
        switch key
          when "battleJoinPercent" then "#{gift}%"
          when "goldStorage" then _.str.numberFormat gift
          when "itemFindBonus" then "+#{gift}"
          when "itemFindRangeMultiplier", "itemSellMultiplier" then "#{gift*100}%"
          else gift

      $scope.petUpgradeData =
        inventory:
          stat: "Inventory Size"
          gift: "Inventory size is %gift"

        maxLevel:
          stat: "Max Level"
          gift: "Max level is %gift"

        goldStorage:
          stat: "Gold Storage"
          gift: "Gold storage is %gift"

        battleJoinPercent:
          stat: "Combat Aid Chance"
          gift: "Battle join chance is %gift"

        itemFindBonus:
          stat: "Item Find Bonus"
          gift: "Bonus to found items is %gift"

        itemFindTimeDuration:
          stat: "Item Find Time"
          gift: "New item every %gifts"

        itemSellMultiplier:
          stat: "Item Sell Bonus"
          gift: "Sell bonus is %gift"

        itemFindRangeMultiplier:
          stat: "Item Equip Bonus"
          gift: "Bonus to equipping is %gift"

        xpPerGold:
          stat: "XP / gold"
          gift: "Gain %gift xp per gold fed to pet"

      $stateParams.petUid = parseInt $stateParams.petUid

      $subscribe.subscribe 'singlePet', $stateParams.petUid
      .then ->
        $collection IdleCollections.IdlePets, createdAt: $stateParams.petUid
        .bind $scope, 'pet'

      $scope.getPetTagline = (pet) ->
        pet._configCache.description

      $scope.getEquipmentTypes = (pet) ->
        _.keys pet._configCache.slots

      $scope.getEquipmentOfType = (pet, type) ->
        items = $scope.getEquipment pet

        _.filter items, (item) -> type is item.type

      $scope.canSeeUid = (pet, item) ->
        item.type isnt "pet soul" and -1 isnt pet.equipment.indexOf item

      $scope.getInventory = (pet) ->
        overflow = pet.inventory

        items = []

        if overflow
          _.each overflow, (item, index) ->
            item.headerColor = "success"
            item.bgColor = 'bg-green'
            item.bgClassColor = $scope.classToColor item.itemClass
            item.extraColor = 'bg-orange'
            item.extraText = "SLOT #{index}"
            items.push item

        items

      $scope.getPetSoulAndTotals = (pet) ->
        items = $scope.getEquipment pet

        totals = []

        lastCalc = pet._statCache

        if lastCalc
          _.each (_.keys lastCalc), (key) -> lastCalc[key] = lastCalc[key].toFixed 1

          lastCalc.name = 'Last Cached Calculated Stats'
          lastCalc.type = 'CACHED'
          lastCalc.bgColor = 'bg-maroon'
          lastCalc.headerColor = 'primary'

          $scope.lastCalcObj = [lastCalc]

        test = _.reduce items, (prev, cur) ->
          for key, val of cur
            prev[key] = 0 if not (key of prev) and _.isNumber val
            prev[key] += val if _.isNumber val
          prev
        , {name: 'Equipment Stat Totals', type: 'EQUIPMENT', bgColor: 'bg-maroon', headerColor: 'primary'}

        totals.push _.findWhere items, {type: "pet soul"}

        totals.unshift test

        totals

      $scope.itemItemScore = (item) ->
        return 0 if not item._baseScore or not item._calcScore
        parseInt (item._calcScore / item._baseScore) * 100

      $scope.playerItemScore = (player, item) ->
        return 0 if not item._calcScore or not player._baseStats.itemFindRange
        parseInt (item._calcScore / player._baseStats.itemFindRange) * 100

      $scope.getEquipmentAndTotals = (player) ->
        items = $scope.getEquipment player

        lastCalc = player._statCache

        if lastCalc
          _.each (_.keys lastCalc), (key) -> lastCalc[key] = lastCalc[key].toFixed 1

          lastCalc.name = 'Last Cached Calculated Stats'
          lastCalc.type = 'CACHED'
          lastCalc.bgColor = 'bg-maroon'
          lastCalc.headerColor = 'primary'

          $scope.lastCalcObj = [lastCalc]

        test = _.reduce items, (prev, cur) ->
          for key, val of cur
            prev[key] = 0 if not (key of prev) and _.isNumber val
            prev[key] += val if _.isNumber val
          prev
        , {name: 'Equipment Stat Totals', type: 'EQUIPMENT', bgColor: 'bg-maroon', headerColor: 'primary'}

        items.unshift test

        items

      $scope.getEquipment = (pet) ->
        base = _.sortBy pet.equipment, (item) -> item.type

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
          when 'guardian'         then return 'bg-cyan'

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
        {name: '_baseScore'},
        {name: 'uid'}

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

      $scope.$watch 'pet', (newVal, oldVal) ->
        return if newVal is oldVal

        CurrentPet.setPet newVal
        PageTitle.setTitle "Idle Lands - #{newVal[0].name} (Stats)"
  ]