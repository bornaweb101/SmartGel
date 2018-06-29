//
//  SGColorUtil.h
//  SmartGel
//
//  Created by jordi on 09/05/2018.
//  Copyright © 2018 AFCO. All rights reserved.
//

#import <UIKit/UIKit.h>

#define AREA_DIVIDE_NUMBER      100
#define CLEAN_MAX_VALUE      10

#define IS_CLEAN 1
#define IS_DIRTY 2
#define NO_GEL   3

#define RED 1
#define GREEN 2
#define BLUE  3

#define NO_DIRTY_PIXEL          0x0
#define PINK_DIRTY_PIXEL        0xFF00FFFF
#define BLUE_DIRTY_PIXEL        0x00FFFFFF

#define PIXEL_STEP              3
#define AREA_DIRTY_RATE      0.8

#define MAX_DIRTY_VALUE         10.0f

#define MIN_LOCAL_AREA_PERCENT  0.01f
#define PINK_COLOR_OFFSET  25.0f

typedef struct
{
    UInt8 a;
    UInt8 b;
    UInt8 g;
    UInt8 r;
}RGBA;

typedef struct
{
    float x;
    float y;
    float z;
}XYZ;

typedef struct
{
    float l;
    float a;
    float b;
}LAB;

@interface SGColorUtil : NSObject

+ (instancetype)sharedColorUtil;

- (UInt32)   getDirtyPixel:(RGBA *)rgba
           withColorOffset:(int)colorOffset;

-(float)getDistancebetweenColors:(RGBA *)rgba1
                            with:(RGBA *)rgba2;
- (CGContextRef) createARGBBitmapContextFromImage:(CGImageRef) inImage;
- (UInt32)getDirtyPixelLaboratory:(RGBA *)rgba;

- (RGBA )updateHSBValue:(RGBA )rgbColor
            withHValue :(float)hValue;


@end
