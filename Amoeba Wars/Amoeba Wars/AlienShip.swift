//
//  AlienShip.swift
//  Amoeba Wars
//
//  Created by Andre on 7/31/14.
//  Copyright (c) 2014 LucasSoft. All rights reserved.
//

import SpriteKit

class AlienShip: SKSpriteNode {
    
    var parentScene: SKScene
    
    init(scene: SKScene, type: Int) {
        
        parentScene = scene
        
        // create the alien ship picture
        
        var name = "error"
        
        switch(type) {
        case 1: name = "classic.bullet.png"
        case 2: name = "classic.bullet.png"
        default: println("bad param to AlienShip:init")
        }
        
        var texture = SKTexture(imageNamed: name)
        
        // create ship sprite
        super.init(texture: texture, color: UIColor.blueColor(), size: CGSizeMake(texture.size().width,
            texture.size().height))
    
        physicsBody = SKPhysicsBody(rectangleOfSize: CGSizeMake(texture.size().width, texture.size().height))
        physicsBody.dynamic = true
        physicsBody.allowsRotation = true
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setSpeed(dx: CGFloat, dy: CGFloat) {
        physicsBody.velocity = CGVectorMake(dx, dy)
    }
    
    func setPosition(x: CGFloat, y: CGFloat) {
        position = CGPointMake(x, y)
    }

   
}
