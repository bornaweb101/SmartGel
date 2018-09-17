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
    }
    else //means green serial
    {
        return BLUE_DIRTY_PIXEL;
    }
}

- (UInt32) getDirtyPixelLaboratory:(RGBA *)rgba
{
    UInt8 minValue = 0x4F;
    if (rgba->r < minValue && rgba->g < minValue && rgba->b < minValue)
        return IS_DIRTY;
    
    int yellowValue = rgba->r + rgba->g;
    int greenValue = rgba->g + rgba->b;
    int pinkValue = rgba->r + rgba->b;
    
    BOOL isPinkSerial = pinkValue > greenValue;
    if (isPinkSerial)
    {
        if(pinkValue>yellowValue)
            return IS_CLEAN;
        else
            return IS_DIRTY;
    }
    else //means green serial
    {
        return IS_DIRTY;
    }
}

-(double)getRSFValue:(RGBA)blank
     withSampleColor:(RGBA)sample{
    
    double E535_S,E435_S,E405_S,Mn7_S,Mn6_S,Mn2_S,E535_CS,E435_CS,E405_CS,Mn7_CS,Mn6_CS,Mn2_CS,I,T,RSF;
//    double mgl_CH2O,ug_cm2,Mn7R,ERR,maxmgl,maxug,RSFGO;
    I=4.07;
    T=8.53;

    E535_S = ((-log10(((blank.r/(I-4.0)*((T-4.0)*100.0/16.0*(-0.3327)+107.64)/100.0))/3205.0))*112.0+(-log10(((blank.g/(I-4.0)*((T-4.0)*100.0/16.0*(-0.3327)+107.64)/100.0))/3205.0))*411.0)/100.0;
    E435_S = ((-log10(((blank.r/(I-4)*((T-4)*100.0/16.0*(-0.3327)+107.64)/100))/3205))*35+(-log10(((blank.b/(I-4)*((T-4)*100/16*(-0.3327)+107.64)/100))/3205))*306)/100;
    E405_S = ((-log10(((blank.r/(I-4)*((T-4)*100/16*(-0.3327)+107.64)/100))/3205))*130+(-log10(((blank.b/(I-4)*((T-4)*100/16*(-0.3327)+107.64)/100))/3205))*200)/100;
    
    // Berechnungsstufe 2_S:
    
    Mn7_S = (-1670.2*E535_S-1969.1*E435_S+4201.7*E405_S)/(-26606.7);
    Mn6_S = (-555.1*E535_S-5931*E435_S+8130.7*E405_S)/(26606.7);
    Mn2_S = (E535_S-26.6*(-1670.2*E535_S-1969.1*E435_S+4201.7*E405_S)/(-26606.7)-20*(-555.1*E535_S-5931*E435_S+8130.7*E405_S)/(26606.7))/18.3;
    
    // Berechnungsstufe 1_CS:
    
    E535_CS = ((-log10(((sample.r/(I-4)*((T-4)*100/16*(-0.3327)+107.64)/100))/3205))*112+(-log10(((sample.g/(I-4)*((T-4)*100/16*(-0.3327)+107.64)/100))/3205))*411)/100;
    E435_CS = ((-log10(((sample.r/(I-4)*((T-4)*100/16*(-0.3327)+107.64)/100))/3205))*35+(-log10(((sample.b/(I-4)*((T-4)*100/16*(-0.3327)+107.64)/100))/3205))*306)/100;
    E405_CS = ((-log10(((sample.r/(I-4)*((T-4)*100/16*(-0.3327)+107.64)/100))/3205))*130+(-log10(((sample.b/(I-4)*((T-4)*100/16*(-0.3327)+107.64)/100))/3205))*200)/100;
    
    // Berechnungsstufe 2_CS:
    
    Mn7_CS = (-1670.2*E535_CS-1969.1*E435_CS+4201.7*E405_CS)/(-26606.7);
    Mn6_CS = (-555.1*E535_CS-5931*E435_CS+8130.7*E405_CS)/(26606.7);
    Mn2_CS = (E535_CS-26.6*(-1670.2*E535_CS-1969.1*E435_CS+4201.7*E405_CS)/(-26606.7)-20*(-555.1*E535_CS-5931*E435_CS+8130.7*E405_CS)/(26606.7))/18.3;
    
    // Berechnungsstufe 3:
    
    RSF = (Mn6_S - Mn6_CS) + ((Mn2_S - Mn2_CS)*4);
//    Mn7R = (Mn7_CS - Mn7_S);
//    ERR = fabs((Mn7R-RSF)*100/Mn7R);
    return RSF;
}

-(int)getColorHighLightStatus:(RGBA)rgbColor{
    
    float yellowValue = rgbColor.r + rgbColor.g;
    float greenValue = rgbColor.g + rgbColor.b;
    float pinkValue = rgbColor.r + rgbColor.b;
    pinkValue = pinkValue + 20;
    
    if((pinkValue>greenValue)&&(pinkValue>yellowValue)){
        return PINK;
    }
    if((yellowValue>greenValue)&&(yellowValue>pinkValue)){
        return YELLOW;
    }
    
    if((rgbColor.b>=rgbColor.g)&&(rgbColor.b>=rgbColor.r)){
        return BLUE;
    }else{
        return GREEN;
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

- (RGBA )updateHSBValue:(RGBA )rgbColor
             withHValue :(float)hValue{
    UIColor *color = [UIColor colorWithRed:(float)rgbColor.r/255 green:(float)rgbColor.g/255 blue:(float)rgbColor.b/255 alpha:1.0];
    
    CGFloat hue;
    CGFloat saturation;
    CGFloat brightness;
    CGFloat alpha;
    BOOL success = [color getHue:&hue saturation:&saturation brightness:&brightness alpha:&alpha];
    NSLog(@"success: %i hue: %0.2f, saturation: %0.2f, brightness: %0.2f, alpha: %0.2f", success, hue, saturation, brightness, alpha);
    hue = hue - (float)hValue/360;
    
    UIColor *newColor = [UIColor colorWithHue:hue saturation:saturation brightness:brightness alpha:alpha];

    CGFloat red;
    CGFloat blue;
    CGFloat green;

    [newColor getRed:&red green:&green blue:&blue alpha:&alpha];
    
    RGBA newRGBA;
    newRGBA.r = red * 255;
    newRGBA.g = green * 255;
    newRGBA.b = blue * 255;

    return newRGBA;
}

@end
