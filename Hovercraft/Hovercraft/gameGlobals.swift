//
//  gameGlobals.swift
//  Hovercraft
//
//  Created by Lucas Sant'Anna on 2/8/15.
//  Copyright (c) 2015 Lucas Sant'Anna. All rights reserved.
//

import SpriteKit

class gameGlobals {
    let level1: Level = Level(/* bitmapName, bitmapScale, startPoint */)
    let level2: Level = Level(/* bitmapName, bitmapScale, startPoint */)
    var levels: [Level] = []
    
    init() {
        levels = [level1, level2]
    }
    
}
