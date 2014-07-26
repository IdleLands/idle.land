
statClass = (val) ->
  ret = "text-danger" if val < 0
  ret = "text-success" if val > 0
  ret

globalGauge = {}
globalLevel = {}

checkLevel = ->
  player = Session.get 'player'
  level = Session.get "#{player.name}_level"

  if not level
    level = player.level.__current
    Session.set "#{player.name}_level", level

  if player.level.__current > level
    Session.set "#{player.name}_level", player.level.__current

    new PNotify
      title: "Level Up!"
      text: "#{player.name} is now level #{player.level.__current}."
      desktop:
        desktop: yes


renderKnob = ->
  xpEl = document.getElementById "xpknob"
  player = Session.get 'player'
  return if not player
  if not globalGauge[player.name]
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

    globalGauge[player.name] = new Donut(xpEl).setOptions opts

  globalGauge[player.name].maxValue = player.xp.maximum
  globalGauge[player.name].set player.xp.__current

  do checkLevel

if Meteor.isClient
  do PNotify.desktop.permission
  currentLevel = null

  Template.idle.players = =>
    @IdlePlayers
      .find {}, {sort: {'level.__current': -1}}

  Template['idle.player'].helpers
    stat: (name, val, valP, width) ->
      Template.__stat

    knob: (stat) ->
      renderKnob()
      Session.set 'lastUpdate', new Date()
      Template.__knob

  Template['idle.player'].totalStats = ->
    player = Session.get 'player'
    return if not player

    statTotals = {}
    _.each player.equipment, (item) ->
      _.each ['str', 'dex', 'int', 'wis', 'agi', 'con', 'fire', 'ice', 'thunder', 'earth', 'water'], (stat) ->
        statPerc = "#{stat}Percent"
        statTotals[stat] = 0 if not (stat of statTotals)
        statTotals[statPerc] = 0 if not (statPerc of statTotals)
        statTotals[stat] += item[stat] if (stat of item)
        statTotals[statPerc] += item[statPerc] if (statPerc of item)

    statTotals

  Template['idle.player'].rendered = ->
    renderKnob()

  Template.__stat.rendered = ->
    @$('.stat-value').each ->
      me = $(this)
      me.addClass statClass parseInt(me.text())

      if me.text() is '%'
        me.text('0%')

  Deps.autorun ->
    Deps.afterFlush ->
      $(".content-inner").scrollTop(0)
      $(window).scrollTop(0)
