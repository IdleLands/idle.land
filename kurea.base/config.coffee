
#@Messages = new Meteor.Collection "Log_messages"

global = @
if Meteor.isServer
  Meteor.startup ->

if Meteor.isClient
  Router.configure
    layoutTemplate: 'master'

  Router.map ->
    @route "home", path: "/"
    #@route "log", path: "/log"
    @route "idle", path: "/idle"
    @route "idle.player", path: "/idle/:name", data: ->
      player = IdlePlayers.findOne {name: @params.name}
      return if not player
      player.personalityString = if player.personalityStrings?.length > 0 then player.personalityStrings.join '' else "No personalities selected"
      player.equipment = _.sortBy player.equipment, (item) -> item.type

      _.each player.equipment, (item) ->
        props = ['silver','power','deadeye','prone','offense','defense','crit','dodge','glowing']
        propsGot = _.reduce props, (prev, prop) ->
          prev.push prop if (prop of item)
          prev
        , []

        if propsGot.length > 0
          item.propString = propsGot.join ', '
        else
          item.propString = "no special properties"

      Session.set "player", player
      player.statsArray = _.sortBy (_.keys player.statistics or []), (v) -> v
      global.refresh = true
      player