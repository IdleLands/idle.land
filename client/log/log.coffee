
if Meteor.isClient
  Template.log.messages = =>
    @Messages
      .find {}, {}