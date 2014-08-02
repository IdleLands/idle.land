
statClass = (val) ->
  ret = "text-danger" if val < 0
  ret = "text-success" if val > 0
  ret


global = @
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

renderKnob = =>
  xpEl = document.getElementById "xpknob"
  player = Session.get 'player'
  return if not player
  if not global.globalGauge
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

    global.globalGauge = new Donut(xpEl).setOptions opts

  global.globalGauge.maxValue = player.xp.maximum
  global.globalGauge.set player.xp.__current

  do checkLevel

if Meteor.isClient
  do PNotify.desktop.permission
  currentLevel = null

  Template.idle.players = =>
    lastMonth = new Date
    lastMonth.setDate lastMonth.getDate() - 30

    reg = (Session.get "nameFilter") or ""

    @IdlePlayers
      .find {lastLogin: {$gt: lastMonth}, name: {$regex: reg}}, {sort: {'level.__current': -1, 'name': 1}}

  Template.idle.rendered = ->
    $("#name-input").val Session.get "nameFilter"

  Template.idle.events
    'keyup #name-input': ->
      Session.set "nameFilter", $("#name-input").val()

  Template['idle.player'].helpers
    stat: (name, val, valP, width, tooltip) ->
      Template.__stat

    statisticsObj: (key) ->
      val = Session.get('player')?.statistics[key] or 0
      buildHtmlFromObject = (obj) ->
        _.sortBy (_.keys obj), (key) ->
          -obj[key]
        .map (key) ->
          "<li>#{key} (#{obj[key]})</li>"
        .join ""
      if _.isObject val then "<ul class='kills no-margin'>#{buildHtmlFromObject val}</ul>" else val

    knob: (stat) ->
      renderKnob()
      Session.set 'lastUpdate', new Date()
      Template.__knob

    isntZero: (val) ->
      val isnt 0

  Template['idle.player'].totalStats = ->
    player = Session.get 'player'
    return if not player

    statTotals = {}
    _.each player.equipment, (item) ->
      _.each ['str', 'dex', 'int', 'wis', 'agi', 'con', 'fire', 'ice', 'thunder', 'earth', 'water'], (stat) ->
        statPerc = "#{stat}Percent"
        statTt = "#{stat}Tooltip"
        StatPercTt = "#{statPerc}Tooltip"

        statTotals[stat] = 0 if not (stat of statTotals)
        statTotals[statPerc] = 0 if not (statPerc of statTotals)
        statTotals[statTt] = [] if not (statTt of statTotals)
        statTotals[StatPercTt] = [] if not (StatPercTt of statTotals)

        statTotals[stat] += item[stat] if (stat of item)
        statTotals[statPerc] += item[statPerc] if (statPerc of item)
        statTotals[statTt].push name: item.name, value: item[stat] if (stat of item) and item[stat] isnt 0
        statTotals[StatPercTt].push name: item.name, value: item[stat] if (statPerc of item) and item[statPerc] isnt 0

    Session.set "#{player.name}_stats", statTotals

    statTotals

  Template['idle.player'].recentEvents = ->
    player = Session.get "player"
    events = (IdlePlayerEvents.find {player: player?.name}, {limit: 7, sort: {createdAt:-1}}).fetch()

    return [{message:"No recent events :("}] if events?.length is 0
    events

  Template['idle.player'].rendered = ->
    renderKnob()
    $(".content-inner, body, html").scrollTop 0
    $(window).scrollTop 0

  Template.__stat.rendered = ->
    player = Session.get "player"
    statTotals = Session.get "#{player.name}_stats"

    @$('.stat-value, .stat-value-percent').each ->
      me = $(this)
      me.addClass statClass parseInt(me.text())

      if me.text() is '%'
        me.text '0%'

    @$('.stat-value').popover 'destroy'
    if this.data.val isnt 0

      toolTipData = statTotals["#{this.data.name}Tooltip"]
        ?.map (item) -> "<tr><td>#{item.name}</td><td>#{item.value}</td></tr>"
        .join ""

      @$('.stat-value').popover
        html: true
        content: "<table class='table table-striped table-condensed'>#{toolTipData}</table>"
        placement: 'bottom'
        trigger: 'hover'
        container: 'body'

    @$('.stat-value-percent').popover 'destroy'
    if this.data.valP isnt 0

      toolTipData = statTotals["#{this.data.name}PercentTooltip"]
        ?.map (item) -> "<tr><td>#{item.name}</td><td>#{item.value}</td></tr>"
        .join ""

      @$('.stat-value-percent').popover
        html: true
        content: "<table class='table table-striped table-condensed'>#{toolTipData}</table>"
        placement: 'bottom'
        trigger: 'hover'
        container: 'body'