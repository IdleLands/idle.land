
if Meteor.isClient
  ngMeteor.controller 'IdleSpecialThanks', [
    'PageTitle',
    (PageTitle) =>
      PageTitle.setTitle "Idle Lands - Special Thanks"
  ]