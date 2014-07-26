
statClass = (val) ->
  ret = "text-danger" if val < 0
  ret = "text-success" if val > 0
  ret

globalGauge = null

renderKnob = ->
  xpEl = document.getElementById "xpknob"
  player = Session.get 'player'
  if not globalGauge
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

    globalGauge = new Donut(xpEl).setOptions opts

  globalGauge.maxValue = player.xp.maximum
  globalGauge.set player.xp.__current

if Meteor.isClient
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
    player = Session.get 'player'
    return if not player or not $("#xpknob")[0]
    renderKnob()
