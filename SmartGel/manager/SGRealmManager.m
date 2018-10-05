//
//  SGRealmManager.m
//  SmartGel
//
//  Created by rockstar on 10/4/18.
//  Copyright © 2018 AFCO. All rights reserved.
//

#import "SGRealmManager.h"
#import "SGLaboratorySample.h"

@implementation SGRealmManager

+ (instancetype)sharedManager {
    static id _sharedManager = nil;
    static dispatch_once_t onceToken;
    
    _dispatch_once(&onceToken, ^{
        _sharedManager = [[SGRealmManager alloc] init];
    });
    
    return _sharedManager;
}

-(void)addLaboartorySampleData :(SGLaboratorySample *)sampleData{
    RLMRealm *realm = [RLMRealm defaultRealm];
    [realm transactionWithBlock:^{
        [realm addObject:sampleData];
    }];
}

-(RLMResults<SGLaboratorySample *> *)getAllLabortorySampleDatas{
    self.sampleDatas = [SGLaboratorySample allObjects];
    return self.sampleDatas;
}


@end
