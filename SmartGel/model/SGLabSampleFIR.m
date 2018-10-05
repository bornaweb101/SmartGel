//
//  SGLabSampleFIR.m
//  SmartGel
//
//  Created by rockstar on 10/5/18.
//  Copyright © 2018 AFCO. All rights reserved.
//

#import "SGLabSampleFIR.h"

@implementation SGLabSampleFIR


-(instancetype)initWithSnapshot:(FIRDataSnapshot *) snapshot{
    self = [super init];
    if(self){
        self.value = [snapshot.value[@"value"] doubleValue];
        self.r = [snapshot.value[@"r"] intValue];
        self.g = [snapshot.value[@"g"] intValue];
        self.b = [snapshot.value[@"b"] intValue];
        self.tag = snapshot.value[@"tag"];
        self.date = snapshot.value[@"date"];
    }
    return self;
}

@end
