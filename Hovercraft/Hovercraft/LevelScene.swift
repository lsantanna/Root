//
//  LevelScene.swift
//  Pixel Craft
//
//  Created by Lucas Sant'Anna on 2/18/15.
//  Copyright (c) 2015 Lucas Sant'Anna. All rights reserved.
//

import SpriteKit

class LevelScene: SKScene {
    
    var globals = GameGlobals()
    var level1Button: SKSpriteNode! = nil
    var level2Button: SKSpriteNode! = nil
    var level3Button: SKSpriteNode! = nil
    var level4Button: SKSpriteNode! = nil
    var level5Button: SKSpriteNode! = nil
    var level6Button: SKSpriteNode! = nil
    var backButton: SKSpriteNode! = nil
    var background: SKSpriteNode! = nil
    var levelSelectText: SKSpriteNode! = nil
    var world: SKNode = SKNode()
    var charID: String! = nil
    
    
    init(charID: String) {
        self.charID = charID
        super.init(size: CGSizeMake(1024, 768))
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func didMoveToView(view: SKView) {
        
        self.addChild(world)
        
        self.backgroundColor = UIColor(red: 0x36 / 255, green: 0x36 / 255, blue: 0x36 / 255, alpha: 1)
        
        background = SKSpriteNode(imageNamed: "selectBackgroud.png")
        background.position = CGPointMake(512, 384)
        background.size = CGSizeMake(1024, 578)
        background.texture?.filteringMode = SKTextureFilteringMode.Nearest
        background.zPosition = -100
        self.addChild(background)
        
        levelSelectText = SKSpriteNode(imageNamed: "levelSelectText.png")
        levelSelectText.position = CGPointMake(512, 570)
        levelSelectText.zPosition = 1
        levelSelectText.size = CGSizeMake(325, 100)
        levelSelectText.texture?.filteringMode = SKTextureFilteringMode.Nearest
        world.addChild(levelSelectText)
        
        backButton = SKSpriteNode(imageNamed: "backButton.png")
        backButton.position = CGPointMake(125, 570)
        backButton.zPosition = 1
        backButton.size = CGSizeMake(100, 100)
        backButton.texture?.filteringMode = SKTextureFilteringMode.Nearest
        world.addChild(backButton)
        
        level1Button = SKSpriteNode(imageNamed: "level1Button.png")
        level1Button.position = CGPointMake(200, 400)
        level1Button.zPosition = 1
        level1Button.size = CGSize(width: 100, height: 100)
        level1Button.texture?.filteringMode = SKTextureFilteringMode.Nearest
        world.addChild(level1Button)
        
        level2Button = SKSpriteNode(imageNamed: "level2Button.png")
        level2Button.position = CGPointMake(500, 400)
        level2Button.zPosition = 1
        level2Button.size = CGSize(width: 100, height: 100)
        level2Button.texture?.filteringMode = SKTextureFilteringMode.Nearest
        world.addChild(level2Button)
        
        level3Button = SKSpriteNode(imageNamed: "level3Button.png")
        level3Button.position = CGPointMake(800, 400)
        level3Button.zPosition = 1
        level3Button.size = CGSize(width: 100, height: 100)
        level3Button.texture?.filteringMode = SKTextureFilteringMode.Nearest
        world.addChild(level3Button)
        
        level4Button = SKSpriteNode(imageNamed: "level4Button.png")
        level4Button.position = CGPointMake(200, 250)
        level4Button.zPosition = 1
        level4Button.size = CGSize(width: 100, height: 100)
        level4Button.texture?.filteringMode = SKTextureFilteringMode.Nearest
        world.addChild(level4Button)
        
        level5Button = SKSpriteNode(imageNamed: "level5Button.png")
        level5Button.position = CGPointMake(500, 250)
        level5Button.zPosition = 1
        level5Button.size = CGSize(width: 100, height: 100)
        level5Button.texture?.filteringMode = SKTextureFilteringMode.Nearest
        world.addChild(level5Button)
        
        level6Button = SKSpriteNode(imageNamed: "level6Button.png")
        level6Button.position = CGPointMake(800, 250)
        level6Button.zPosition = 1
        level6Button.size = CGSize(width: 100, height: 100)
        level6Button.texture?.filteringMode = SKTextureFilteringMode.Nearest
        world.addChild(level6Button)
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent!) {
        var location: CGPoint! = nil
        var touchedNode: SKNode! = nil
        
        for touch: AnyObject in touches {
            location = touch.locationInNode(world)
            touchedNode = world.nodeAtPoint(location!)
            
            if touchedNode == nil {}
            else if touchedNode == level1Button {
                
                let skView = self.view! as SKView
                skView.ignoresSiblingOrder = true
                let scene = GameScene(levelID: "Level1", charID: charID)
                scene.globals = globals
                scene.scaleMode = .AspectFill
                skView.presentScene(scene)
            
            } else if touchedNode == level2Button {
            
                let skView = self.view! as SKView
                skView.ignoresSiblingOrder = true
                let scene = GameScene(levelID: "Level2", charID: charID)
                scene.globals = globals
                scene.scaleMode = .AspectFill
                skView.presentScene(scene)
                
            } else if touchedNode == level3Button {
                
                let skView = self.view! as SKView
                skView.ignoresSiblingOrder = true
                let scene = GameScene(levelID: "Maze", charID: charID)
                scene.globals = globals
                scene.scaleMode = .AspectFill
                skView.presentScene(scene)
                
            } else if touchedNode == level4Button {
                
                let skView = self.view! as SKView
                skView.ignoresSiblingOrder = true
                let scene = GameScene(levelID: "BlackNoObstacles", charID: charID)
                scene.globals = globals
                scene.scaleMode = .AspectFill
                skView.presentScene(scene)
                
            } else if touchedNode == level5Button {
                
                let skView = self.view! as SKView
                skView.ignoresSiblingOrder = true
                let scene = GameScene(levelID: "BlackWithObstacles", charID: charID)
                scene.globals = globals
                scene.scaleMode = .AspectFill
                skView.presentScene(scene)
                
            } else if touchedNode == level6Button {

                let skView = self.view! as SKView
                skView.ignoresSiblingOrder = true
                let scene = GameScene(levelID: "Finale", charID: charID)
                scene.globals = globals
                scene.scaleMode = .AspectFill
                skView.presentScene(scene)
                
            } else if touchedNode == backButton {
                
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