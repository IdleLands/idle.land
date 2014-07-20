
statClass = (val) ->
  ret = "text-danger" if val < 0
  ret = "text-success" if val > 0
  ret

renderKnob = ->
  setTimeout ->
    $(".knob").knob
      min: 0
      thickness: 0.1
      height: 90
      width: 150
      angleArc: 180
      angleOffset: -90
      displayPrevious: true
      fgColor: "#004224"
      bgColor: "#00a65a"
      skin: "tron"
      stepsize: 0.1
      readOnly: true
  , 1000

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

  Template.__knob.rerendered = ->
    Session.get 'lastUpdate'
    renderKnob()

  Template.__knob.rendered = ->
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
    $("#xpknob").empty()
    UI.insert (UI.renderWithData Template.__knob, player.xp ), $('#xpknob')[0]