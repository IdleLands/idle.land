


statClass = (val) ->
  ret = "text-danger" if val < 0
  ret = "text-success" if val > 0
  ret

if Meteor.isClient
  Template.idle.players = =>
    @IdlePlayers
      .find {}, {sort: {'level.__current': -1}}

  Template['idle.player'].helpers
    stat: (name, val, width) ->
      Template.__stat

  Template.__stat.rendered = ->
    item = @$('.stat-value')
    item.addClass statClass parseInt($(item).text())