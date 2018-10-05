//
//  SGLabSampleFIR.h
//  SmartGel
//
//  Created by rockstar on 10/5/18.
//  Copyright © 2018 AFCO. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Firebase.h"

@interface SGLabSampleFIR : NSObject

@property NSString *tag;
@property NSInteger rgbValue;
@property double value;

@property UInt8 b;
@property UInt8 g;
@property UInt8 r;
@property (strong, nonatomic) NSString *date;

-(instancetype)initWithSnapshot:(FIRDataSnapshot *) snapshot;

@end
