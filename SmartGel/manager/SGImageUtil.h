//
//  SGImageUtil.h
//  SmartGel
//
//  Created by jordi on 11/05/2018.
//  Copyright © 2018 AFCO. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SGImageUtil : NSObject
+ (instancetype)sharedImageUtil;

- (UIImage *)imageFromCIImage:(CIImage *)ciImage
               withImageSize :(CGSize)imageSize;
@end
