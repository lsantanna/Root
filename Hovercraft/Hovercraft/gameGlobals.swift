//
//  gameGlobals.swift
//  Hovercraft
//
//  Created by Lucas Sant'Anna on 2/8/15.
//  Copyright (c) 2015 Lucas Sant'Anna. All rights reserved.
//

import SpriteKit

class GameGlobals {
    
    var levels: [String:Level]! = nil
    
    init() {
        levels = [
            "Level1" : Level(bitmapName: "Level1.png", size: CGSizeMake(3000,3000), startingPoint: CGPointMake(185, 1600), backgroundColor: UIColor(red: 0x36 / 255, green: 0x36 / 255, blue: 0x36 / 255, alpha: 1.0)),
            "Level2" : Level(bitmapName: "/Users/Lucas/Desktop/Programming/Root/Hovercraft/Hovercraft/MyResources.atlas/Level2.png", size: CGSizeMake(3000,3000), startingPoint: CGPointMake(520, 575), backgroundColor: UIColor(red: 0x36 / 255, green: 0x36 / 255, blue: 0x36 / 255, alpha: 1.0)),
            /*"Maze" : maze, "BlackNoObstacles" : blackNoObstacles, "BlackWithObstacles" : blackWithObstacles, "Finale" : finale*/
        ]
    }
    
}
