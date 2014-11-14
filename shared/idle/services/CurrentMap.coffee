if Meteor.isClient
  angular.module('kurea.web').factory 'CurrentMap', ['$rootScope', 'CurrentPlayer', '$http', ($root, Player, $http) ->
    map = null
    player = null

    $root.$watch (->Player.getPlayer()?[0]), (newVal, oldVal) ->
      return if newVal is oldVal
      player = newVal

    $root.$watch (->player?.map), (newVal, oldVal) ->
      return if newVal is oldVal
      $http.post "//api.idle.land/game/map", {map: newVal}
      .then (res) ->
        map = res.data.map

    getMap: -> map
  ]