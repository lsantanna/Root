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
    
    // set up your scene here
    override func didMoveToView(view: SKView) {
        
        // set background color
        backgroundColor = SPACE_COLOR
        
        // set gravity
        physicsWorld.gravity = CGVectorMake(0.0, 0)
        
        // say we want callbacks from SpriteKit
        physicsWorld.contactDelegate = self
        
        // create ship
        var ship = Ship(scene: self)
        ship.setPosition(frame.size.width / 2, y: frame.size.height / 2)
        ship.setSpeed(10, dy: 0)
        
        // add ship to scene
        addChild(ship)
        
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
    }
    
    // called when a touch begins
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        
        // let location = touch.locationInNode(self)
        
    }
    
    // called when a touch ends
    override func touchesEnded(touches: NSSet!, withEvent event: UIEvent!) {
    }
    
    // called before each frame is rendered
    override func update(currentTime: CFTimeInterval) {
    }
}
