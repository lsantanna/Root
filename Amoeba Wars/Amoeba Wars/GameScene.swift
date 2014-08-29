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
    
    var ship: Ship! = nil
    
    var leftButton = SKSpriteNode()
    var rightButton = SKSpriteNode()
    var thrustButton = SKSpriteNode()
    var fireButton = SKSpriteNode()
    
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
        ship.setSpeed(0, speed: 0)
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
        }
    
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        /* Called when a touch begins */
        // eventually should be computed properties so the ship moves in the correct direcion and such. These might store values that would mean: "If button is touched right now, set ship's dx and dy values to this: balblalb" Don't know if there is a better way to do this. ???? :)
        var direction: CGFloat = ship.zRotation
        var speed: CGFloat = 1.0
        
        for touch: AnyObject in touches {
            // check if in left button
            let location = touch.locationInNode(self)
            let touchedNode = nodeAtPoint(location)
            
            if touchedNode == leftButton {
                ship.physicsBody.angularVelocity = 3
            } else if touchedNode == rightButton {
                ship.physicsBody.angularVelocity = -3
            } else if touchedNode == thrustButton {
                ship.setSpeed(ship.zRotation, speed: speed)
            } else if touchedNode == fireButton {
                // fire
            }
        }
    }
    
    // called when a touch ends
    override func touchesEnded(touches: NSSet!, withEvent event: UIEvent!) {
    }
    
    // called before each frame is rendered
    override func update(currentTime: CFTimeInterval) {
    }
}

