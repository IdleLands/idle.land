
if Meteor.isClient
  angular.module('kurea.web').controller 'IdleSpecialThanks', [
    'PageTitle',
    (PageTitle) =>
      PageTitle.setTitle "Idle Lands - Special Thanks"
  ]