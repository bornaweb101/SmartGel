//
//  SGLaboratorySample.h
//  SmartGel
//
//  Created by rockstar on 10/4/18.
//  Copyright © 2018 AFCO. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Realm/RLMObject.h>

@interface SGLaboratorySample : RLMObject
@property NSString *tag;
@property NSInteger rgbValue;
@property double value;

@property NSInteger b;
@property NSInteger g;
@property NSInteger r;

@end
