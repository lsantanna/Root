//
//  GameScene.swift
//  Pixel Craft
//
//  Created by Lucas Sant'Anna on 2/4/15.
//  Copyright (c) 2015 Lucas Sant'Anna. All rights reserved.
//

import SpriteKit

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    var globals: GameGlobals = GameGlobals()
    
    var waitingToStart = true
    
    var pixelcraft = SKSpriteNode()
    
    var altitudeControllerBar = SKSpriteNode()
    var tiltControllerBar = SKSpriteNode()
    
    var pauseScreen = SKSpriteNode()
    var pauseButton = SKSpriteNode()
    var restartButton = SKSpriteNode()
    var characterSelectButton = SKSpriteNode()
    var quitButton = SKSpriteNode()
    var resumeButton = SKSpriteNode()
    
    var backgroundClr = SKColor()
    
    var isCreated = false
    
    var propForce = CGVectorMake(0, 9.8)
    
    var multiTouch:[String:UITouch] = [String:UITouch]()
    
    var altLocation: CGPoint? = nil
    var tiltLocation: CGPoint? = nil
    
    var touchBeganAlt = false
    var touchBeganTilt = false
    
    var charID: String! = nil
    var levelID: String! = nil
    
    var image: UIImage! = nil
    var context: CGContext! = nil
    
    var crashed = false
    var canReset = false
    var landed = false
    
    var dX: CGFloat = 0
    var dY: CGFloat = 0
    
    var world = SKNode()
    var overlay = SKNode()
    
    
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
            print("called twice")
        }
        
        self.anchorPoint = CGPoint(x: 0.5, y: 0.5)

        // add world child
        world.name = "world"
        world.zPosition = 0
        self.addChild(world)
        
        overlay.name = "overlay"
        overlay.zPosition = 10
        self.addChild(overlay)
        
        // disable diagnostic messages
        self.view!.showsFPS = false
        self.view!.showsNodeCount = false
        
        // set gravity, values multiplied by 150 by SpriteKit
        self.physicsWorld.gravity = CGVectorMake(0.0, -500 / 150)
        
        image = UIImage(named: globals.levels[levelID]!.bitmapName)
        context = Level.createBitmapContext(image!.CGImage!)
        
        // Set background color
        backgroundClr = globals.levels[levelID]!.backgroundColor
        self.backgroundColor = backgroundClr
        
        // Create two pixelcraft pictures
        let pixelcraftTexture1 = SKTexture(imageNamed: globals.chars[charID]!.firstBitmapName)
        // Don't smooth bitmap so it looks oldschool
        pixelcraftTexture1.filteringMode = SKTextureFilteringMode.Nearest
        
        let pixelcraftTexture2 = SKTexture(imageNamed: globals.chars[charID]!.secondBitmapName)
        pixelcraftTexture2.filteringMode = SKTextureFilteringMode.Nearest
        
        var pixelcraftTexture3: SKTexture? = nil
        
        var pixelcraftTexture4: SKTexture? = nil
        
        if globals.chars[charID]!.thirdBitmapName != nil {
            pixelcraftTexture3 = SKTexture(imageNamed: globals.chars[charID]!.thirdBitmapName!)
            pixelcraftTexture3!.filteringMode = SKTextureFilteringMode.Nearest
        }
        
        if globals.chars[charID]!.fourthBitmapName != nil {
            pixelcraftTexture4 = SKTexture(imageNamed: globals.chars[charID]!.fourthBitmapName!)
            pixelcraftTexture4!.filteringMode = SKTextureFilteringMode.Nearest
        }
        
        var animation: SKAction! = nil
        
        // Create pixelcraft animation using both pixelcrafts, and repeat it forever
        if globals.chars[charID]!.thirdBitmapName != nil  {
            animation = SKAction.animateWithTextures([pixelcraftTexture1, pixelcraftTexture2,pixelcraftTexture3!], timePerFrame: NSTimeInterval(globals.chars[charID]!.timePerFrame))
        } else {
            animation = SKAction.animateWithTextures([pixelcraftTexture1, pixelcraftTexture2], timePerFrame: NSTimeInterval(globals.chars[charID]!.timePerFrame))
        }
        
        if globals.chars[charID]!.fourthBitmapName != nil {
           
            animation = SKAction.animateWithTextures([pixelcraftTexture1, pixelcraftTexture2,pixelcraftTexture3!, pixelcraftTexture4!, pixelcraftTexture3!, pixelcraftTexture4!], timePerFrame: NSTimeInterval(globals.chars[charID]!.timePerFrame))
        }
        
        let spin = SKAction.repeatActionForever(animation)
        
        // Create pixelcraft sprite, set it to the correct position and animate it
        pixelcraft = SKSpriteNode(texture: pixelcraftTexture1)
        pixelcraft.position = globals.levels[levelID]!.startingPoint
        pixelcraft.position.y += globals.chars[charID]!.distanceFromStartPoint
        pixelcraft.size = globals.chars[charID]!.size
        pixelcraft.physicsBody = SKPhysicsBody(rectangleOfSize: CGSize(width: pixelcraft.size.width, height: pixelcraft.size.height))
        pixelcraft.physicsBody?.dynamic = true
        pixelcraft.physicsBody?.allowsRotation = true
        pixelcraft.physicsBody?.affectedByGravity = true
        pixelcraft.physicsBody?.mass = 1
        pixelcraft.runAction(spin)
        
        // Add pixelcraft to window
        world.addChild(pixelcraft)
        
        let altitudeControllerBarPic = SKSpriteNode(imageNamed: "controlBar.png")
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
        
        let tiltControllerBarPic = SKSpriteNode(imageNamed: "controlBarRight.png")
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
        pauseScreen.texture!.filteringMode = SKTextureFilteringMode.Nearest
        
        resumeButton.texture = SKTexture(imageNamed: "resumeButton.png")
        resumeButton.position = CGPoint(x: -171, y: 0)
        resumeButton.size = CGSize(width: 128, height: 128)
        resumeButton.zPosition = 101
        resumeButton.texture!.filteringMode = SKTextureFilteringMode.Nearest
        
        quitButton.texture = SKTexture(imageNamed: "quitButton.png")
        quitButton.position = CGPoint(x: 172, y: 0)
        quitButton.size = CGSize(width: 100, height: 100)
        quitButton.zPosition = 101
        quitButton.texture!.filteringMode = SKTextureFilteringMode.Nearest
        
        restartButton.texture = SKTexture(imageNamed: "restartButton.png")
        restartButton.position = CGPoint(x: 172, y: 144)
        restartButton.size = CGSize(width: 100, height: 100)
        restartButton.zPosition = 101
        restartButton.texture!.filteringMode = SKTextureFilteringMode.Nearest
        
        characterSelectButton.texture = SKTexture(imageNamed: "characterSelectButton.png")
        characterSelectButton.position = CGPoint(x: 172, y: -144)
        characterSelectButton.size = CGSize(width: 100, height: 100)
        characterSelectButton.zPosition = 101
        characterSelectButton.texture!.filteringMode = SKTextureFilteringMode.Nearest
        
        let background = SKSpriteNode(imageNamed: globals.levels[levelID]!.bitmapName)
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
            pixelcraft.speed = 0
            pixelcraft.physicsBody?.dynamic = false
        } else {
            pixelcraft.speed = 1
            pixelcraft.physicsBody?.dynamic = true
        }
    }
    
    func resetScene() {
        
        // move pixelcraft back to starting position
        pixelcraft.physicsBody?.affectedByGravity = true
        pixelcraft.position.x = globals.levels[levelID]!.startingPoint.x
        pixelcraft.position.y = globals.levels[levelID]!.startingPoint.y + globals.chars[charID]!.distanceFromStartPoint
        pixelcraft.physicsBody?.velocity = CGVectorMake(0.0, 0.0)
        pixelcraft.speed = 1.0
        pixelcraft.zRotation = 0.0
        
        // freeze game and remember we're waiting for a tap to start
        waitingToStart = true
        self.freezeGame(true)
    }
    
    // Called when a touch begins
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent!) {
        if waitingToStart == true {
            // we were waiting to start - launch the game
            self.freezeGame(false)
            waitingToStart = false
            pixelcraft.physicsBody?.velocity = CGVectorMake(0, 100)
            
        }
        
        touchOrDrag(touches, withEvent: event)
        
    }
    
    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent!) {
        touchOrDrag(touches, withEvent: event)
    }
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent!) {
        for touch: AnyObject in touches {
            let location = touch.locationInNode(overlay)
            let touchedNode = overlay.nodeAtPoint(location)
            
            if touchedNode == altitudeControllerBar {
                multiTouch["altTouch"] = nil
                propForce = CGVectorMake(0, 0)
                pixelcraft.speed = 0
            } else if touchedNode == tiltControllerBar {
                multiTouch["tiltTouch"] = nil
            }
        }
    }
    
    
    // Called before each frame is rendered (drawn on screen)
    override func update(currentTime: CFTimeInterval) {
        if !crashed {
            pixelcraft.physicsBody?.applyForce(propForce)
        }
    }
    
    override func didSimulatePhysics() {
        self.centerOnNodeX(self.pixelcraft)
        
        let point1 = CGPointMake(((pixelcraft.position.x - pixelcraft.size.width / 2) + 5) / (globals.levels[levelID]!.size.width / 512), ((pixelcraft.position.y + pixelcraft.size.height / 2) - 12) / (globals.levels[levelID]!.size.height / 512))
        let alpha1 = Level.getPixelAlphaAtLocation(point1, inImage: image!.CGImage!, context: context)
        
        let point2 = CGPointMake(((pixelcraft.position.x + pixelcraft.size.width / 2) - 5) / (globals.levels[levelID]!.size.width / 512), ((pixelcraft.position.y + pixelcraft.size.height / 2) - 12) / (globals.levels[levelID]!.size.height / 512))
        let alpha2 = Level.getPixelAlphaAtLocation(point2, inImage: image!.CGImage!, context: context)
        
        let point3 = CGPointMake(((pixelcraft.position.x - pixelcraft.size.width / 2) + 5) / (globals.levels[levelID]!.size.width / 512), ((pixelcraft.position.y - pixelcraft.size.height / 2) + 10) / (globals.levels[levelID]!.size.height / 512))
        let alpha3 = Level.getPixelAlphaAtLocation(point3, inImage: image!.CGImage!, context: context)
        
        let point4 = CGPointMake(((pixelcraft.position.x + pixelcraft.size.width / 2) - 5) / (globals.levels[levelID]!.size.width / 512), ((pixelcraft.position.y - pixelcraft.size.height / 2) + 10) / (globals.levels[levelID]!.size.height / 512))
        let alpha4 = Level.getPixelAlphaAtLocation(point4, inImage: image!.CGImage!, context: context)
        
        let point5 = CGPointMake((pixelcraft.position.x) / (globals.levels[levelID]!.size.width / 512), (pixelcraft.position.y - pixelcraft.size.height / 2) / (globals.levels[levelID]!.size.height / 512))
        let alpha5 = Level.getPixelAlphaAtLocation(point5, inImage: image!.CGImage!, context: context)
        
        let point6 = CGPointMake(pixelcraft.position.x / (globals.levels[levelID]!.size.width / 512), (pixelcraft.position.y - pixelcraft.size.height / 2) / (globals.levels[levelID]!.size.height / 512))
        let alpha6 = Level.getPixelAlphaAtLocation(point6, inImage: image!.CGImage!, context: context)
        // Level.freeBitmapContext(context) /*this has to happen when we leave this scene*/
        // println(point)
        // println(alpha)
        if !crashed {
            if pixelcraft.physicsBody!.velocity.dx < 0 {
                dX = 100
            }
            else {
                dX = -100
            }
        }
        
        if !crashed {
            if pixelcraft.physicsBody?.velocity.dy < 0 {
                dY = 100000 / 150
            } else {
                dY = -100000 / 150
            }
            
        }
        
        if alpha1 == 255 || alpha2 == 255 || alpha3 == 255 || alpha4 == 255 || alpha5 == 255 || alpha6 == 255 {
            if crashed == false {
                crashed = true
                pixelcraft.physicsBody?.affectedByGravity = false
                pixelcraft.physicsBody?.angularVelocity = 10
                pixelcraft.physicsBody?.velocity = CGVectorMake(dX, dY)
            
            } else if canReset && crashed == true {
                resetScene()
                crashed = false
                canReset = false
            }
        }

        if (alpha1 == 254 || alpha2 == 254 || alpha3 == 254 || alpha4 == 254 || alpha5 == 254 || alpha6 == 254) && crashed {
            canReset = true
        }
    
        if (alpha6 == 253) && !crashed {
            if pixelcraft.zRotation > 0.37 || pixelcraft.zRotation < -0.37 {
                if crashed == false {
                    crashed = true
                    pixelcraft.physicsBody?.affectedByGravity = false
                    pixelcraft.physicsBody?.angularVelocity = 10
                    pixelcraft.physicsBody?.velocity = CGVectorMake(dX, dY)
                }
            } else {
                landed = true
                let skView = self.view! as SKView
                skView.ignoresSiblingOrder = true
                let scene = LevelScene(charID: charID)
                scene.globals = globals
                scene.scaleMode = .AspectFill
                Level.freeBitmapContext(context)
                skView.presentScene(scene)
            }
        }
    }


    func centerOnNodeX(node: SKNode) {
        let cameraPositionInScene: CGPoint? = node.scene?.convertPoint(node.position, fromNode: node.parent!)
        
        node.parent?.position = CGPointMake(node.parent!.position.x - cameraPositionInScene!.x, node.parent!.position.y - cameraPositionInScene!.y)
    }
    
    func controllerBars(multiTouch: [String:UITouch]) {
        
        if(multiTouch["altTouch"] != nil) {
            let altTouch = multiTouch["altTouch"]
            let half: CGFloat = 288.0
            let shifted = half + altTouch!.locationInNode(overlay).y
            let force = shifted / (half * 2) * 1000
            propForce = CGVectorMakeFromPolar(force, theta: pixelcraft.zRotation + CGFloat(M_PI_2))
        }
        
        if(multiTouch["tiltTouch"] != nil) {
            let tiltTouch = multiTouch["tiltTouch"]
            let half: CGFloat = 288 // self.frame.size.height / 2
            let angle = Double(tiltTouch!.locationInNode(overlay).y / half) * M_PI_2
            // debug
            // println("half = \(half)")
            // println("y's location = \(location.y)")
            // println("to: \(view?.convertPoint(location, toScene: self))")
            // println("from: \(view?.convertPoint(location, fromScene: self))")
            if !crashed && !waitingToStart && !landed {
                pixelcraft.zRotation = CGFloat(angle)
            }
        }
        
    }
    
    func CGVectorMakeFromPolar(r: CGFloat, theta: CGFloat) -> CGVector {
        let x = r * cos(theta)
        let y = r * sin(theta)
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
                    pixelcraft.speed = 1
                    break
                case tiltControllerBar:
                    multiTouch["tiltTouch"] = touch as? UITouch
                    break
                case pauseButton:
                    self.freezeGame(true)
                    overlay.addChild(pauseScreen)
                    overlay.addChild(resumeButton)
                    overlay.addChild(restartButton)
                    overlay.addChild(characterSelectButton)
                    overlay.addChild(quitButton)
                    pauseButton.removeFromParent()
                    break
                case resumeButton:
                    self.freezeGame(false)
                    resumeButton.removeFromParent()
                    pauseScreen.removeFromParent()
                    restartButton.removeFromParent()
                    characterSelectButton.removeFromParent()
                    quitButton.removeFromParent()
                    overlay.addChild(pauseButton)
                case restartButton:
                    self.resetScene()
                    resumeButton.removeFromParent()
                    pauseScreen.removeFromParent()
                    restartButton.removeFromParent()
                    characterSelectButton.removeFromParent()
                    quitButton.removeFromParent()
                    overlay.addChild(pauseButton)
                case quitButton:
                    let skView = self.view! as SKView
                    skView.ignoresSiblingOrder = true
                    let scene = LevelScene(charID: charID)
                    scene.globals = globals
                    scene.scaleMode = .AspectFill
                    Level.freeBitmapContext(context)
                    skView.presentScene(scene)
                case characterSelectButton:
                    let skView = self.view! as SKView
                    skView.ignoresSiblingOrder = true
                    let scene = CharSelectScene(size: CGSizeMake(1024, 768))
                    scene.globals = globals
                    scene.scaleMode = .AspectFill
                    Level.freeBitmapContext(context)
                    skView.presentScene(scene)
                default:
                    break
                }
            }
          
        }
        // say something changed
        controllerBars(multiTouch)
    }

}