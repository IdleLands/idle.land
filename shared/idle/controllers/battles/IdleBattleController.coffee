
if Meteor.isClient
  angular.module('kurea.web').controller 'IdleBattle', [
    '$scope', '$stateParams', '$collection', '$subscribe', 'IdleCollections', 'PageTitle', 'CurrentBattle'
    ($scope, $stateParams, $collection, $subscribe, IdleCollections, PageTitle, CurrentBattle) =>
      CurrentBattle.setBattle {}
      $scope.battle = null

      $scope.battleName = $stateParams.battleName
      PageTitle.setTitle "Idle Lands - #{$scope.battleName}"
      window.scrollTo 0,0

      $subscribe.subscribe 'singleBattle', $scope.battleName
      .then ->
        $collection IdleCollections.IdleBattles
        .bind $scope, '_battle'

      defaultReplaceFunction = (fg='#000', bg = '#fff', fw='normal', td='none') ->
        (msg) ->
          "<span style='color:#{fg};background-color:#{bg};font-weight:#{fw};text-decoration:#{td}'>#{msg}</span>"

      BattleColorMap =
        'player.name':                defaultReplaceFunction(null,null,'bold')
        'event.partyName':            defaultReplaceFunction(null,null,null,'underline')
        'event.partyMembers':         defaultReplaceFunction(null,null,'bold')
        'event.player':               defaultReplaceFunction(null,null,'bold')
        'event.damage':               defaultReplaceFunction('#D50000')
        'event.gold':                 defaultReplaceFunction('#CDDC39')
        'event.realGold':             defaultReplaceFunction('#CDDC39')
        'event.shopGold':             defaultReplaceFunction('#CDDC39')
        'event.xp':                   defaultReplaceFunction('#1B5E20')
        'event.realXp':               defaultReplaceFunction('#1B5E20')
        'event.percentXp':            defaultReplaceFunction('#1B5E20')
        'event.item.newbie':          defaultReplaceFunction('#9E9E9E')
        'event.item.Normal':          defaultReplaceFunction('#9E9E9E')
        'event.item.basic':           defaultReplaceFunction('#2196F3')
        'event.item.pro':             defaultReplaceFunction('#4527A0')
        'event.item.idle':            defaultReplaceFunction('#FF7043')
        'event.item.godly':           defaultReplaceFunction('#fff','#000')
        'event.item.custom':          defaultReplaceFunction('#fff','#1A237E')
        'event.item.guardian':        defaultReplaceFunction('#fff', '#006064')
        'event.finditem.scoreboost':  defaultReplaceFunction()
        'event.finditem.perceived':   defaultReplaceFunction()
        'event.finditem.real':        defaultReplaceFunction()
        'event.blessItem.stat':       defaultReplaceFunction()
        'event.blessItem.value':      defaultReplaceFunction()
        'event.flip.stat':            defaultReplaceFunction()
        'event.flip.value':           defaultReplaceFunction()
        'event.enchant.boost':        defaultReplaceFunction()
        'event.enchant.stat':         defaultReplaceFunction()
        'event.tinker.boost':         defaultReplaceFunction()
        'event.tinker.stat':          defaultReplaceFunction()
        'event.transfer.destination': defaultReplaceFunction()
        'event.transfer.from':        defaultReplaceFunction()
        'player.class':               defaultReplaceFunction(null,null,'bold')
        'player.level':               defaultReplaceFunction(null,null,'bold')
        'stats.hp':                   defaultReplaceFunction('#B71C1C')
        'stats.mp':                   defaultReplaceFunction('#283593')
        'stats.sp':                   defaultReplaceFunction('#F57F17')
        'damage.hp':                  defaultReplaceFunction('#D50000')
        'damage.mp':                  defaultReplaceFunction('#D50000')
        'spell.turns':                defaultReplaceFunction(null,null,'bold')
        'spell.spellName':            defaultReplaceFunction(null,null,'bold')
        'event.casterName':           defaultReplaceFunction(null,null,'bold')
        'event.spellName':            defaultReplaceFunction(null,null,'bold')
        'event.targetName':           defaultReplaceFunction(null,null,'bold')
        'event.achievement':          defaultReplaceFunction(null,null,'bold')
        'event.guildName':            defaultReplaceFunction(null,null,'bold')

      $scope.filterMessage = (message) ->
        for search, replaceFunc of BattleColorMap
          regexp = new RegExp "(<#{search}>)([\\s\\S]*?)(<\\/#{search}>)", 'g'
          message = message.replace regexp, (match, p1, p2) ->
            console.log p2
            replaceFunc p2

        message

      $scope.$watch '_battle', (newVal, oldVal) ->
        return if newVal is oldVal
        $scope.battle = _.findWhere newVal, {name: $scope.battleName}
        CurrentBattle.setBattle $scope.battle

  ]