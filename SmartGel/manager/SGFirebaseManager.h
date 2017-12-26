//
//  SGFirebaseManager.h
//  SmartGel
//
//  Created by jordi on 22/12/2017.
//  Copyright © 2017 AFCO. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Firebase.h"
#import "SGUser.h"
#import "EstimateImageModel.h"
#import "LaboratoryDataModel.h"

@interface SGFirebaseManager : NSObject
+ (instancetype)sharedManager;

@property (strong, nonatomic) SGUser *currentUser;
@property (strong, nonatomic) FIRDatabaseReference *dataBaseRef;
@property (strong, nonatomic) FIRStorageReference *storageRef;

- (void)registerWithCompanyname:(NSString *)companyName
                          email:(NSString *)email
                       password:(NSString *)password
              completionHandler:(void (^)(NSError *error, SGUser *sgUser))completionHandler;

- (void)signInWithEmail:(NSString *)email
               password:(NSString *)password
       completionHandler:(void (^)(NSError *error, SGUser *sgUser))completionHandler;

-(void)getCurrentUserwithUserID:(NSString *)userID
              completionHandler:(void (^)(NSError *error, SGUser *sgUser))completionHandler;

-(void)saveResultImage:(EstimateImageModel *)estimateImageModel
     engineColorOffset:(int)colorOffset
     completionHandler:(void (^)(NSError *error))completionHandler ;

-(void)getSmartGelHistorys:(void (^)(NSError *error,NSMutableArray* array))completionHandler;

-(void)removeSmartGelHistory:(EstimateImageModel *)estimateImageModel
           completionHandler:(void (^)(NSError *error))completionHandler;

-(void)saveLaboratoryResult:(LaboratoryDataModel *)laboratoryData
          completionHandler:(void (^)(NSError *error))completionHandler ;

@end