
IdleMeteor = DDP.connect "http://localhost:10023"

IdleMeteor.subscribe "players"
#TODO Fallback
IdlePlayers = @IdlePlayers = new Meteor.Collection "players", connection: IdleMeteor