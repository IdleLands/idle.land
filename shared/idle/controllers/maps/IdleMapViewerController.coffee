
if Meteor.isClient
  angular.module('kurea.web').controller 'IdleMapViewerDummyController', [
    '$state', '$stateParams'
    ($state, $stateParams) ->
      $state.go 'idlemapviewer', $stateParams
  ]

  angular.module('kurea.web').controller 'IdleMapViewer', [
    '$scope', '$http', '$state', '$location', '$stateParams', 'PageTitle'
    ($scope, $http, $state, $location, $stateParams, PageTitle) =>

      $scope.mapName = $stateParams.mapName || 'Norkos'
      $state.go 'idlemapviewerd', {mapName: 'Norkos'}, {reload: yes} if not $stateParams.mapName

      PageTitle.setTitle "Idle Lands - #{$scope.mapName}"
      window.scrollTo 0,0

      # game constants
      game = null
      mapName = null
      newMapName = null
      objectGroup = null

      # pan
      camera = null
      cameraDrag = 5
      cameraAccel = 3
      camVelX = 0
      camVelY = 0
      camMaxSpeed = 80

      # zoom
      worldScale = 1

      # text objects
      coordinates = ""
      itemText = ""

      textObject = null

      dragCamera = (pointer) ->
        return if not pointer.timeDown

        if pointer.isDown and not pointer.targetObject
          if camera
            camVelX = (camera.x - pointer.position.x) * cameraAccel
            camVelY = (camera.y - pointer.position.y) * cameraAccel

          camera = pointer.position.clone()

        camera = null if pointer.isUp

      updateCamera = ->
        camVelX = Phaser.Math.clamp camVelX, -camMaxSpeed, camMaxSpeed
        camVelY = Phaser.Math.clamp camVelY, -camMaxSpeed, camMaxSpeed

        game.camera.x += camVelX
        game.camera.y += camVelY

        if camVelX > cameraDrag
          camVelX -= cameraDrag
        else if camVelX < -cameraDrag
          camVelX += cameraDrag
        else
          camVelX = 0

        if camVelY > cameraDrag
          camVelY -= cameraDrag
        else if camVelY < -cameraDrag
          camVelY += cameraDrag
        else
          camVelY = 0

      updateText = ->
        coordinates = ((game.camera.x+game.input.x)//16) + ", " + ((game.camera.y+game.input.y)//16)
        textObject.text = "#{coordinates}\n#{itemText}"

      updateScale = ->
        return #currently, zooming is just a clusterfuck.
        game.world.scale.set worldScale
        objectGroup.scale.set worldScale

      doMouseWheel = ->
        worldScale += game.input.mouse.wheelDelta / 20
        worldScale = Phaser.Math.clamp worldScale, 0.25, 2
        updateScale()

      handleObjects = ->
        _.each objectGroup.children, (child) ->

          child.inputEnabled = yes

          child.events.onInputOver.add ->
            itemText = ""
            itemText = "#{child.realtype}: #{child.name}" if child.realtype and child.realtype isnt "Door"

            itemText += "\n\"#{child.flavorText}\"" if child.flavorText

            requires = no
            requirementText = "\nRequirements\n-------------------"
            if child.requireAchievement then requirementText += "\nAchievement: #{child.requireAchievement}";requires=yes
            if child.requireBoss        then requirementText += "\nBoss Kill: #{child.requireBoss}";requires=yes
            if child.requireClass       then requirementText += "\nClass: #{child.requireClass}";requires=yes
            if child.requireCollectible then requirementText += "\nCollectible: #{child.requireCollectible}";requires=yes
            if child.requireMap         then requirementText += "\nMap Visited: #{child.requireMap}";requires=yes
            if child.requireRegion      then requirementText += "\nRegion Visited: #{child.requireRegion}";requires=yes
            if child.requireHoliday     then requirementText += "\nHoliday: #{child.requireHoliday}";requires=yes

            itemText = "#{itemText}\n#{requirementText}" if requires

          child.events.onInputOut.add ->
            itemText = ""

          child.events.onInputDown.add ->

            [x, y, map] = [null, null, null]
            if child.teleportLocation
              loc = $scope.teleportLocations[child.teleportLocation]
              [x, y, map] = [loc.x, loc.y, loc.map]
            else if child.teleportMap
              [x, y, map] = [child.teleportX, child.teleportY, child.teleportMap]

            else return

            $state.go 'idlemapviewerd', {mapName: map, x: x, y: y} #haxy workaround

      $scope.drawMap = ->
        return if _.isEmpty $scope.currentMap

        newMapName = $scope.mapName if not newMapName

        phaserOpts =
          preload: ->
            url = "../../img/tiles.png"
            @game.load.image "tiles", url, 16, 16
            @game.load.spritesheet "interactables", url, 16, 16
            @game.load.tilemap newMapName, null, $scope.currentMap.map, Phaser.Tilemap.TILED_JSON

          create: ->
            map = @game.add.tilemap newMapName
            map.addTilesetImage "tiles", "tiles"
            terrain = map.createLayer "Terrain"
            terrain.resizeWorld()
            map.createLayer "Blocking"

            objectGroup = @game.add.group()

            for i in [1, 2, 12, 13, 14, 15, 16, 18, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31, 32, 35, 37, 48, 51]
              map.createFromObjects "Interactables", i, "interactables", i-1, yes, no, objectGroup

            handleObjects()

            textObject = @game.add.text 10, 10, '', {font: '15px Arial', fill: '#fff', stroke: '#000', strokeThickness: 3}
            textObject.fixedToCamera = yes

            @game.camera.focusOnXY (parseInt $stateParams.x)*16, (parseInt $stateParams.y)*16 if $stateParams.x and $stateParams.y

          update: ->
            dragCamera game.input.mousePointer
            updateCamera()
            updateText()

            if @game.input.mousePointer.isDown
              $location.search x: (@game.camera.view.x+@game.input.x)//16, y: (@game.camera.view.y+@game.input.y)//16
              $scope.$emit '$locationChangeSuccess'

          init: ->
            @game.scale.scaleMode = Phaser.ScaleManager.RESIZE
            @game.input.mouse.mouseWheelCallback = doMouseWheel

        return if game
        game = new Phaser.Game $scope.gameWidth, $scope.gameHeight, Phaser.AUTO, 'map', phaserOpts

      $scope.loadMap = (mapName) ->
        $http.post "//api.idle.land/game/map", {map: mapName}
        .then (res) ->
          $scope.currentMap = res.data.map
          _.each $scope.currentMap?.map?.layers[2].objects, (object) ->

            object.properties =
              realtype: object.type
              teleportX: parseInt object.properties.destx
              teleportY: parseInt object.properties.desty
              teleportMap:        object.properties.map
              teleportLocation:   object.properties.toLoc
              requireBoss:        object.properties.requireBoss
              requireCollectible: object.properties.requireCollectible
              requireAchievement: object.properties.requireAchievement
              requireClass:       object.properties.requireClass
              requireMap:         object.properties.requireMap
              requireRegion:      object.properties.requireRegion
              flavorText:         object.properties.flavorText
              requireHoliday:     object.properties.holiday

          $scope.drawMap()

      $scope.loadMap $scope.mapName

      resizeGame = ->
        $scope.gameHeight = $(window).height() - $('header').height() - $('.content-header').outerHeight()
        $scope.gameWidth  = $(window).width() - $('.left-side').width()

        if game
          game.width = game.canvas.width = game.scale.width = game.scale.bounds.width = $scope.gameWidth
          game.height = game.canvas.height = game.scale.height = game.scale.bounds.height = $scope.gameHeight
          game.world.resize game.width, game.height

      $(window).resize resizeGame

      resizeGame()

      $http.get "https://cdn.rawgit.com/IdleLands/IdleLands/ca912c255cc2180f77e42b5be157bc3073a06637/config/teleports.json"
      .then (res) ->
        $scope.teleportLocations = _.extend {},
          res.data.towns,
          res.data.bosses,
          res.data.dungeons,
          res.data.trainers,
          res.data.others
  ]