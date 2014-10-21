
if Meteor.isClient
  angular.module('kurea.web').controller 'IdlePlayerSidebar', [
    '$scope', '$stateParams', '$subscribe', '$collection', 'IdleCollections',
    ($scope, $stateParams, $subscribe, $collection, IdleCollections) =>

      $scope.playerName = $stateParams.playerName
      $scope._ = window._

      $subscribe.subscribe 'singlePlayer', $stateParams.playerName
      .then ->
        $collection IdleCollections.IdlePlayers, name: $stateParams.playerName
        .bind $scope, 'player'

      $scope.getJSONFor = (player) ->
        str = JSON.stringify player, null, 4
        blob = new Blob [str], type: 'application/json'
        url = URL.createObjectURL blob
        a = document.createElement 'a'
        a.download = "#{player.name}-#{Date.now()}.json"
        a.href = url
        a.click()

      gauge = null
      $scope.updateXp = (player) ->
        if not gauge
          xpEl = document.getElementById 'xpGauge'
          opts =
            lines: 12
            angle: 0
            lineWidth: 0.07
            pointer:
              length: 0.9
              strokeWidth: 0.035
              color: '#000000'
            limitMax: 'false'
            colorStart: '#66CD00'
            colorStop: '#3B5323'
            strokeColor: '#EEEEEE'
            generateGradient: true

          gauge = new Donut(xpEl).setOptions opts

        gauge.maxValue = player.xp.maximum
        gauge.set player.xp.__current
        null
  ]