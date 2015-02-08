//
//  GameScene.swift
//  Amoeba Wars
//
//  Created by Andre on 7/30/14.
//  Copyright (c) 2014 LucasSoft. All rights reserved.
//

import SpriteKit

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    let SPACE_COLOR = SKColor.blackColor()
    
    let wrapperBlockTop:    UInt32 = 1 << 0
    let wrapperBlockBottom: UInt32 = 1 << 1
    let wrapperBlockLeft:   UInt32 = 1 << 2
    let wrapperBlockRight:  UInt32 = 1 << 3
    // let wrapperBlockAny:    UInt32 = wrapperBlockTop | wrapperBlockBottom | wrapperBlockLeft | wrapperBlockRight
    let toBeWrapped:        UInt32 = 1 << 4
    
    var ship: Ship! = nil
    
    var leftButton =   SKSpriteNode()
    var rightButton =  SKSpriteNode()
    var thrustButton = SKSpriteNode()
    var fireButton =   SKSpriteNode()
    
        
    var leftPressed:   Bool = false
    var rightPressed:  Bool = false
    var thrustPressed: Bool = false
    var firePressed:   Bool = false
    
    var lastUpdateTime: CFTimeInterval = 0
    
    
    // set up your scene here
    override func didMoveToView(view: SKView) {
        
        // disable diagnostic messages
        // self.view.showsFPS = false
        // self.view.showsNodeCount = false
        self.view?.multipleTouchEnabled = true
        
        // set background color
        backgroundColor = SPACE_COLOR
        
        // set gravity
        physicsWorld.gravity = CGVectorMake(0.0, 0)
        
        // say we want callbacks from SpriteKit
        physicsWorld.contactDelegate = self
        
        // create ship
        ship = Ship(scene: self)
        ship.setPosition(frame.size.width / 2, y: frame.size.height / 2)
        // ship.zRotation += 1.6
        ship.xScale = 1.5
        ship.yScale = 1.5
        
        // add ship to scene
        addChild(ship)
        
        
        // create buttons
        var leftButtonTexture = SKTexture(imageNamed: "left.button.png")
        leftButton = SKSpriteNode(texture: leftButtonTexture)
        leftButton.xScale = 0.75
        leftButton.yScale = 0.75
        leftButton.position = CGPoint(x: self.frame.size.width / 15, y: self.frame.size.height / 2.5)
        leftButton.alpha = 0.4
        
        addChild(leftButton)
        
        var rightButtonTexture = SKTexture(imageNamed: "right.button.png")
        rightButton = SKSpriteNode(texture: rightButtonTexture)
        rightButton.xScale = 0.75
        rightButton.yScale = 0.75
        rightButton.position = CGPoint(x: self.frame.size.width / 6, y: self.frame.size.height / 4.5)
        rightButton.alpha = 0.4
        rightButton.physicsBody = SKPhysicsBody(circleOfRadius: rightButton.size.height / 2)
        rightButton.physicsBody?.dynamic = false
        rightButton.physicsBody?.allowsRotation = false
        
        addChild(rightButton)
        
        thrustButton = SKSpriteNode(texture: leftButtonTexture)
        thrustButton.xScale = 0.75
        thrustButton.yScale = 0.75
        thrustButton.position = CGPoint(x: self.frame.size.width - self.frame.size.width / 15, y: self.frame.size.height / 2.5)
        thrustButton.alpha = 0.4
        
        addChild(thrustButton)
        
        fireButton = SKSpriteNode(texture: rightButtonTexture)
        fireButton.xScale = 0.75
        fireButton.yScale = 0.75
        fireButton.position = CGPoint(x: self.frame.size.width - self.frame.size.width / 6, y: self.frame.size.height / 4.5)
        fireButton.alpha = 0.4
        fireButton.physicsBody = SKPhysicsBody(circleOfRadius: fireButton.size.height / 2)
        fireButton.physicsBody?.dynamic = false
        fireButton.physicsBody?.allowsRotation = false

        addChild(fireButton)
        
        /*
        // test
        
        var asteroid = Asteroid(scene: self, type: 1)
        asteroid.setPosition(frame.size.width / 2 - 20, y: frame.size.height / 2 - 20)
        asteroid.setSpeed(-50, dy: -5)
        addChild(asteroid)
        
        var asteroid2 = Asteroid(scene: self, type: 2)
        asteroid2.setPosition(frame.size.width / 2 + 20 , y: frame.size.height / 2 - 20)
        asteroid2.setSpeed(20, dy: -25)
        asteroid.physicsBody?.applyAngularImpulse(0.01)
        addChild(asteroid2)
        
        var asteroid3 = Asteroid(scene: self, type: 3)
        asteroid3.setPosition(frame.size.width / 2 - 20, y: frame.size.height / 2 + 20)
        asteroid3.setSpeed(-20, dy: 25)
        asteroid.physicsBody?.applyAngularImpulse(-0.06)
        addChild(asteroid3)
        
        var alienShip = AlienShip(scene: self, type: 1)
        alienShip.setPosition(frame.size.width / 2 + 20, y: frame.size.height / 2)
        alienShip.setSpeed(350, dy: 0)
        addChild(alienShip)
        */
        
        // create wrapping nodes
        var contactNodeRight = SKNode()
        contactNodeRight.position = CGPointMake(frame.size.width + ship.size.width, frame.size.height / 2)
        contactNodeRight.physicsBody = SKPhysicsBody(rectangleOfSize: CGSizeMake(100, frame.size.height + 100))
        contactNodeRight.physicsBody?.dynamic = false
        contactNodeRight.physicsBody?.categoryBitMask = wrapperBlockRight
        contactNodeRight.physicsBody?.contactTestBitMask = toBeWrapped

        addChild(contactNodeRight)
        
        var contactNodeLeft = SKNode()
        contactNodeLeft.position = CGPointMake(0 - ship.size.width, frame.size.height / 2)
        contactNodeLeft.physicsBody = SKPhysicsBody(rectangleOfSize: CGSizeMake(100, frame.size.height + 100))
        contactNodeLeft.physicsBody?.dynamic = false
        contactNodeLeft.physicsBody?.categoryBitMask = wrapperBlockLeft
        contactNodeLeft.physicsBody?.contactTestBitMask = toBeWrapped
        
        addChild(contactNodeLeft)
        
        var contactNodeTop = SKNode()
        contactNodeTop.position = CGPointMake(frame.size.width / 2, frame.size.height + ship.size.height)
        contactNodeTop.physicsBody = SKPhysicsBody(rectangleOfSize: CGSizeMake(frame.size.width + 100, 100))
        contactNodeTop.physicsBody?.dynamic = false
        contactNodeTop.physicsBody?.categoryBitMask = wrapperBlockTop
        contactNodeTop.physicsBody?.contactTestBitMask = toBeWrapped
        
        addChild(contactNodeTop)
        
        var contactNodeBottom = SKNode()
        contactNodeBottom.position = CGPointMake(frame.size.width / 2, 0 - ship.size.height)
        contactNodeBottom.physicsBody = SKPhysicsBody(rectangleOfSize: CGSizeMake(frame.size.width + 100, 100))
        contactNodeBottom.physicsBody?.dynamic = false
        contactNodeBottom.physicsBody?.categoryBitMask = wrapperBlockBottom
        contactNodeBottom.physicsBody?.contactTestBitMask = toBeWrapped
        
        addChild(contactNodeBottom)
    }

    func didBeginContact(contact: SKPhysicsContact!) {
        if ((contact.bodyA.categoryBitMask & (wrapperBlockTop | wrapperBlockBottom | wrapperBlockLeft | wrapperBlockRight)) != 0) || ((contact.bodyB.categoryBitMask & (wrapperBlockTop | wrapperBlockBottom | wrapperBlockLeft | wrapperBlockRight)) != 0) {
            if (contact.bodyA.categoryBitMask == wrapperBlockTop) || (contact.bodyB.categoryBitMask == wrapperBlockTop) {
                ship.position.y -= (frame.size.height / 2)
                ship.physicsBody?.velocity = CGVectorMake(0, 0)
                println("HIT IT")
            }
        }
    }//
    //  GameScene.swift
    //  Flappy Bird
    //
    //  Created by Andre on 7/28/14.
    //  Copyright (c) 2015 LucasSoft. All rights reserved.
    //
    
    import SpriteKit
    
    class GameScene: SKScene, SKPhysicsContactDelegate {
        
        var waitingToStart = true
        var bird = SKSpriteNode()
        var altitudeControllerBar = SKSpriteNode()
        var skyColor = SKColor()
        var verticalPipeGap = 130.0
        var pipeTexture1 = SKTexture()
        var pipeTexture2 = SKTexture()
        var moveAndRemovePipes = SKAction()
        
        let birdCategory: UInt32 = 1 << 0
        let worldCategory: UInt32 = 1 << 1
        let pipeCategory: UInt32 = 1 << 2
        let scoreCategory: UInt32 = 1 << 3
        
        var world = SKNode()
        var overlay = SKNode()
        var moving = SKNode()
        var pipes = SKNode()
        
        
        var scoreLabelNode = SKLabelNode()
        var score = NSInteger()
        
        var beginLabelNode = SKLabelNode()
        
        var gameOverLabelNode = SKLabelNode()
        
        
        // Gets called when window moves, and also once at the very beginning
        // Since the window doesn't move, this code will execute exactly once
        override func didMoveToView(view: SKView) {
            
            self.anchorPoint = CGPoint(x: 0.5, y: 0.5)
            
            // add world child
            self.addChild(world)
            self.addChild(overlay)
            
            // disable diagnostic messages
            self.view!.showsFPS = false
            self.view!.showsNodeCount = false
            
            // add children to hold moving ground/sky and pipes
            world.addChild(moving)
            moving.addChild(pipes)
            
            // set gravity
            self.physicsWorld.gravity = CGVectorMake(0.0, -9.8)
            
            // say we want callbacks from SpriteKit
            self.physicsWorld.contactDelegate = self
            
            // Set background color
            skyColor = SKColor(red: 113.0/255.0, green: 197.0/255.0, blue: 207.0/255.0, alpha: 1.0)
            self.backgroundColor = skyColor
            
            // Create two bird pictures
            var birdTexture1 = SKTexture(imageNamed: "Bird1")
            // Don't smooth bitmap so it looks oldschool
            birdTexture1.filteringMode = SKTextureFilteringMode.Nearest
            var birdTexture2 = SKTexture(imageNamed: "Bird2")
            birdTexture2.filteringMode = SKTextureFilteringMode.Nearest
            
            // Create bird animation using both birds, and repeat it forever
            var animation = SKAction.animateWithTextures([birdTexture1, birdTexture2],timePerFrame: 0.2)
            var flap = SKAction.repeatActionForever(animation)
            
            // Create bird sprite, set it to the correct position and animate it
            bird = SKSpriteNode(texture: birdTexture1)
            bird.position = CGPoint(x: self.frame.size.width / 2.8 , y: CGRectGetMidY(self.frame))
            bird.runAction(flap)
            
            bird.physicsBody = SKPhysicsBody(circleOfRadius: bird.size.height / 2.0)
            bird.physicsBody?.dynamic = true
            bird.physicsBody?.allowsRotation = false
            
            bird.physicsBody?.categoryBitMask = birdCategory
            bird.physicsBody?.collisionBitMask = worldCategory | pipeCategory
            bird.physicsBody?.contactTestBitMask = worldCategory | pipeCategory
            
            // Add bird to window
            world.addChild(bird)
            
            // Create ground picture
            var groundTexture = SKTexture(imageNamed: "Ground")
            groundTexture.filteringMode = SKTextureFilteringMode.Nearest
            
            // Create a sequence of two actions: the first moves the ground to the left smoothly until the ground moves by the width of the ground bitmap. Next the second action will execute, with 0 duration to move back to the originial starting point and repeat all this forever
            var moveGroundSprite = SKAction.moveByX(-groundTexture.size().width - 675, y: 0, duration: NSTimeInterval(0.008 * groundTexture.size().width))
            var resetGroundSprite = SKAction.moveByX(groundTexture.size().width + 675, y: 0, duration: 0.0)
            var moveGroundSpriteForever = SKAction.repeatActionForever(SKAction.sequence([moveGroundSprite, resetGroundSprite]))
            
            // Create several ground sprites on screen and run scrolling animation on each one
            for var i: CGFloat = 0; i < (30 + self.frame.size.width / (groundTexture.size().width)); ++i {
                var sprite = SKSpriteNode(texture: groundTexture)
                sprite.position = CGPointMake(i * sprite.size.width, -280 /* origin of bitmap is its center */)
                sprite.runAction(moveGroundSpriteForever)
                moving.addChild(sprite)
            }
            
            // create an (invisible) node that represents the ground
            var dummy = SKNode()
            dummy.position = CGPointMake(0, -280)
            dummy.physicsBody = SKPhysicsBody(rectangleOfSize: CGSizeMake(self.frame.size.width, groundTexture.size().height))
            dummy.physicsBody?.dynamic = false
            dummy.physicsBody?.categoryBitMask = worldCategory
            dummy.physicsBody?.collisionBitMask = birdCategory
            dummy.physicsBody?.contactTestBitMask = birdCategory
            
            world.addChild(dummy)
            
            // Create skyline picture
            var skylineTexture = SKTexture(imageNamed: "Skyline")
            skylineTexture.filteringMode = SKTextureFilteringMode.Nearest
            
            // Create a sequence of two actions: the first moves the skyline to the left smoothly until the skyline moves by the width of the skyline bitmap. Next the second action will execute, with 0 duration to move back to the originial starting point and repeat all this forever
            var moveSkylineSprite = SKAction.moveByX(-skylineTexture.size().width, y: 0, duration: NSTimeInterval(0.1 * skylineTexture.size().width))
            var resetSkylineSprite = SKAction.moveByX(skylineTexture.size().width, y: 0, duration: 0.0)
            var moveSkylineSpriteForever = SKAction.repeatActionForever(SKAction.sequence([moveSkylineSprite, resetSkylineSprite]))
            
            // Create several skyline sprites on screen and run scrolling animation on each
            for var i: CGFloat = 0; i < (2 + self.frame.size.width / (skylineTexture.size().width)); ++i {
                var sprite = SKSpriteNode(texture: skylineTexture)
                sprite.zPosition = -20
                sprite.position = CGPointMake(i * sprite.size.width, -290 /* origin of bitmap is its center */ + groundTexture.size().height)
                sprite.runAction(moveSkylineSpriteForever)
                moving.addChild(sprite)
            }
            
            // Create two pipe pictures
            pipeTexture1 = SKTexture(imageNamed: "Pipe1")
            pipeTexture1.filteringMode = SKTextureFilteringMode.Nearest
            pipeTexture2 = SKTexture(imageNamed: "Pipe2")
            pipeTexture2.filteringMode = SKTextureFilteringMode.Nearest
            
            // create action sequence to move a pipe pair across the screen and then remove the action when done
            var distanceToMove = CGFloat(self.frame.size.width + (2.0 * pipeTexture1.size().width))
            var movePipes = SKAction.moveByX(-distanceToMove, y: 0.0, duration: NSTimeInterval(0.008 * distanceToMove))
            var removePipes = SKAction.removeFromParent()
            moveAndRemovePipes = SKAction.sequence([movePipes, removePipes])
            
            // create action sequence to spawn pipes
            // var spawn = SKAction.runBlock({() in self.spawnPipes()})
            // var delay = SKAction.waitForDuration(NSTimeInterval(1.5))
            // var spawnThenDelay = SKAction.sequence([spawn, delay])
            // var spawnThenDelayForever = SKAction.repeatActionForever(spawnThenDelay)
            // moving.runAction(spawnThenDelayForever)
            
            // create score label
            score = 0
            scoreLabelNode.fontName = "AmericanTypewriter-Bold"
            scoreLabelNode.position = CGPointMake(CGRectGetMidX(self.frame), self.frame.height * (5/6))
            scoreLabelNode.fontSize = 50
            scoreLabelNode.alpha = 1.0
            scoreLabelNode.zPosition = -1
            scoreLabelNode.text = "\(score)"
            
            world.addChild(scoreLabelNode)
            
            // create tap to begin label
            beginLabelNode.fontName = "AmericanTypewriter-Bold"
            beginLabelNode.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame) * (3/2))
            beginLabelNode.fontSize = 50
            beginLabelNode.alpha = 1
            beginLabelNode.zPosition = 0
            beginLabelNode.text = "Tap to Begin"
            
            // create action sequence to blink start message and run it
            createBlinkyStart()
            
            // create game over label
            gameOverLabelNode.fontName = "AmericanTypewriter-Bold"
            gameOverLabelNode.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame) * (3/2))
            gameOverLabelNode.fontSize = 35
            gameOverLabelNode.alpha = 1
            gameOverLabelNode.zPosition = 0
            
            var altitudeControllerBar = SKSpriteNode(imageNamed: "pipe1.png")
            altitudeControllerBar.anchorPoint = (0.0, 0.0)
            altitudeControllerBar.position = CGPoint(x: -(self.frame.size.width / 2), y: self.frame.size.height / 2)
            altitudeControllerBar.physicsBody = SKPhysicsBody(rectangleOfSize: CGSize(width: self.frame.size.width / 10, height: self.frame.size.height))
            altitudeControllerBar.physicsBody?.affectedByGravity = false
            
            overlay.addChild(altitudeControllerBar)
            
            
            var tiltControllerBar = SKSpriteNode(imageNamed: "pipe2.png")
            tiltControllerBar.anchorPoint = (0.0, 0.0)
            tiltControllerBar.position = CGPoint(x: self.frame.size.width / 2, y: self.frame.size.height / 2)
            tiltControllerBar.physicsBody = SKPhysicsBody(rectangleOfSize: CGSize(width: self.frame.size.width / 10, height: self.frame.size.height))
            altitudeControllerBar.physicsBody?.affectedByGravity = false
            
            overlay.addChild(altitudeControllerBar)
            
            // freeze game (we will start when the screen is tapped)
            self.freezeGame(true)
        }
        
        func createBlinkyStart() {
            var addBeginLabelAction = SKAction.runBlock({() in self.addBeginLabel()})
            var killBeginLabelAction = SKAction.runBlock({() in self.killBeginLabel()})
            var delay1 = SKAction.waitForDuration(0.5)
            var blinker = SKAction.sequence([addBeginLabelAction, delay1, killBeginLabelAction, delay1])
            var blinkForeverAction = SKAction.repeatActionForever(blinker)
            self.runAction(blinkForeverAction, withKey: "blinky")
        }
        
        func addBeginLabel() {
            world.addChild(beginLabelNode)
        }
        
        func killBeginLabel() {
            beginLabelNode.removeFromParent()
        }
        
        func freezeGame(doFreeze: Bool) {
            if doFreeze == true {
                moving.speed = 1
                bird.speed = 0
                bird.physicsBody?.dynamic = false
            } else {
                moving.speed = 1
                bird.speed = 1
                bird.physicsBody?.dynamic = true
            }
        }
        
        /*
        func spawnPipes() {
        if waitingToStart == true { return }
        
        var pipePair = SKNode()
        var startX = self.frame.size.width + pipeTexture1.size().width * 2.0
        startX = startX * (2/3)
        pipePair.position = CGPointMake(startX, 0)
        pipePair.zPosition = -10
        
        // debug
        // println("frame width = \(self.frame.size.width)")
        // println("frame height = \(self.frame.size.height)")
        
        var height = UInt(self.frame.height / 3)
        var y = UInt(arc4random()) % height
        
        // create lower pipe sprite
        var pipe1 = SKSpriteNode(texture: pipeTexture1)
        pipe1.position = CGPointMake(0.0, CGFloat(y))
        pipe1.physicsBody = SKPhysicsBody(rectangleOfSize: pipe1.size)
        pipe1.physicsBody?.dynamic = false
        pipe1.physicsBody?.categoryBitMask = pipeCategory
        pipe1.physicsBody?.contactTestBitMask = birdCategory
        pipePair.addChild(pipe1)
        
        // create upper pipe sprite
        var pipe2 = SKSpriteNode(texture: pipeTexture2)
        pipe2.position = CGPointMake(0.0, CGFloat(y) + pipe1.size.height + CGFloat(verticalPipeGap))
        pipe2.physicsBody = SKPhysicsBody(rectangleOfSize: pipe2.size)
        pipe2.physicsBody?.dynamic = false
        pipe2.physicsBody?.categoryBitMask = pipeCategory
        pipe2.physicsBody?.contactTestBitMask = birdCategory
        pipePair.addChild(pipe2)
        
        // create invisible object that is used to detect when the bird went past some pipes so we can add a point to the score
        var contactNode = SKNode()
        contactNode.position = CGPointMake(pipe1.size.width + bird.size.width / 2, CGRectGetMidY(self.frame))
        contactNode.physicsBody = SKPhysicsBody(rectangleOfSize: CGSizeMake(pipe1.size.width, self.frame.size.height))
        contactNode.physicsBody?.dynamic = false
        contactNode.physicsBody?.categoryBitMask = scoreCategory
        contactNode.physicsBody?.contactTestBitMask = birdCategory
        pipePair.addChild(contactNode)
        
        // add action to pipe pair to move it
        pipePair.runAction(moveAndRemovePipes)
        
        // add pipe pair to scene
        pipes.addChild(pipePair)
        }
        */
        
        func resetScene() {
            
            // move bird back to starting position
            bird.position = CGPoint(x: self.frame.size.width / 2.8, y: CGRectGetMidY(self.frame))
            bird.physicsBody?.velocity = CGVectorMake(0.0, 0.0)
            bird.physicsBody?.collisionBitMask = worldCategory | pipeCategory
            bird.speed = 1.0
            bird.zRotation = 0.0
            
            // destroy all pipes
            pipes.removeAllChildren()
            
            // reset score
            score = 0
            scoreLabelNode.text = "\(score)"
            
            // remove game over message
            gameOverLabelNode.removeFromParent()
            
            // start "tap to begin" message
            createBlinkyStart()
            
            // freeze game and remember we're waiting for a tap to start
            waitingToStart = true
            self.freezeGame(true)
        }
        
        // Called when a touch begins
        override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
            if waitingToStart == true {
                // we were waiting to start - launch the game
                self.freezeGame(false)
                waitingToStart = false
                // stop blinking start message and call killBeginLabel() in case we interrupted the action with the label still showing
                self.removeActionForKey("blinky")
                killBeginLabel()
            }
            
            for touch: AnyObject in touches {
                // check if in left button
                let location = touch.locationInNode(self)
                let touchedNode = nodeAtPoint(location)
                
                if touchedNode == altitudeControllerBar {
                    bird.physicsBody?.applyImpulse(CGVectorMake(100, 100))
                }
            }
            // say something changed
            // buttonsChanged()
            
            if moving.speed > 0 {
                bird.physicsBody?.velocity = CGVectorMake(0, 0)
                bird.physicsBody?.applyImpulse(CGVectorMake(5, 9))
            }
        }
        
        func clamp(min: CGFloat, max: CGFloat, value: CGFloat) -> CGFloat {
            if value > max { return max }
            else if value < min { return min }
            else { return value }
        }
        
        func didBeginContact(contact: SKPhysicsContact!) {
            
            if moving.speed > 0 {
                
                if ((contact.bodyA.categoryBitMask & scoreCategory) == scoreCategory) || ((contact.bodyB.categoryBitMask & scoreCategory) == scoreCategory) {
                    
                    // one of the objects that collided was of type scoreCategory - that means we hit our hidden object used to detect
                    // when to increase the score
                    
                    score++
                    scoreLabelNode.text = "\(score)"
                    
                } else {
                    
                    // bird hit something
                    
                    // stop moving things
                    moving.speed = 0
                    
                    // allow bird to fall thru pipes
                    bird.physicsBody?.collisionBitMask = worldCategory
                    
                    // make bird spin and fall then stop
                    var rotateBird = SKAction.rotateByAngle(0.01, duration: 0.003)
                    var stopBird = SKAction.runBlock({() in self.killBirdSpeed()})
                    var birdSequence = SKAction.sequence([rotateBird, stopBird])
                    bird.runAction(birdSequence)
                    
                    // flash background, show game over, wait a bit, then restart game
                    self.removeActionForKey("flash")
                    var turnBackgroundRed = SKAction.runBlock({() in self.setBackgroundRed()})
                    var wait = SKAction.waitForDuration(0.05)
                    var turnBackgroundWhite = SKAction.runBlock({() in self.setBackgroundColorWhite()})
                    var turnBackgroundColorSky = SKAction.runBlock({() in self.setBackgroundColorSky()})
                    var sequenceOfActions = SKAction.sequence([turnBackgroundRed, wait, turnBackgroundWhite, wait, turnBackgroundColorSky])
                    var repeatSequence = SKAction.repeatAction(sequenceOfActions, count: 4)
                    var delay = SKAction.waitForDuration(2)
                    var restartAction = SKAction.runBlock({() in self.resetScene()})
                    var showGameOverAction = SKAction.runBlock({() in self.showGameOver()})
                    var sequenceOfActions2 = SKAction.sequence([repeatSequence, showGameOverAction, delay, restartAction])
                    
                    self.runAction(sequenceOfActions2, withKey: "flash")
                }
            }
        }
        
        func showGameOver() {
            gameOverLabelNode.text = "GAME OVER Score: \(score)"
            world.addChild(gameOverLabelNode)
        }
        
        func killBirdSpeed() {
            bird.speed = 0
        }
        
        func setBackgroundRed() {
            self.backgroundColor = UIColor.redColor()
        }
        
        func setBackgroundColorWhite() {
            self.backgroundColor = UIColor.whiteColor()
        }
        
        func setBackgroundColorSky() {
            self.backgroundColor = SKColor(red: 113.0/255.0, green: 197.0/255.0, blue: 207.0/255.0, alpha: 1.0)
        }
        
        // Called before each frame is rendered (drawn on screen)
        
        override func update(currentTime: CFTimeInterval) {
            
            // The x axis goes horizontally, the y axis goes vertically, and the z axis is coming out of your screen. The rotation is thought of as twisting a particular axis. Z Rotation means twisting the z axis which rotates the x, y plane
            
            // The angle we draw the bird is related to how fast it's falling/rising. The faster it moves, the more tilted the bird becomes.
            // If it's going up, we set the angle to 0.001 times its vertical speed. If it's going down, we set it to 0.003 times its
            // vertical speed.
            
            var newAngle: CGFloat = bird.physicsBody!.velocity.dy * (bird.physicsBody?.velocity.dy < 0 ? 0.003 : 0.001)
            if moving.speed > 0 {
                bird.zRotation = self.clamp(-1, max: 0.5, value: newAngle)
            }
        }
        
        override func didSimulatePhysics() {
            self.centerOnNodeX(self.bird)
        }
        
        func centerOnNodeX(node: SKNode) {
            let cameraPositionInScene: CGPoint? = node.scene?.convertPoint(node.position, fromNode: node.parent!)
            
            node.parent?.position.x = node.parent!.position.x - cameraPositionInScene!.x
        }
    }
    
    
    
    
    
    
    
    
    
    
    
    Asteroids
    
    func buttonsChanged() {
        
        if (leftPressed || rightPressed) {
            if (leftPressed) {
                ship.physicsBody?.angularVelocity = 3
            } else {
                ship.physicsBody?.angularVelocity = -3
            }
        } else {
            ship.physicsBody?.angularVelocity = 0
        }
    }
    
    // Called when a touch begins
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        for touch: AnyObject in touches {
            // check if in left button
            let location = touch.locationInNode(self)
            let touchedNode = nodeAtPoint(location)
            
            if touchedNode == leftButton {
                leftPressed = true
            } else if touchedNode == rightButton {
                rightPressed = true
            } else if touchedNode == thrustButton {
                thrustPressed = true
            } else if touchedNode == fireButton {
                firePressed = true
            }
        }
        // say something changed
        buttonsChanged();
    }
    
    // called when a touch ends
    override func touchesEnded(touches: NSSet!, withEvent event: UIEvent!) {
        for touch: AnyObject in touches {
            // check if in left button
            let location = touch.locationInNode(self)
            let touchedNode = nodeAtPoint(location)
            
            if touchedNode == leftButton {
                leftPressed = false
            } else if touchedNode == rightButton {
                rightPressed = false
            } else if touchedNode == thrustButton {
                thrustPressed = false
            } else if touchedNode == fireButton {
                firePressed = false
            }
        }
        // say something changed
        buttonsChanged();
    }
    
    // called before each frame is rendered
    override func update(currentTime: CFTimeInterval) {
        if (thrustPressed) {
            let thrustForce:CGFloat = 3000
            var elapsedTime:CFTimeInterval = currentTime - lastUpdateTime
            var direction:CGFloat = ship.zRotation
            ship.applyThrust(direction, force: thrustForce, timeInterval: elapsedTime)
        }
        lastUpdateTime = currentTime
    }
}



