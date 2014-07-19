
if Meteor.isClient
  Template.log.messages = =>

    server = Session.get "current_server"
    channel = Session.get "current_channel"

    findOpts = {}
    findOpts.server = server if server
    findOpts.channel = channel if channel
    @Messages
      .find findOpts, {limit: 25, sort: {timestamp: -1}}

  Template.log.servers = =>
    _.uniq _.pluck @Messages.find().fetch(), 'server'

  Template.log.channels = =>
    server = Session.get "current_server"
    _.uniq _.pluck @Messages.find({server: server}).fetch(), 'channel'

  Template.log.rendered = ->
    $(".select2").select2()

  Template.log.events =
    'change #server-select': (evt) ->
      newValue = $(evt.target).val()
      Session.set "current_server", newValue

    'change #channel-select': (evt) ->
      newValue = $(evt.target).val()
      Session.set "current_channel", newValue