
if Meteor.isClient
  angular.module('kurea.web').controller 'IdlePetSidebar', [
    '$scope', 'CurrentPet',
    ($scope, CurrentPet) =>

      $scope._ = window._

      $scope.getGenderFor = (player) ->
        switch player.gender
          when "male" then "male"
          when "female" then "female"
          else "question"

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
        gauge.set player.xp.__current or 1
        null

      $scope.$watch (->CurrentPet.getPet()), (newVal, oldVal) ->
        return if newVal is oldVal
        $scope.pet = newVal
  ]