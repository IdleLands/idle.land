
IdleMeteor = DDP.connect "http://localhost:10023"

IdleMeteor.subscribe "players"
IdleMeteor.subscribe "playerEvents"
#TODO Fallback
IdlePlayers = @IdlePlayers = new Meteor.Collection "players", connection: IdleMeteor
IdlePlayerEvents = @IdlePlayerEvents = new Meteor.Collection "playerEvents", connection: IdleMeteor