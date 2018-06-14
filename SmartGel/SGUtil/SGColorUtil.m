//
//  SGColorUtil.m
//  SmartGel
//
//  Created by jordi on 09/05/2018.
//  Copyright © 2018 AFCO. All rights reserved.
//

#import "SGColorUtil.h"

@implementation SGColorUtil

+ (instancetype)sharedColorUtil {
    static id _sharedColorUtil = nil;
    static dispatch_once_t onceToken;
    
    _dispatch_once(&onceToken, ^{
        _sharedColorUtil = [[SGColorUtil alloc] init];
    });
    
    return _sharedColorUtil;
}

- (instancetype)init {
    if (self = [super init]) {
    }
    return self;
}

- (UInt32)   getDirtyPixel:(RGBA *)rgba
           withColorOffset:(int)colorOffset
{
    UInt8 minValue = 0x4F;
    if (rgba->r < minValue && rgba->g < minValue && rgba->b < minValue)
        return BLUE_DIRTY_PIXEL;
    
    int yellowValue = rgba->r + rgba->g;
    int greenValue = rgba->g + rgba->b;
    int pinkValue = rgba->r + rgba->b;
    
    BOOL isPinkSerial = pinkValue > greenValue;
    if (isPinkSerial)
    {
        if(pinkValue>(yellowValue-colorOffset))
            return PINK_DIRTY_PIXEL;
        else
            return BLUE_DIRTY_PIXEL;
        //        float distance = [self getDistanceWithPinkColor:rgba];
        //        if(distance<PINK_COLOR_OFFSET)
        //            return PINK_DIRTY_PIXEL;
        //        else
        //            return NO_DIRTY_PIXEL;
        
    }
    else //means green serial
    {
        return BLUE_DIRTY_PIXEL;
    }
}

- (UInt32)getDirtyPixelLaboratory:(RGBA *)rgba
{
    UInt8 minValue = 0x19;
    if (rgba->r < minValue && rgba->g < minValue && rgba->b < minValue)
        return NO_GEL;
    
    
    UInt8 maxValue = 0xA0;
    if (rgba->r > maxValue && rgba->g > maxValue && rgba->b > maxValue)
        return NO_GEL;

    
    int yellowValue = rgba->r + rgba->g;
    int greenValue = rgba->g + rgba->b;
    int pinkValue = rgba->r + rgba->b;
    
    BOOL isPinkSerial = pinkValue > greenValue;
    if (isPinkSerial)
    {
        if(pinkValue>(yellowValue-5))
            return IS_CLEAN;
        else{
            return IS_DIRTY;
        }
    }
    else //means green serial
    {
        return IS_DIRTY;
    }
}


-(float)getDistancebetweenColors:(RGBA *)rgba1
                            with:(RGBA *)rgba2{
    
    XYZ xyzPink = [self getXYZfromRGB:rgba2];
    XYZ xyz1 = [self getXYZfromRGB:rgba1];
    LAB labPink = [self getLABfromXYZ:xyzPink];
    LAB lab1 = [self getLABfromXYZ:xyz1];
    
    //    float l = labPink.l - lab1.l;
    //    float a = labPink.a - lab1.a;
    //    float b = labPink.b - lab1.b;
    
    //    float distance = sqrt((l*l)+(a*a)+(b*b));
    float distance = [self getDeltaE:labPink withLab2:lab1];
    return distance;
}

- (CGContextRef) createARGBBitmapContextFromImage:(CGImageRef) inImage {
    
    CGContextRef    context = NULL;
    CGColorSpaceRef colorSpace;
    void *          bitmapData;
    int             bitmapByteCount;
    int             bitmapBytesPerRow;
    
    // Get image width, height. We'll use the entire image.
    size_t pixelsWide = CGImageGetWidth(inImage);
    size_t pixelsHigh = CGImageGetHeight(inImage);
    
    // Declare the number of bytes per row. Each pixel in the bitmap in this
    // example is represented by 4 bytes; 8 bits each of red, green, blue, and
    // alpha.
    bitmapBytesPerRow   = (pixelsWide * 4);
    bitmapByteCount     = (bitmapBytesPerRow * pixelsHigh);
    
    // Use the generic RGB color space.
    colorSpace = CGColorSpaceCreateDeviceRGB();
    if (colorSpace == NULL)
    {
        fprintf(stderr, "Error allocating color space\n");
        return NULL;
    }
    
    // Allocate memory for image data. This is the destination in memory
    // where any drawing to the bitmap context will be rendered.
    bitmapData = malloc( bitmapByteCount );
    if (bitmapData == NULL)
    {
        fprintf (stderr, "Memory not allocated!");
        CGColorSpaceRelease( colorSpace );
        return NULL;
    }
    
    // Create the bitmap context. We want pre-multiplied ARGB, 8-bits
    // per component. Regardless of what the source image format is
    // (CMYK, Grayscale, and so on) it will be converted over to the format
    // specified here by CGBitmapContextCreate.
    context = CGBitmapContextCreate (bitmapData,
                                     pixelsWide,
                                     pixelsHigh,
                                     8,      // bits per component
                                     bitmapBytesPerRow,
                                     colorSpace,
                                     kCGImageAlphaPremultipliedFirst);
    if (context == NULL)
    {
        free (bitmapData);
        fprintf (stderr, "Context not created!");
    }
    
    // Make sure and release colorspace before returning
    CGColorSpaceRelease( colorSpace );
    return context;
}



- (XYZ)getXYZfromRGB : (RGBA *)rgbColor{
    
    float red = (float)rgbColor->r/255;
    float green = (float)rgbColor->g/255;
    float blue = (float)rgbColor->b/255;
    
    // adjusting values
    if(red>0.04045){
        red = (red+0.055)/1.055;
        red = pow(red,2.4);
    }
    else{
        red = red/12.92;
    }
    if(green>0.04045){
        green = (green+0.055)/1.055;
        green = pow(green,2.4);
    }
    else{
        green = green/12.92;
    }
    if(blue>0.04045){
        blue = (blue+0.055)/1.055;
        blue = pow(blue,2.4);
    }
    else{
        blue = blue/12.92;
    }
    
    red *= 100;
    green *= 100;
    blue *= 100;
    
    XYZ xyzColor;
    // applying the matrix
    xyzColor.x = red * 0.4124 + green * 0.3576 + blue * 0.1805;
    xyzColor.y = red * 0.2126 + green * 0.7152 + blue * 0.0722;
    xyzColor.z = red * 0.0193 + green * 0.1192 + blue * 0.9505;
    return xyzColor;
}

-(LAB)getLABfromXYZ: (XYZ)xyzColor{
    float $_x = xyzColor.x/95.047;
    float $_y = xyzColor.y/100;
    float $_z = xyzColor.z/108.883;
    
    // adjusting the values
    if($_x>0.008856){
        $_x = pow($_x,(float)1/3);
    }
    else{
        $_x = 7.787*$_x + 16/116;
    }
    if($_y>0.008856){
        $_y = pow($_y,(float)1/3);
    }
    else{
        $_y = (7.787*$_y) + (16/116);
    }
    if($_z>0.008856){
        $_z = pow($_z,(float)1/3);
    }
    else{
        $_z = 7.787*$_z + 16/116;
    }
    LAB labColor;
    labColor.l= 116*$_y -16;
    labColor.a= 500*($_x-$_y);
    labColor.b= 200*($_y-$_z);
    return labColor;
}


-(float)getDeltaE:(LAB)labl
         withLab2:(LAB)lab2{
    float deltaL = labl.l - lab2.l;
    float deltaA = labl.a - lab2.a;
    float deltaB = labl.b - lab2.b;
    float c1 = sqrt(labl.a * labl.a + labl.b * labl.b);
    float c2 = sqrt(lab2.a * lab2.a + lab2.b * lab2.b);
    float deltaC = c1 - c2;
    float deltaH = deltaA * deltaA + deltaB * deltaB - deltaC * deltaC;
    deltaH = deltaH < 0 ? 0 : sqrt(deltaH);
    float sc = 1.0 + 0.045 * c1;
    float sh = 1.0 + 0.015 * c1;
    float deltaLKlsl = (float)deltaL / (1.0);
    float deltaCkcsc = (float)deltaC / (sc);
    float deltaHkhsh = (float)deltaH / (sh);
    float i = deltaLKlsl * deltaLKlsl + deltaCkcsc * deltaCkcsc + deltaHkhsh * deltaHkhsh;
    return i < 0 ? 0 : sqrt(i);
}


@end
