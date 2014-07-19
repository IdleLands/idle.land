


statClass = (val) ->
  ret = "text-danger" if val < 0
  ret = "text-success" if val > 0
  ret

if Meteor.isClient
  Template.idle.players = =>
    @IdlePlayers
      .find {}, {sort: {'level.__current': -1}}

  Template['idle.player'].helpers
    stat: (name, val, valP, width) ->
      Template.__stat

  Template.__stat.rendered = ->
    @$('.stat-value').each ->
      me = $(this)
      me.addClass statClass parseInt(me.text())

      if me.text() is '%'
        me.text('0%')