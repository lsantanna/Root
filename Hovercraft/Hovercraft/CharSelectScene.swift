//
//  CharSelectScene.swift
//  Pixel Craft
//
//  Created by Lucas Sant'Anna on 2/22/15.
//  Copyright (c) 2015 Lucas Sant'Anna. All rights reserved.
//

import SpriteKit

class CharSelectScene: SKScene {
    var globals = GameGlobals()
    var world = SKNode()
    
    var greenChubbieHovie: SKSpriteNode! = nil
    var redChubbieHovie: SKSpriteNode! = nil
    var blueChubbieHovie: SKSpriteNode! = nil
    var sheep: SKSpriteNode! = nil
    var rocket: SKSpriteNode! = nil
    var nakedMan: SKSpriteNode! = nil
    var characterSelectText: SKSpriteNode! = nil
    var backButton: SKSpriteNode! = nil
    
    override func didMoveToView(view: SKView) {
        self.addChild(world)
        
        self.backgroundColor = UIColor(red: 0x36 / 255, green: 0x36 / 255, blue: 0x36 / 255, alpha: 1)
        
        characterSelectText = SKSpriteNode(imageNamed: "characterSelectText.png")
        characterSelectText.position = CGPointMake(512, 570)
        characterSelectText.zPosition = 1
        characterSelectText.size = CGSizeMake(525, 100)
        characterSelectText.texture?.filteringMode = SKTextureFilteringMode.Nearest
        world.addChild(characterSelectText)
        
        backButton = SKSpriteNode(imageNamed: "backButton.png")
        backButton.position = CGPointMake(100, 570)
        backButton.zPosition = 1
        backButton.size = CGSizeMake(100, 100)
        backButton.texture?.filteringMode = SKTextureFilteringMode.Nearest
        world.addChild(backButton)
        
        greenChubbieHovie = SKSpriteNode(imageNamed: "greenChubbieHovie1.png")
        greenChubbieHovie.position = CGPointMake(100, 400)
        greenChubbieHovie.zPosition = 1
        greenChubbieHovie.size = CGSizeMake(132, 38)
        greenChubbieHovie.texture?.filteringMode = SKTextureFilteringMode.Nearest
        world.addChild(greenChubbieHovie)
        
        redChubbieHovie = SKSpriteNode(imageNamed: "redChubbieHovie1.png")
        redChubbieHovie.position = CGPointMake(500, 400)
        redChubbieHovie.zPosition = 1
        redChubbieHovie.size = CGSizeMake(132, 38)
        redChubbieHovie.texture?.filteringMode = SKTextureFilteringMode.Nearest
        world.addChild(redChubbieHovie)
        
        blueChubbieHovie = SKSpriteNode(imageNamed: "blueChubbieHovie1.png")
        blueChubbieHovie.position = CGPointMake(900, 400)
        blueChubbieHovie.zPosition = 1
        blueChubbieHovie.size = CGSizeMake(132, 38)
        blueChubbieHovie.texture?.filteringMode = SKTextureFilteringMode.Nearest
        world.addChild(blueChubbieHovie)
        
        sheep = SKSpriteNode(imageNamed: "sheep1.png")
        sheep.position = CGPointMake(100, 200)
        sheep.zPosition = 1
        sheep.size = CGSizeMake(76, 39)
        sheep.texture?.filteringMode = SKTextureFilteringMode.Nearest
        world.addChild(sheep)
        
        rocket = SKSpriteNode(imageNamed: "rocket1.png")
        rocket.position = CGPointMake(500, 200)
        rocket.zPosition = 1
        rocket.size = CGSizeMake(52, 68)
        rocket.texture?.filteringMode = SKTextureFilteringMode.Nearest
        world.addChild(rocket)
        
        nakedMan = SKSpriteNode(imageNamed: "nakedMan1.png")
        nakedMan.position = CGPointMake(900, 200)
        nakedMan.zPosition = 1
        nakedMan.size = CGSizeMake(102, 66)
        nakedMan.texture?.filteringMode = SKTextureFilteringMode.Nearest
        world.addChild(nakedMan)
    }
    
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        var location: CGPoint! = nil
        var touchedNode: SKNode! = nil
        
        for touch: AnyObject in touches {
            location = touch.locationInNode(world)
            touchedNode = world.nodeAtPoint(location!)
            
            if touchedNode == nil {}
            else if touchedNode == greenChubbieHovie {
                
                let skView = self.view! as SKView
                skView.ignoresSiblingOrder = true
                let scene = LevelScene(charID: "greenChubbieHovie")
                scene.globals = globals
                scene.scaleMode = .AspectFill
                skView.presentScene(scene)
                
            } else if touchedNode == redChubbieHovie {
                
                let skView = self.view! as SKView
                skView.ignoresSiblingOrder = true
                let scene = LevelScene(charID: "redChubbieHovie")
                scene.globals = globals
                scene.scaleMode = .AspectFill
                skView.presentScene(scene)
                
            } else if touchedNode == blueChubbieHovie {
                
                let skView = self.view! as SKView
                skView.ignoresSiblingOrder = true
                let scene = LevelScene(charID: "blueChubbieHovie")
                scene.globals = globals
                scene.scaleMode = .AspectFill
                skView.presentScene(scene)
                
            } else if touchedNode == sheep {
                
                let skView = self.view! as SKView
                skView.ignoresSiblingOrder = true
                let scene = LevelScene(charID: "sheep")
                scene.globals = globals
                scene.scaleMode = .AspectFill
                skView.presentScene(scene)
                
            } else if touchedNode == rocket {
                
                let skView = self.view! as SKView
                skView.ignoresSiblingOrder = true
                let scene = LevelScene(charID: "rocket")
                scene.globals = globals
                scene.scaleMode = .AspectFill
                skView.presentScene(scene)
                
            } else if touchedNode == nakedMan {
                
                let skView = self.view! as SKView
                skView.ignoresSiblingOrder = true
                let scene = LevelScene(charID: "nakedMan")
                scene.globals = globals
                scene.scaleMode = .AspectFill
                skView.presentScene(scene)
                
            } else if touchedNode == backButton {
                
                let skView = self.view! as SKView
                skView.ignoresSiblingOrder = true
                let scene = MenuScene(size: CGSizeMake(1024, 768))
                scene.globals = globals
                scene.scaleMode = .AspectFill
                skView.presentScene(scene)
                
            }
        }
    }
}
