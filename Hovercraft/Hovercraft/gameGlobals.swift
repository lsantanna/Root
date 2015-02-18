//
//  gameGlobals.swift
//  Hovercraft
//
//  Created by Lucas Sant'Anna on 2/8/15.
//  Copyright (c) 2015 Lucas Sant'Anna. All rights reserved.
//

import SpriteKit

class gameGlobals {
    let level1: Level = Level(bitmapName: "Level1.png", size: CGSizeMake(3000,3000), startingPoint:CGPointMake(185, 1600), backgroundColor: UIColor(red: 0x36 / 255, green: 0x36 / 255, blue: 0x36 / 255, alpha: 1.0))
    // let level2: Level = Level(bitmapName: , size: , startingPoint: , backgroundColor: )
    var levels: [Level] = []
    
    init() {
        levels = [level1/*, level2, Maze, BlackNoObstacles, BlackWithObstacles, Finale*/]
    }
    
}
