

if Meteor.isClient

  player = null

  sprite = null

  game = null

  phaserOpts =
    preload: ->
      @game.load.image "tiles", "../img/tiles.png", 16, 16
      @game.load.spritesheet "interactables", "../img/tiles.png", 16, 16
      @game.load.tilemap player.map, "../map/#{player.map}.json", null, Phaser.Tilemap.TILED_JSON

    create: ->
      map = @game.add.tilemap player.map
      map.addTilesetImage "tiles", "tiles"
      terrain = map.createLayer "Terrain"
      terrain.resizeWorld()
      map.createLayer "Blocking"

      map.createFromObjects "Interactables", 1, "interactables"
      map.createFromObjects "Interactables", 2, "interactables"

      map.createFromObjects "Interactables", 12, "interactables", 11
      map.createFromObjects "Interactables", 13, "interactables", 12
      map.createFromObjects "Interactables", 14, "interactables", 13

      sprite = @game.add.sprite player.x*16, player.y*16, 'interactables', 12
      @game.camera.follow sprite

  Template.drawnMap.drawnMap = ->
    div = document.getElementsByClassName("drawMapHere")[0]
    player = Session.get "player"

    if sprite
      sprite.x = (player.x*16)
      sprite.y = (player.y*16)
      game.camera.x = sprite.x
      game.camera.y = sprite.y

      game.load.tilemap "../map/#{player.map}.json", null, Phaser.Tilemap.TILED_JSON

    return if (not player) or game
    game = new Phaser.Game 600,300, Phaser.CANVAS, div, phaserOpts

    null
