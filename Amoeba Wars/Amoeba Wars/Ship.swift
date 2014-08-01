//
//  Ship.swift
//  Amoeba Wars
//
//  Created by Andre on 7/31/14.
//  Copyright (c) 2014 LucasSoft. All rights reserved.
//

import SpriteKit

class Ship: SKSpriteNode {
    
    var parentScene: SKScene
    
    init(scene: SKScene) {
        
        parentScene = scene
            
        // create the ship picture
        var texture = SKTexture(imageNamed: "classic.ship.png")
        
        // create ship sprite
        super.init(texture: texture, color: UIColor.blueColor(), size: CGSizeMake(texture.size().width,
            texture.size().height))
    
        physicsBody = SKPhysicsBody(rectangleOfSize: CGSizeMake(texture.size().width, texture.size().height))
        physicsBody.dynamic = true
        physicsBody.allowsRotation = true
    }
    
    func setSpeed(dx: CGFloat, dy: CGFloat) {
        physicsBody.velocity = CGVectorMake(dx, dy)
    }
    
    func setPosition(x: CGFloat, y: CGFloat) {
        position = CGPointMake(x, y)
    }
   
}
