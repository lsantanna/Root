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
        self.backgroundColor = SPACE_COLOR
        
        // set gravity
        self.physicsWorld.gravity = CGVectorMake(0.0, 0)
        
        // say we want callbacks from SpriteKit
        self.physicsWorld.contactDelegate = self
        
        // create the ship picture
        var shipTexture = SKTexture(imageNamed: "classic.ship.png")
        
        // create ship
        var ship = Ship(scene: self)
        ship.setPosition(self.frame.size.width / 2, y: self.frame.size.height / 2)
        ship.setSpeed(CGFloat(75.0), dy: CGFloat(75.0))
        
        // add ship to scene
        self.addChild(ship)
        
        var asteroid = Asteroid(scene: self, type: 1)
        asteroid.setPosition(self.frame.size.width / 3, y: self.frame.size.height / 3)
        asteroid.setSpeed(-50, dy: -45)
        
        self.addChild(asteroid)
        
        var alienShip = AlienShip(scene: self, type: 1)
        alienShip.setPosition(self.frame.size.width / 2, y: self.frame.size.height / 2)
        alienShip.setSpeed(-100, dy: 0)
        
        self.addChild(alienShip)
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
