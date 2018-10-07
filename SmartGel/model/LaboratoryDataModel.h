//
//  LaboratoryDataModel.h
//  SmartGel
//
//  Created by jordi on 08/12/2017.
//  Copyright © 2017 AFCO. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "Firebase.h"

@interface LaboratoryDataModel : NSObject

@property (strong, nonatomic) UIImage *image;
@property (strong, nonatomic) NSString *imageUrl;
@property (assign, nonatomic) float cleanValue;
@property (assign, nonatomic) float filterValue;

@property (strong, nonatomic) NSString *location;
@property (strong, nonatomic) NSString *date;
@property (strong, nonatomic) NSString *unit;
@property (strong, nonatomic) NSString *tag;
@property (strong, nonatomic) NSString *customer;
@property (assign, nonatomic) int64_t blankColor;
@property (assign, nonatomic) int64_t sampleColor;

@property (assign, nonatomic) int resultState;
@property (assign, nonatomic) bool islaboratory;

@property (strong, nonatomic) NSString *productName;
@property (strong, nonatomic) NSString *panelName;

-(instancetype)initWithSnapshot:(FIRDataSnapshot *) snapshot;

@end
