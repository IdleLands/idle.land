if Meteor.isClient
  angular.module 'kurea.web'
  .directive 'htmldiv', ['$compile', '$parse', ($compile, $parse) ->
    restrict: 'E'
    replace: yes
    link: (scope, el, attr) ->
      scope.$watch attr.content, ->
        el.html $parse(attr.content)(scope)
        ($compile el.contents()) scope
      , yes
  ]