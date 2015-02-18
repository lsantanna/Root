//
//  Level.swift
//  Hovercraft
//
//  Created by Lucas Sant'Anna on 2/7/15.
//  Copyright (c) 2015 Lucas Sant'Anna. All rights reserved.
//

import SpriteKit

class Level {
    var bitmapName: String! = nil
    var size: CGSize! = nil
    var startingPoint: CGPoint! = nil
    var backgroundColor: UIColor! = nil
    
    init(bitmapName: String, size: CGSize, startingPoint: CGPoint, backgroundColor: UIColor) {
        self.bitmapName = bitmapName
        self.size = size
        self.startingPoint = startingPoint
        self.backgroundColor = backgroundColor
    }
    
    // func createBitmapContext -> CGContext
    // func freeBitmapContext
    // func getPixelAlphaAtLocation -> CGFloat
}
