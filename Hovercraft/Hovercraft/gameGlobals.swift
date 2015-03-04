//
//  GameGlobals.swift
//  Pixel Craft
//
//  Created by Lucas Sant'Anna on 2/8/15.
//  Copyright (c) 2015 Lucas Sant'Anna. All rights reserved.
//

import SpriteKit

class GameGlobals {
    
    var levels: [String:Level]! = nil
    var chars: [String:Char]! = nil
    
    init() {
        levels = [
            "Level1" : Level(bitmapName: "Level1.png", size: CGSizeMake(3000, 3000), startingPoint: CGPointMake(185, 1607), backgroundColor: UIColor(red: 0x36 / 255, green: 0x36 / 255, blue: 0x36 / 255, alpha: 1.0)),
            "Level2" : Level(bitmapName: "Level2.png", size: CGSizeMake(3000, 3000), startingPoint: CGPointMake(520, 581), backgroundColor: UIColor(red: 0x36 / 255, green: 0x36 / 255, blue: 0x36 / 255, alpha: 1.0)),
            "Maze" : Level(bitmapName: "Maze.png", size: CGSizeMake(5000, 5000), startingPoint: CGPointMake(255, 2665), backgroundColor: UIColor(red: 0x36 / 255, green: 0x36 / 255, blue: 0x36 / 255, alpha: 1.0)),
            "BlackNoObstacles" : Level(bitmapName: "BlackNoObstacles.png", size: CGSizeMake(7000, 7000), startingPoint: CGPointMake(287, 6788), backgroundColor: UIColor(red: 0, green: 0, blue: 0, alpha: 1)),
            "BlackWithObstacles" : Level(bitmapName: "BlackWithObstacles.png", size: CGSizeMake(7000, 7000), startingPoint: CGPointMake(385, 471), backgroundColor: UIColor(red: 0x05 / 255, green: 0x05 / 255, blue: 0x05 / 255, alpha: 1)),
            "Finale" : Level(bitmapName: "Finale.png", size: CGSizeMake(5000, 5000), startingPoint: CGPointMake(158, 2323 /*4300, 2900*/), backgroundColor: UIColor(red: 0x36 / 255, green: 0x36 / 255, blue: 0x36 / 255, alpha: 1.0))
        ]
        
        chars = [
            "greenChubbieHovie" : Char(firstBitmapName: "greenChubbieHovie1.png", secondBitmapName: "greenChubbieHovie2.png", thirdBitmapName: nil, fourthBitmapName: nil, distanceFromStartPoint: 0.0, size: CGSizeMake(132, 38), timePerFrame: 0.1),
            "redChubbieHovie" : Char(firstBitmapName: "redChubbieHovie1.png", secondBitmapName: "redChubbieHovie2.png", thirdBitmapName: nil, fourthBitmapName: nil, distanceFromStartPoint: 0.0, size: CGSizeMake(132, 38), timePerFrame: 0.1),
            "blueChubbieHovie" : Char(firstBitmapName: "blueChubbieHovie1.png", secondBitmapName: "blueChubbieHovie2.png", thirdBitmapName: nil, fourthBitmapName: nil, distanceFromStartPoint: 0.0, size: CGSizeMake(132, 38), timePerFrame: 0.1),
            "sheep" : Char(firstBitmapName: "sheep1.png", secondBitmapName: "sheep2.png", thirdBitmapName: nil, fourthBitmapName: nil, distanceFromStartPoint: 0.0, size: CGSizeMake(76, 39), timePerFrame: 0.3),
            "rocket" : Char(firstBitmapName: "rocket1.png", secondBitmapName: "rocket2.png", thirdBitmapName: "rocket3.png", fourthBitmapName: nil, distanceFromStartPoint: 15, size: CGSizeMake(52, 68), timePerFrame: 0.1),
            "nakedMan" : Char(firstBitmapName: "nakedMan1.png", secondBitmapName: "nakedMan2.png", thirdBitmapName: nil, fourthBitmapName: nil, distanceFromStartPoint: 14, size: CGSizeMake(102, 66), timePerFrame: 0.4),
            "chubbieBoy" : Char(firstBitmapName: "chubbieBoy1.png", secondBitmapName: "chubbieBoy2.png", thirdBitmapName: "chubbieBoy3.png", fourthBitmapName: "chubbieBoy4.png", distanceFromStartPoint: 10, size: CGSizeMake(51, 72), timePerFrame: 0.125),
            "lightningBug" : Char(firstBitmapName: "lightningBug1.png", secondBitmapName: "lightningBug2.png", thirdBitmapName: nil, fourthBitmapName: nil, distanceFromStartPoint: 0, size: CGSizeMake(600, 600), timePerFrame: 0.2)
        ]
    }
    
}
