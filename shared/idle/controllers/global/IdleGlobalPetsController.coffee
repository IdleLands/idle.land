
if Meteor.isClient

  angular.module('kurea.web').controller 'IdleGlobalPets', [
    '$scope', '$collection', '$subscribe', '$methods', 'IdleFilterData', 'IdleCollections', 'PageTitle',
    ($scope, $collection, $subscribe, $methods, Filters, IdleCollections, PageTitle) ->

      PageTitle.setTitle "Idle Lands - Global Pets"

      $scope.cached = {}

      $scope._ = window._

      $subscribe.subscribe 'globalPets'
      .then ->
        $collection IdleCollections.IdlePets
        .bind $scope, 'pets'

      $scope.topEquipment = []

      $scope.getOrderedByXpPercent = ->
        petList = _.filter $scope.pets, (pet) -> pet.xp.__current < pet.xp.maximum and pet.level.__current < pet.level.maximum
        _.sortBy petList, (pet) -> -(pet.xp.__current / pet.xp.maximum) or 0

      $scope.buildCostHash = ->
        $scope.costHash = {}

        _.each $scope.pets, (pet) ->
          for stat, level of pet.scaleLevel

            $scope.costHash[stat] = {level: 0, spent: 0} unless $scope.costHash[stat]
            $scope.costHash[stat].level += level
            $scope.costHash[stat].spent += _.reduce pet._configCache.scaleCost[stat][0..level], ((prev, cost) -> prev+cost), 0


      $scope.getMaxOfStat = (stat) ->
        list = _.filter $scope.pets, (pet) -> _.isNumber pet._statCache[stat]
        sorted = (_.sortBy list, (pet) -> pet._statCache[stat]).reverse()

        head: sorted[0]
        runnerups: sorted[1..3]

      $scope.remainderToString = (runnerups, stat) ->
        "Notable Mentions<br><br>" +
          _.map runnerups, (pet) ->
            "#{pet.name} (#{pet._statCache[stat]})"
          .join '<br>'

      $scope.statOrder = [
        'str'
        'agi'
        'dex'
        'con'
        'int'
        'wis'
        'luck'
      ]

      $scope.getTopEquipment = ->
        $scope.topEquipment = []

        _.each $scope.pets, (pet) ->
          arr = pet.equipment.concat pet.inventory
          _.each arr, (item) ->
            item.owner = {pet: pet.name, uid: pet.createdAt, player: pet.owner.name}

          $scope.topEquipment = $scope.topEquipment.concat arr

        $scope.topEquipment = (_.sortBy (_.compact $scope.topEquipment), (item) -> -item?._calcScore or 0)[0..10]

      $scope.$watch 'pets', (newVal, oldVal) ->
        return if not newVal or newVal.length is 0 or newVal is oldVal
        $scope.getTopEquipment()
        $scope.buildCostHash()
  ]