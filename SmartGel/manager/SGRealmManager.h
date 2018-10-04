//
//  SGRealmManager.h
//  SmartGel
//
//  Created by rockstar on 10/4/18.
//  Copyright © 2018 AFCO. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Realm/RLMRealm.h>
#import <Realm/RLMArray.h>

#import "SGLaboratorySample.h"

@interface SGRealmManager : NSObject

@property (strong, nonatomic) RLMRealm *realm;
@property (strong, nonnull) RLMResults *sampleDatas;

+ (instancetype)sharedManager;


@end
