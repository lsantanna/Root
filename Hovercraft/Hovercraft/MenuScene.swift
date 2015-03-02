//
//  MenuScene.swift
//  Pixel Craft
//
//  Created by Lucas Sant'Anna on 2/7/15.
//  Copyright (c) 2015 Lucas Sant'Anna. All rights reserved.
//

import SpriteKit

class MenuScene: SKScene {
    
    var isCreated = false
    var globals = GameGlobals()
    var playButton: SKSpriteNode! = nil
    
    // Gets called when window moves, and also once at the very beginning
    // Since the window doesn't move, this code will execute exactly once
    override func didMoveToView(view: SKView) {
        
        if !isCreated {
            isCreated = true
        } else {
            println("called twice")
        }
            
        self.anchorPoint = CGPoint(x: 0.5, y: 0.5)
            
            
        playButton = SKSpriteNode(imageNamed: "playButton.png")
        playButton.position = CGPointMake(0, -(self.frame.size.height/4))
        playButton.zPosition = 1
        playButton.size = CGSize(width: 297, height: 156)
        playButton.texture?.filteringMode = SKTextureFilteringMode.Nearest
        self.addChild(playButton)
            
        var backGround = SKSpriteNode(imageNamed: "titleScreen.png")
        backGround.position = CGPointMake(0, 0)
        backGround.size = CGSizeMake(1024, 578)
        backGround.texture?.filteringMode = SKTextureFilteringMode.Nearest
        self.addChild(backGround)
        
        var skyColor = SKColor(red: 113.0/255.0, green: 197.0/255.0, blue: 207.0/255.0, alpha: 1.0)
        self.backgroundColor = skyColor
    }
        
        
    // Called when a touch begins
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        var location: CGPoint! = nil
        var touchedNode: SKNode! = nil
        
        for touch: AnyObject in touches {
            location = touch.locationInNode(self)
            touchedNode = self.nodeAtPoint(location!)
            
            if touchedNode == nil {}
            else if touchedNode == playButton {
                let skView = self.view! as SKView
                skView.ignoresSiblingOrder = true
                let scene = CharSelectScene(size: CGSizeMake(1024, 768))
                scene.globals = globals
                scene.scaleMode = .AspectFill
                skView.presentScene(scene)
            }
        }
    }
}

