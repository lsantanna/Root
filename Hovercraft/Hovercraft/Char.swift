//
//  Char.swift
//  Pixel Craft
//
//  Created by Lucas Sant'Anna on 2/19/15.
//  Copyright (c) 2015 Lucas Sant'Anna. All rights reserved.
//

import SpriteKit

class Char {
    var firstBitmapName: String! = nil
    var secondBitmapName: String! = nil
    var thirdBitmapName: String? = nil
    var fourthBitmapName: String? = nil
    
    var distanceFromStartPoint: CGFloat! = nil
    
    var size: CGSize! = nil
    
    var timePerFrame: CGFloat! = nil
    
    init(firstBitmapName: String, secondBitmapName: String, thirdBitmapName: String?, fourthBitmapName: String?, distanceFromStartPoint: CGFloat, size: CGSize, timePerFrame: CGFloat) {
        self.firstBitmapName = firstBitmapName
        self.secondBitmapName = secondBitmapName
        self.thirdBitmapName = thirdBitmapName?
        self.fourthBitmapName = fourthBitmapName?
        
        self.distanceFromStartPoint = distanceFromStartPoint
        
        self.size = size
        
        self.timePerFrame = timePerFrame
    }
}
