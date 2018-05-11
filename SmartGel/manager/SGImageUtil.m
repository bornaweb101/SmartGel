//
//  SGImageUtil.m
//  SmartGel
//
//  Created by jordi on 11/05/2018.
//  Copyright © 2018 AFCO. All rights reserved.
//

#import "SGImageUtil.h"

@implementation SGImageUtil

+ (instancetype)sharedImageUtil {
    static id _sharedImageUtil = nil;
    static dispatch_once_t onceToken;
    
    _dispatch_once(&onceToken, ^{
        _sharedImageUtil = [[SGImageUtil alloc] init];
    });
    
    return _sharedImageUtil;
}

- (instancetype)init {
    if (self = [super init]) {
    }
    return self;
}

- (UIImage *)imageFromCIImage:(CIImage *)ciImage {    
    CIContext *ciContext = [CIContext contextWithOptions:nil];
    CGImageRef cgImage = [ciContext createCGImage:ciImage fromRect:[ciImage extent]];
    UIImage *image;
    UIDevice *device = [UIDevice currentDevice];
    switch(device.orientation)
    {
        case UIDeviceOrientationPortrait:
            image = [UIImage imageWithCGImage:cgImage scale:1.0 orientation:UIImageOrientationRight];
            break;
        case UIDeviceOrientationLandscapeLeft:
            image = [UIImage imageWithCGImage:cgImage scale:1.0 orientation:UIImageOrientationUp];
            break;
        case UIDeviceOrientationLandscapeRight:
            image = [UIImage imageWithCGImage:cgImage scale:1.0 orientation:UIImageOrientationDown];
            break;
        case UIDeviceOrientationPortraitUpsideDown:
            image = [UIImage imageWithCGImage:cgImage scale:1.0 orientation:UIImageOrientationLeft];
            break;
        default:
            break;
    };
    CGImageRelease(cgImage);
    return image;
}


@end
