//
//  SGColorUtil.h
//  SmartGel
//
//  Created by jordi on 09/05/2018.
//  Copyright © 2018 AFCO. All rights reserved.
//

#import <UIKit/UIKit.h>

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

-(float)getDistancebetweenColors:(RGBA *)rgba1
                            with:(RGBA *)rgba2;
- (CGContextRef) createARGBBitmapContextFromImage:(CGImageRef) inImage;

@end
