//
//  MenuScene.swift
//  Hovercraft
//
//  Created by Lucas Sant'Anna on 2/7/15.
//  Copyright (c) 2015 Lucas Sant'Anna. All rights reserved.
//

import SpriteKit

class MenuScene: SKScene {
    
    var isCreated = false
        
    // Gets called when window moves, and also once at the very beginning
    // Since the window doesn't move, this code will execute exactly once
    override func didMoveToView(view: SKView) {
        
        if !isCreated {
            isCreated = true
        } else {
            println("called twice")
        }
            
        self.anchorPoint = CGPoint(x: 0.5, y: 0.5)
            
            
        var playButton = SKSpriteNode(imageNamed: "playButton.png")
        playButton.position = CGPointMake(0, 0)
        playButton.zPosition = 1
        self.addChild(playButton)
            
        var backGround = SKSpriteNode(imageNamed: "background.png")
        backGround.position = CGPointMake(0, 0)
        self.addChild(backGround)
            
        var skyColor = SKColor(red: 113.0/255.0, green: 197.0/255.0, blue: 207.0/255.0, alpha: 1.0)
        self.backgroundColor = skyColor
    }
        
        
    // Called when a touch begins
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        goToLevelSelect()
    }
    
    func goToLevelSelect() {
        let skView = self.view! as SKView
        skView.ignoresSiblingOrder = true
        let scene = GameScene(size: CGSize(width: 1024, height: 768))
        scene.scaleMode = .AspectFill
        skView.presentScene(scene)
    }
}

