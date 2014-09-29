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
        self.view.multipleTouchEnabled = true
        
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
        leftButton.physicsBody = SKPhysicsBody(circleOfRadius: leftButton.size.height / 2)
        leftButton.physicsBody.dynamic = false
        leftButton.physicsBody.allowsRotation = false
        
        addChild(leftButton)
        
        var rightButtonTexture = SKTexture(imageNamed: "right.button.png")
        rightButton = SKSpriteNode(texture: rightButtonTexture)
        rightButton.xScale = 0.75
        rightButton.yScale = 0.75
        rightButton.position = CGPoint(x: self.frame.size.width / 6, y: self.frame.size.height / 4.5)
        rightButton.alpha = 0.4
        rightButton.physicsBody = SKPhysicsBody(circleOfRadius: rightButton.size.height / 2)
        rightButton.physicsBody.dynamic = false
        rightButton.physicsBody.allowsRotation = false
        
        addChild(rightButton)
        
        thrustButton = SKSpriteNode(texture: leftButtonTexture)
        thrustButton.xScale = 0.75
        thrustButton.yScale = 0.75
        thrustButton.position = CGPoint(x: self.frame.size.width - self.frame.size.width / 15, y: self.frame.size.height / 2.5)
        thrustButton.alpha = 0.4
        thrustButton.physicsBody = SKPhysicsBody(circleOfRadius: thrustButton.size.height / 2)
        thrustButton.physicsBody.dynamic = false
        thrustButton.physicsBody.allowsRotation = false
        
        addChild(thrustButton)
        
        fireButton = SKSpriteNode(texture: rightButtonTexture)
        fireButton.xScale = 0.75
        fireButton.yScale = 0.75
        fireButton.position = CGPoint(x: self.frame.size.width - self.frame.size.width / 6, y: self.frame.size.height / 4.5)
        fireButton.alpha = 0.4
        fireButton.physicsBody = SKPhysicsBody(circleOfRadius: fireButton.size.height / 2)
        fireButton.physicsBody.dynamic = false
        fireButton.physicsBody.allowsRotation = false

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
        asteroid.physicsBody.applyAngularImpulse(0.01)
        addChild(asteroid2)
        
        var asteroid3 = Asteroid(scene: self, type: 3)
        asteroid3.setPosition(frame.size.width / 2 - 20, y: frame.size.height / 2 + 20)
        asteroid3.setSpeed(-20, dy: 25)
        asteroid.physicsBody.applyAngularImpulse(-0.06)
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
        contactNodeRight.physicsBody.dynamic = false
        contactNodeRight.physicsBody.categoryBitMask = wrapperBlockRight
        contactNodeRight.physicsBody.contactTestBitMask = toBeWrapped

        addChild(contactNodeRight)
        
        var contactNodeLeft = SKNode()
        contactNodeLeft.position = CGPointMake(0 - ship.size.width, frame.size.height / 2)
        contactNodeLeft.physicsBody = SKPhysicsBody(rectangleOfSize: CGSizeMake(100, frame.size.height + 100))
        contactNodeLeft.physicsBody.dynamic = false
        contactNodeLeft.physicsBody.categoryBitMask = wrapperBlockLeft
        contactNodeLeft.physicsBody.contactTestBitMask = toBeWrapped
        
        addChild(contactNodeLeft)
        
        var contactNodeTop = SKNode()
        contactNodeTop.position = CGPointMake(frame.size.width / 2, frame.size.height + ship.size.height)
        contactNodeTop.physicsBody = SKPhysicsBody(rectangleOfSize: CGSizeMake(frame.size.width + 100, 100))
        contactNodeTop.physicsBody.dynamic = false
        contactNodeTop.physicsBody.categoryBitMask = wrapperBlockTop
        contactNodeTop.physicsBody.contactTestBitMask = toBeWrapped
        
        addChild(contactNodeTop)
        
        var contactNodeBottom = SKNode()
        contactNodeBottom.position = CGPointMake(frame.size.width / 2, 0 - ship.size.height)
        contactNodeBottom.physicsBody = SKPhysicsBody(rectangleOfSize: CGSizeMake(frame.size.width + 100, 100))
        contactNodeBottom.physicsBody.dynamic = false
        contactNodeBottom.physicsBody.categoryBitMask = wrapperBlockBottom
        contactNodeBottom.physicsBody.contactTestBitMask = toBeWrapped
        
        addChild(contactNodeBottom)
    }

    func didBeginContact(contact: SKPhysicsContact!) {
        if ((contact.bodyA.categoryBitMask & (wrapperBlockTop | wrapperBlockBottom | wrapperBlockLeft | wrapperBlockRight)) != 0) || ((contact.bodyB.categoryBitMask & (wrapperBlockTop | wrapperBlockBottom | wrapperBlockLeft | wrapperBlockRight)) != 0) {
            if (contact.bodyA.categoryBitMask == wrapperBlockTop) || (contact.bodyB.categoryBitMask == wrapperBlockTop) {
                ship.position.y -= (frame.size.height / 2)
                ship.physicsBody.velocity = CGVectorMake(0, 0)
                println("HIT IT")
            }
        }
    }
    
    func buttonsChanged() {
        
        if (leftPressed || rightPressed) {
            if (leftPressed) {
                ship.physicsBody.angularVelocity = 3
            } else {
                ship.physicsBody.angularVelocity = -3
            }
        } else {
            ship.physicsBody.angularVelocity = 0
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

