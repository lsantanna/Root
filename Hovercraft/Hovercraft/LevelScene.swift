//
//  LevelScene.swift
//  Hovercraft
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
        
        self.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 1)
        
        level1Button = SKSpriteNode(imageNamed: "level1Button.png")
        level1Button.position = CGPointMake(100, 400)
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
        level3Button.position = CGPointMake(900, 400)
        level3Button.zPosition = 1
        level3Button.size = CGSize(width: 100, height: 100)
        level3Button.texture?.filteringMode = SKTextureFilteringMode.Nearest
        world.addChild(level3Button)
        
        level4Button = SKSpriteNode(imageNamed: "level4Button.png")
        level4Button.position = CGPointMake(100, 200)
        level4Button.zPosition = 1
        level4Button.size = CGSize(width: 100, height: 100)
        level4Button.texture?.filteringMode = SKTextureFilteringMode.Nearest
        world.addChild(level4Button)
        
        level5Button = SKSpriteNode(imageNamed: "level5Button.png")
        level5Button.position = CGPointMake(500, 200)
        level5Button.zPosition = 1
        level5Button.size = CGSize(width: 100, height: 100)
        level5Button.texture?.filteringMode = SKTextureFilteringMode.Nearest
        world.addChild(level5Button)
        
        level6Button = SKSpriteNode(imageNamed: "level6Button.png")
        level6Button.position = CGPointMake(900, 200)
        level6Button.zPosition = 1
        level6Button.size = CGSize(width: 100, height: 100)
        level6Button.texture?.filteringMode = SKTextureFilteringMode.Nearest
        world.addChild(level6Button)
    }
    
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
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
                
            }
        }
    }
}