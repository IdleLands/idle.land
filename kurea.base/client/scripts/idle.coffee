
if Meteor.isClient
  Template.idle.players = =>
    @IdlePlayers.find {}

  #Template.idle.player.getPlayer = (name) =>
  #  @IdlePlayers.find {name: name}