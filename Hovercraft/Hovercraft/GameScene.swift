//
//  GameScene.swift
//  Hovercraft
//
//  Created by Lucas Sant'Anna on 2/4/15.
//  Copyright (c) 2015 Lucas Sant'Anna. All rights reserved.
//

import SpriteKit

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    var waitingToStart = true
    var hovercraft = SKSpriteNode()
    var altitudeControllerBar = SKSpriteNode()
    var tiltControllerBar = SKSpriteNode()
    var pauseButton = SKSpriteNode()
    var pauseScreen = SKSpriteNode()
    var characterSelectButton = SKSpriteNode()
    var levelSelectButton = SKSpriteNode()
    var resumeButton = SKSpriteNode()
    var backgroundClr = SKColor()
    var moveAndRemovePipes = SKAction()
    var isCreated = false
    var began = false
    var propForce = CGVectorMake(0, 9.8)
    var multiTouch:[String:UITouch] = [String:UITouch]()
    var altLocation: CGPoint? = nil
    var tiltLocation: CGPoint? = nil
    var globals: GameGlobals = GameGlobals()
    var level: Level! = nil
    var charID: String! = nil
    var levelID: String! = nil
    var image: UIImage! = nil
    var context: CGContext! = nil
    var crashed = false
    var dX: CGFloat = 0
    var canReset = false
    var dY: CGFloat = 0
    var landed = false
    
    var world = SKNode()
    var overlay = SKNode()
    var moving = SKNode()
    
    var scoreLabelNode = SKLabelNode()
    var score = NSInteger()
    
    var touchBeganAlt = false
    var touchBeganTilt = false
    
    init(levelID: String, charID: String) {
        self.levelID = levelID
        self.charID = charID
        super.init(size: CGSizeMake(1024, 768))
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // Gets called when window moves, and also once at the very beginning
    // Since the window doesn't move, this code will execute exactly once
    override func didMoveToView(view: SKView) {
        
        if !isCreated {
            isCreated = true
        } else {
            println("called twice")
        }
        
        self.anchorPoint = CGPoint(x: 0.5, y: 0.5)

        // add world child
        world.name = "world"
        world.zPosition = 0
        overlay.name = "overlay"
        overlay.zPosition = 10
        self.addChild(world)
        self.addChild(overlay)
        
        self.addChild(moving)
        // disable diagnostic messages
        self.view!.showsFPS = false
        self.view!.showsNodeCount = false
        
        // set gravity, values multiplied by 150 by SpriteKit
        self.physicsWorld.gravity = CGVectorMake(0.0, -500 / 150)
        
        image = UIImage(named: globals.levels[levelID]!.bitmapName)
        context = Level.createBitmapContext(image!.CGImage)
        
        // say we want callbacks from SpriteKit
        self.physicsWorld.contactDelegate = self
        
        // Set background color
        backgroundClr = globals.levels[levelID]!.backgroundColor
        self.backgroundColor = backgroundClr
        
        // Create two hovercraft pictures
        var hovercraftTexture1 = SKTexture(imageNamed: globals.chars[charID]!.firstBitmapName)
        // Don't smooth bitmap so it looks oldschool
        hovercraftTexture1.filteringMode = SKTextureFilteringMode.Nearest
        var hovercraftTexture2 = SKTexture(imageNamed: globals.chars[charID]!.secondBitmapName)
        hovercraftTexture2.filteringMode = SKTextureFilteringMode.Nearest
        var hovercraftTexture3: SKTexture? = nil
        var hovercraftTexture4: SKTexture? = nil
        if globals.chars[charID]!.thirdBitmapName != nil {
            hovercraftTexture3 = SKTexture(imageNamed: globals.chars[charID]!.thirdBitmapName!)
            hovercraftTexture3!.filteringMode = SKTextureFilteringMode.Nearest
        }
        if globals.chars[charID]!.fourthBitmapName != nil {
            hovercraftTexture4 = SKTexture(imageNamed: globals.chars[charID]!.fourthBitmapName!)
            hovercraftTexture4!.filteringMode = SKTextureFilteringMode.Nearest
        }
        
        var animation: SKAction! = nil
        // Create hovercraft animation using both hovercrafts, and repeat it forever
        if globals.chars[charID]!.thirdBitmapName != nil  {
            animation = SKAction.animateWithTextures([hovercraftTexture1, hovercraftTexture2,hovercraftTexture3!], timePerFrame: NSTimeInterval(globals.chars[charID]!.timePerFrame))
        } else {
            animation = SKAction.animateWithTextures([hovercraftTexture1, hovercraftTexture2], timePerFrame: NSTimeInterval(globals.chars[charID]!.timePerFrame))
        }
        if globals.chars[charID]!.fourthBitmapName != nil {
            animation = SKAction.animateWithTextures([hovercraftTexture1, hovercraftTexture2,hovercraftTexture3!, hovercraftTexture4!, hovercraftTexture3!, hovercraftTexture4!], timePerFrame: NSTimeInterval(globals.chars[charID]!.timePerFrame))
        }
        var spin = SKAction.repeatActionForever(animation)
        
        // Create hovercraft sprite, set it to the correct position and animate it
        hovercraft = SKSpriteNode(texture: hovercraftTexture1)
        hovercraft.position = globals.levels[levelID]!.startingPoint
        hovercraft.position.y += globals.chars[charID]!.distanceFromStartPoint
        hovercraft.size = globals.chars[charID]!.size
        hovercraft.physicsBody = SKPhysicsBody(rectangleOfSize: CGSize(width: hovercraft.size.width, height: hovercraft.size.height))
        hovercraft.physicsBody?.dynamic = true
        hovercraft.physicsBody?.allowsRotation = true
        hovercraft.physicsBody?.affectedByGravity = true
        hovercraft.physicsBody?.mass = 1
        hovercraft.runAction(spin)
        
        // Add hovercraft to window
        world.addChild(hovercraft)

        /*
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
        */
        // create action sequence to spawn pipes
        // var spawn = SKAction.runBlock({() in self.spawnPipes()})
        // var delay = SKAction.waitForDuration(NSTimeInterval(1.5))
        // var spawnThenDelay = SKAction.sequence([spawn, delay])
        // var spawnThenDelayForever = SKAction.repeatActionForever(spawnThenDelay)
        // moving.runAction(spawnThenDelayForever)
        
        
        var altitudeControllerBarPic = SKSpriteNode(imageNamed: "controlBar.png")
        altitudeControllerBarPic.alpha = 0.07
        altitudeControllerBarPic.anchorPoint = CGPoint(x: 0.0, y: 0.0)
        altitudeControllerBarPic.position = CGPoint(x: -(self.frame.size.width / 2), y: -(self.frame.size.height / 2))
        altitudeControllerBarPic.size = CGSize(width: altitudeControllerBarPic.size.width * 2.25, height: altitudeControllerBarPic.size.height * 8)
        altitudeControllerBarPic.zPosition = 20
        
        overlay.addChild(altitudeControllerBarPic)
        
        altitudeControllerBar.anchorPoint = CGPoint(x: 0.0, y: 0.0)
        altitudeControllerBar.position = CGPoint(x: -(self.frame.size.width / 2), y: -(self.frame.size.height / 2))
        altitudeControllerBar.size = CGSize(width: altitudeControllerBarPic.size.width * (2/3), height: altitudeControllerBarPic.size.height * 8)
        altitudeControllerBar.zPosition = 25
        
        overlay.addChild(altitudeControllerBar)
        
        var tiltControllerBarPic = SKSpriteNode(imageNamed: "controlBarRight.png")
        tiltControllerBarPic.alpha = 0.07
        tiltControllerBarPic.anchorPoint = CGPoint(x: 1.0, y: 0.0)
        tiltControllerBarPic.position = CGPoint(x: self.frame.size.width / 2, y: -(self.frame.size.height / 2))
        tiltControllerBarPic.size = CGSize(width: tiltControllerBarPic.size.width * 2.25, height: tiltControllerBarPic.size.height * 8)
        tiltControllerBarPic.zPosition = 20
        
        overlay.addChild(tiltControllerBarPic)
        
        tiltControllerBar.alpha = 0.07
        tiltControllerBar.anchorPoint = CGPoint(x: 1.0, y: 0.0)
        tiltControllerBar.position = CGPoint(x: self.frame.size.width / 2, y: -(self.frame.size.height / 2))
        tiltControllerBar.size = CGSize(width: tiltControllerBarPic.size.width * (2/3), height: tiltControllerBarPic.size.height * 8)
        tiltControllerBar.zPosition = 25
        
        overlay.addChild(tiltControllerBar)
        
        pauseButton.texture = SKTexture(imageNamed: "pauseButton.png")
        pauseButton.anchorPoint = CGPoint(x: 0.5, y: 1.0)
        pauseButton.position = CGPoint(x: 0, y: 275)
        pauseButton.size = CGSize(width: 32 * 2, height: 32 * 2)
        pauseButton.zPosition = 25
        pauseButton.alpha = 0.3
        
        overlay.addChild(pauseButton)
        
        pauseScreen.texture = SKTexture(imageNamed: "pauseScreen.png")
        pauseScreen.position = CGPoint(x: 0, y: 0)
        pauseScreen.size = CGSize(width: 1024, height: 576)
        pauseScreen.zPosition = 100
        
        resumeButton.texture = SKTexture(imageNamed: "resumeButton.png")
        resumeButton.position = CGPoint(x: 0, y: 0)
        resumeButton.size = CGSize(width: 64, height: 64)
        resumeButton.zPosition = 101
        
        
        var background = SKSpriteNode(imageNamed: globals.levels[levelID]!.bitmapName)
        background.anchorPoint = CGPointMake(0.0, 0.0)
        background.size = globals.levels[levelID]!.size
        background.position = CGPointMake(0, 0)
        background.zPosition = -100
        background.texture?.filteringMode = SKTextureFilteringMode.Nearest
        
        world.addChild(background)
        
        // freeze game (we will start when the screen is tapped)
        self.freezeGame(true)
    }
    
    func freezeGame(doFreeze: Bool) {
        if doFreeze == true {
            moving.speed = 1
            hovercraft.speed = 0
            hovercraft.physicsBody?.dynamic = false
        } else {
            moving.speed = 1
            hovercraft.speed = 1
            hovercraft.physicsBody?.dynamic = true
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
    pipe1.physicsBody?.contactTestBitMask = hovercraftCategory
    pipePair.addChild(pipe1)
    
    // create upper pipe sprite
    var pipe2 = SKSpriteNode(texture: pipeTexture2)
    pipe2.position = CGPointMake(0.0, CGFloat(y) + pipe1.size.height + CGFloat(verticalPipeGap))
    pipe2.physicsBody = SKPhysicsBody(rectangleOfSize: pipe2.size)
    pipe2.physicsBody?.dynamic = false
    pipe2.physicsBody?.categoryBitMask = pipeCategory
    pipe2.physicsBody?.contactTestBitMask = hovercraftCategory
    pipePair.addChild(pipe2)
    
    // create invisible object that is used to detect when the hovercraft went past some pipes so we can add a point to the score
    var contactNode = SKNode()
    contactNode.position = CGPointMake(pipe1.size.width + hovercraft.size.width / 2, CGRectGetMidY(self.frame))
    contactNode.physicsBody = SKPhysicsBody(rectangleOfSize: CGSizeMake(pipe1.size.width, self.frame.size.height))
    contactNode.physicsBody?.dynamic = false
    contactNode.physicsBody?.categoryBitMask = scoreCategory
    contactNode.physicsBody?.contactTestBitMask = hovercraftCategory
    pipePair.addChild(contactNode)
    
    // add action to pipe pair to move it
    pipePair.runAction(moveAndRemovePipes)
    
    // add pipe pair to scene
    pipes.addChild(pipePair)
    }
    */
    
    func resetScene() {
        
        // move hovercraft back to starting position
        hovercraft.physicsBody?.affectedByGravity = true
        hovercraft.position = globals.levels[levelID]!.startingPoint
        hovercraft.physicsBody?.velocity = CGVectorMake(0.0, 0.0)
        hovercraft.speed = 1.0
        hovercraft.zRotation = 0.0
        
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
            
        }
        
        touchOrDrag(touches, withEvent: event)
        
        
        //if moving.speed > 0 {
         //   hovercraft.physicsBody?.velocity = CGVectorMake(0, 0)
         //   hovercraft.physicsBody?.applyImpulse(CGVectorMake(5, 9))
        //}
    }
    
    override func touchesMoved(touches: NSSet, withEvent event: UIEvent) {
        touchOrDrag(touches, withEvent: event)
    }
    
    override func touchesEnded(touches: NSSet, withEvent event: UIEvent) {
        for touch: AnyObject in touches {
            let location = touch.locationInNode(overlay)
            let touchedNode = overlay.nodeAtPoint(location)
            
            if touchedNode == altitudeControllerBar {
                multiTouch["altTouch"] = nil
                propForce = CGVectorMake(0, 0)
                hovercraft.speed = 0
            } else if touchedNode == tiltControllerBar {
                multiTouch["tiltTouch"] = nil
            }
        }
    }
    
    /*
    func didBeginContact(contact: SKPhysicsContact!) {
        
        if moving.speed > 0 {
        } else {
                
                // hovercraft hit something
                
                // stop moving things
                moving.speed = 0
            
                // make hovercraft spin and fall then stop
                var rotatehovercraft = SKAction.rotateByAngle(0.01, duration: 0.003)
                var stophovercraft = SKAction.runBlock({() in self.hovercraft.speed = 0})
                var hovercraftSequence = SKAction.sequence([rotatehovercraft, stophovercraft])
                hovercraft.runAction(hovercraftSequence)
                
            
        }
    }
    */
    
    // Called before each frame is rendered (drawn on screen)
    override func update(currentTime: CFTimeInterval) {
        if !crashed {
            hovercraft.physicsBody?.applyForce(propForce)
        }
        
    }
    
    override func didSimulatePhysics() {
        self.centerOnNodeX(self.hovercraft)
        
        var point = CGPointMake(hovercraft.position.x / (globals.levels[levelID]!.size.width / 512), hovercraft.position.y / (globals.levels[levelID]!.size.height / 512))
        var alpha = Level.getPixelAlphaAtLocation(point, inImage: image!.CGImage, context: context) /*hack*/
        // Level.freeBitmapContext(context) /*this has to happen when we leave this scene*/
        // println(point)
        // println(alpha)
        if !crashed {
            if hovercraft.physicsBody!.velocity.dx < 0 {
                dX = 100
            }
            else {
                dX = -100
            }
        }
        
        if !crashed {
            if hovercraft.physicsBody?.velocity.dy < 0 {
                dY = 100000 / 150
            } else {
                dY = -100000 / 150
            }
            
        }
        
        if alpha == 255 {
            if crashed == false {
                crashed = true
                hovercraft.physicsBody?.affectedByGravity = false
                hovercraft.physicsBody?.angularVelocity = 10
                hovercraft.physicsBody?.velocity = CGVectorMake(dX, dY)
            
            } else if canReset && crashed == true {
                resetScene()
                crashed = false
                canReset = false
            }
        }
        if alpha == 254 && crashed {
            canReset = true
        }
        
        if alpha == 253 && !crashed {
            landed = true
            let skView = self.view! as SKView
            skView.ignoresSiblingOrder = true
            let scene = LevelScene(charID: charID)
            scene.globals = globals
            scene.scaleMode = .AspectFill
            skView.presentScene(scene)
        }
    }

    func centerOnNodeX(node: SKNode) {
        let cameraPositionInScene: CGPoint? = node.scene?.convertPoint(node.position, fromNode: node.parent!)
        
        node.parent?.position = CGPointMake(node.parent!.position.x - cameraPositionInScene!.x, node.parent!.position.y - cameraPositionInScene!.y)
    }
    
    func controllerBars(multiTouch: [String:UITouch]) {
        
        if(multiTouch["altTouch"] != nil) {
            // propForce.dx = 0
            // propForce.dy = 9.8
            var altTouch = multiTouch["altTouch"]
            var half: CGFloat = 288.0
            var shifted = half + altTouch!.locationInNode(overlay).y
            var force = shifted / (half * 2) * 1000
            propForce = CGVectorMakeFromPolar(force, theta: hovercraft.zRotation + CGFloat(M_PI_2))

            // propForce = CGVectorMakeFromPolar(location.y, theta: (location.y / CGFloat(288)) * CGFloat(M_PI_2))
        }
        
        if(multiTouch["tiltTouch"] != nil) {
            var tiltTouch = multiTouch["tiltTouch"]
            var half: CGFloat = 288 // self.frame.size.height / 2
            var angle = Double(tiltTouch!.locationInNode(overlay).y / half) * M_PI_2
            // println("half = \(half)")
            // println("y's location = \(location.y)")
            // println("to: \(view?.convertPoint(location, toScene: self))")
            // println("from: \(view?.convertPoint(location, fromScene: self))")
            if !crashed && !waitingToStart && !landed {
                hovercraft.zRotation = CGFloat(angle)
            }
        }
        
    }
    
    func CGVectorMakeFromPolar(r: CGFloat, theta: CGFloat) -> CGVector {
        var x = r * cos(theta)
        var y = r * sin(theta)
        return CGVectorMake(x, y)
    }
    
    func touchOrDrag(touches: NSSet, withEvent event: UIEvent) {
        var location: CGPoint? = nil
        var touchedNode: SKNode? = nil
        
        for touch: AnyObject in touches {
            location = touch.locationInNode(overlay)
            touchedNode = overlay.nodeAtPoint(location!)
        
            if touchedNode == nil {}
            else {
                switch(touchedNode!)  {
                case altitudeControllerBar:
                    multiTouch["altTouch"] = touch as? UITouch
                    hovercraft.speed = 1
                    break
                case tiltControllerBar:
                    multiTouch["tiltTouch"] = touch as? UITouch
                    break
                case pauseButton:
                    self.freezeGame(true)
                    overlay.addChild(pauseScreen)
                    overlay.addChild(resumeButton)
                    pauseButton.removeFromParent()
                    break
                case resumeButton:
                    self.freezeGame(false)
                    resumeButton.removeFromParent()
                    pauseScreen.removeFromParent()
                    overlay.addChild(pauseButton)
                default:
                    break
                }
            }
          
        }
        // say something changed
        controllerBars(multiTouch)
    }

}