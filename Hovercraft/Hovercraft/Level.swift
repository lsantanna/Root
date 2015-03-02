//
//  Level.swift
//  Pixel Craft
//
//  Created by Lucas Sant'Anna on 2/7/15.
//  Copyright (c) 2015 Lucas Sant'Anna. All rights reserved.
//

import SpriteKit

class Level {
    var bitmapName: String! = nil
    var size: CGSize! = nil
    var startingPoint: CGPoint! = nil
    var backgroundColor: SKColor! = nil
    
    init(bitmapName: String, size: CGSize, startingPoint: CGPoint, backgroundColor: SKColor) {
        self.bitmapName = bitmapName
        self.size = size
        self.startingPoint = startingPoint
        self.backgroundColor = backgroundColor
    }
    
    class func createARGBBitmapContext(inImage: CGImage) -> CGContext?{
        var bitmapByteCount = 0
        var bitmapBytesPerRow = 0
        
        //Get image width, height
        let pixelsWide = CGImageGetWidth(inImage)
        let pixelsHigh = CGImageGetHeight(inImage)
        
        // Declare the number of bytes per row. Each pixel in the bitmap in this
        // example is represented by 4 bytes; 8 bits each of red, green, blue, and
        // alpha.
        bitmapBytesPerRow = Int(pixelsWide) * 4
        bitmapByteCount = bitmapBytesPerRow * Int(pixelsHigh)
        
        // Use the generic RGB color space.
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        
        // Allocate memory for image data. This is the destination in memory
        // where any drawing to the bitmap context will be rendered.
        let bitmapData = malloc(CUnsignedLong(bitmapByteCount))
        
        /* REPLACED:
        let bitmapInfo = CGBitmapInfo.fromRaw(CGImageAlphaInfo.PremultipliedFirst.rawValue)!
        */
        let bitmapInfo = CGBitmapInfo(CGImageAlphaInfo.PremultipliedFirst.rawValue)
        
        
        // Create the bitmap context. We want pre-multiplied ARGB, 8-bits
        // per component. Regardless of what the source image format is
        // (CMYK, Grayscale, and so on) it will be converted over to the format
        // specified here by CGBitmapContextCreate.
        let context = CGBitmapContextCreate(bitmapData, pixelsWide, pixelsHigh, CUnsignedLong(8), CUnsignedLong(bitmapBytesPerRow), colorSpace, bitmapInfo)
        
        // Make sure and release colorspace before returning
        // COMMENTED OUT: CGColorSpaceRelease(colorSpace)
        
        return context
    }
    
    class func createBitmapContext(inImage: CGImageRef) -> CGContext {
        
        let context = createARGBBitmapContext(inImage)
        
        let pixelsWide = CGImageGetWidth(inImage)
        let pixelsHigh = CGImageGetHeight(inImage)
        let rect = CGRect(x:0, y:0, width:Int(pixelsWide), height:Int(pixelsHigh))
        
        //Clear the context
        CGContextClearRect(context, rect)
        
        // Draw the image to the bitmap context. Once we draw, the memory
        // allocated for the context for rendering will then contain the
        // raw image data in the specified color space.
        CGContextDrawImage(context, rect, inImage)
        
        return context!
    }
    
    class func getPixelAlphaAtLocation(point:CGPoint, inImage:CGImageRef, context: CGContext) -> CGFloat {

        var safePoint = point
        safePoint.y = 511 - safePoint.y
        if safePoint.x > 511 { safePoint.x = 511 }
        if safePoint.y > 511 { safePoint.y = 511 }
        if safePoint.x < 0 { safePoint.x = 0 }
        if safePoint.y < 0 { safePoint.y = 0 }
        
        let pixelsWide = CGImageGetWidth(inImage)
        let pixelsHigh = CGImageGetHeight(inImage)
        // Now we can get a pointer to the image data associated with the bitmap
        // context.
        // let data:COpaquePointer = CGBitmapContextGetData(context)
        // let dataType = UnsafePointer<UInt8>(data)
        let data = CGBitmapContextGetData(context)
        let dataType = UnsafePointer<UInt8>(data)
        
        let offset = 4*((Int(pixelsWide) * Int(safePoint.y)) + Int(safePoint.x))
        let alpha = dataType[offset]
        // let red = dataType[offset+1]
        // let green = dataType[offset+2]
        // let blue = dataType[offset+3]
        
        // let color = UIColor( red: CGFloat(red)/255.0, green: CGFloat(green)/255.0, blue: CGFloat(blue)/255.0, alpha: CGFloat(alpha)/255.0)
        return CGFloat(alpha)
    }
    
    
    class func freeBitmapContext(context: CGContext) {
        // When finished, release the context
        // CGContextRelease(context);
        // Free image data memory for the context
        let data = CGBitmapContextGetData(context)
        free(data)
    }

}
