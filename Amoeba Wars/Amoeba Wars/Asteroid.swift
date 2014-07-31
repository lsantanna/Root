//
//  Asteroid.swift
//  Amoeba Wars
//
//  Created by Andre on 7/31/14.
//  Copyright (c) 2014 LucasSoft. All rights reserved.
//

import SpriteKit

class Asteroid: SKSpriteNode {
    
    var parentScene: SKScene
    
    init(scene: SKScene, type: Int) {
        
        parentScene = scene
        
        // create the asteroid picture
        
        var name = "error"
        
        switch(type) {
        case 1: name = "classic.asteroid.1.png"
        case 2: name = "classic.asteroid.2.png"
        case 3: name = "classic.asteroid.3.png"
        default: println("bad param to Asteroid:init")
        }
        
        var texture = SKTexture(imageNamed: name)
        
        // create ship sprite
        super.init(texture: texture, color: UIColor.blueColor(), size: CGSizeMake(texture.size().width,
            texture.size().height))
    
        physicsBody = SKPhysicsBody(rectangleOfSize: CGSizeMake(texture.size().width, texture.size().height))
        physicsBody.dynamic = true
        physicsBody.allowsRotation = false
    }
    
    func setSpeed(dx: CGFloat, dy: CGFloat) {
        physicsBody.velocity = CGVectorMake(dx, dy)
    }
    
    func setPosition(x: CGFloat, y: CGFloat) {
        position = CGPointMake(x, y)
    }

   
}
