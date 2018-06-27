//
//  SGImageUtil.m
//  SmartGel
//
//  Created by jordi on 11/05/2018.
//  Copyright © 2018 AFCO. All rights reserved.
//

#import "SGImageUtil.h"

#define DEGREES_RADIANS(angle) ((angle) / 180.0 * M_PI)

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

- (UIImage *)imageFromCIImage:(CIImage *)ciImage
               withImageSize :(CGSize)imageSize {
    CIContext *ciContext = [CIContext contextWithOptions:nil];
    CGImageRef cgImage = [ciContext createCGImage:ciImage fromRect:[ciImage extent]];
    UIImage *image;
    UIDevice *device = [UIDevice currentDevice];
    image = [UIImage imageWithCGImage:cgImage];
    
    
    switch(device.orientation)
    {
        case UIDeviceOrientationPortrait:
            image = [self rotatedImage:image withDegrees:90];
            image = [self imageWithImage:image scaledToSize:imageSize];
            break;
        case UIDeviceOrientationLandscapeLeft:
            image = [self imageWithImage:image scaledToSize:CGSizeMake(imageSize.height, imageSize.width)];
            break;
        case UIDeviceOrientationLandscapeRight:
            image = [self rotatedImage:image withDegrees:180];
            image = [self imageWithImage:image scaledToSize:CGSizeMake(imageSize.height, imageSize.width)];
            break;
        case UIDeviceOrientationPortraitUpsideDown:
            image = [self rotatedImage:image withDegrees:-90];
            image = [self imageWithImage:image scaledToSize:imageSize];
            break;
        default:
            break;
    };
    CGImageRelease(cgImage);
    return image;
}

- (UIImage *)rotatedImage:(UIImage *)image
                withDegrees: (CGFloat) degrees // rotation in radians
{
    // Calculate Destination Size
    CGFloat rotation = degrees * M_PI / 180;
    CGAffineTransform t = CGAffineTransformMakeRotation(rotation);
    CGRect sizeRect = (CGRect) {.size = image.size};
    CGRect destRect = CGRectApplyAffineTransform(sizeRect, t);
    CGSize destinationSize = destRect.size;
    
    // Draw image
    UIGraphicsBeginImageContext(destinationSize);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextTranslateCTM(context, destinationSize.width / 2.0f, destinationSize.height / 2.0f);
    CGContextRotateCTM(context, rotation);
    [image drawInRect:CGRectMake(-image.size.width / 2.0f, -image.size.height / 2.0f, image.size.width, image.size.height)];
    
    // Save image
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

- (UIImage*)imageWithImage:(UIImage*)image
              scaledToSize:(CGSize)newSize
{
    UIGraphicsBeginImageContext( newSize );
    [image drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage;
}

-(UIImage *)getImageFromUIView:(UIView *)editedImageView{
    UIGraphicsBeginImageContextWithOptions(editedImageView.bounds.size, NO, 2.0f);
    [editedImageView drawViewHierarchyInRect:editedImageView.bounds afterScreenUpdates:YES];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}


@end
