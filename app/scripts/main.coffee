map = null
tileset = null
layer = null
player = null
facing = 'left'
startJumpTime = 0
cursors = null
jumpButton = null
bg = null

gameStates =
    preload: ->
        game.load.tilemap('level1', 'levels/level1.json', null, Phaser.Tilemap.TILED_JSON)
        game.load.image('tiles-1', 'images/tiles-1.png')
        game.load.spritesheet('dude', 'images/dude.png', 32, 48)
        game.load.spritesheet('droid', 'images/droid.png', 32, 32)
        game.load.image('starSmall', 'images/star.png')
        game.load.image('starBig', 'images/star2.png')
        game.load.image('background', 'images/background2.png')

    create: ->
        game.physics.startSystem(Phaser.Physics.ARCADE)

        game.stage.backgroundColor = '#000000'

        bg = game.add.tileSprite(0, 0, 800, 600, 'background')
        bg.fixedToCamera = true

        map = game.add.tilemap('level1')

        map.addTilesetImage('tiles-1')

        #map.setCollisionByExclusion([ 14 ])
        map.setCollision(14)
        map.setTileIndexCallback([
                 1,  2,  3,  4,  5,  6,  7,  8,  9, 10, 11,
                17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27,
                32, 33, 34, 35, 36, 37, 38, 39, 40, 41, 42
            ], (sprite, tile) ->
                return if sprite != player
                map.removeTile(tile.x, tile.y)
        )

        layer = map.createLayer('Tile Layer 1')

        #  Un-comment this on to see the collision tiles
        # layer.debug = true

        layer.resizeWorld()

        game.physics.arcade.gravity.y = 450

        player = game.add.sprite(32, 32, 'dude')
        game.physics.enable(player, Phaser.Physics.ARCADE)

        player.body.bounce.y = 0.2
        player.body.collideWorldBounds = true
        player.body.setSize(20, 32, 5, 16)

        player.animations.add('left', [0, 1, 2, 3], 10, true)
        player.animations.add('turn', [4], 20, true)
        player.animations.add('right', [5, 6, 7, 8], 10, true)

        game.camera.follow(player)

        cursors = game.input.keyboard.createCursorKeys()
        jumpButton = game.input.keyboard.addKey(Phaser.Keyboard.SPACEBAR)

    update: ->
        game.physics.arcade.collide(player, layer)

        player.body.velocity.x = 0

        if cursors.left.isDown
            player.body.velocity.x = -150
            if facing != 'left'
                player.animations.play('left')
                facing = 'left'
        else if cursors.right.isDown
            player.body.velocity.x = 150
            if facing != 'right'
                player.animations.play('right')
                facing = 'right'
        else
            if facing != 'idle'
                player.animations.stop()
                if facing == 'left'
                    player.frame = 0
                else
                    player.frame = 5

                facing = 'idle'

        if jumpButton.isDown
            if player.body.onFloor() and game.time.now > startJumpTime + 750
                player.body.velocity.y = -230
                startJumpTime = game.time.now
            else if game.time.now < startJumpTime + 350
                # still keeping jump button pressed
                player.body.velocity.y = -230

    render: ->
        #game.debug.text(game.time.physicsElapsed, 32, 32)
        #game.debug.body(player)
        game.debug.bodyInfo(player, 16, 24)

game = new Phaser.Game(800, 600, Phaser.AUTO, 'phaser-example', gameStates)
