//
//  SGHomeViewController.h
//  SmartGel
//
//  Created by jordi on 28/09/2017.
//  Copyright © 2017 AFCO. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "SGBaseViewController.h"

#import "MBProgressHUD.h"
#import "EstimateImageModel.h"
#import "DirtyExtractor.h"
#import "RESideMenu.h"
#import "SGGridView.h"
#import "UIImageView+WebCache.h"
#import "SGTagViewController.h"
#import "SGCleanEditView.h"

typedef enum {
    NonGel,
    Clean,
    Dirty,
    Erase
} AddingType;

@interface SGHomeViewController : SGBaseViewController<UIImagePickerControllerDelegate,UINavigationControllerDelegate,CLLocationManagerDelegate,SGTagViewControllerDelegate,SGCleanEditViewDelegate>{
    bool isShowDirtyArea;
    bool isSavedImage;
    bool isSelectedFromCamera;
    bool isTakenPhoto;
    bool isAddCleanArea;
    bool isShowedAddingCleanAlert;
    MBProgressHUD *hud;
    
    BOOL isFullScreen;
    CGRect prevFrame;
}

@property (strong, nonatomic) IBOutlet UILabel *valueLabel;
@property (strong, nonatomic) IBOutlet UILabel *dirtyvalueLabel;

@property (strong, nonatomic) IBOutlet UILabel *dateLabel;
@property (strong, nonatomic) IBOutlet UILabel *locationLabel;

@property (strong, nonatomic) IBOutlet UIButton *nonGelButton;
@property (strong, nonatomic) IBOutlet UIButton *cleanButton;
@property (strong, nonatomic) IBOutlet UIButton *dirtyButton;
@property (strong, nonatomic) IBOutlet UIButton *zoomButton;

@property (strong, nonatomic) IBOutlet UIButton *nonGelLargeButton;
@property (strong, nonatomic) IBOutlet UIButton *cleanLargeButton;
@property (strong, nonatomic) IBOutlet UIButton *dirtyLargeButton;
@property (strong, nonatomic) IBOutlet UIButton *resetLargeButton;
@property (strong, nonatomic) IBOutlet UIButton *cropLargeButton;

@property (strong, nonatomic) IBOutlet UIButton *zoomLargeButton;


@property (strong, nonatomic) IBOutlet UIButton *resetButton;
@property (strong, nonatomic) IBOutlet UIButton *cropButton;

@property (strong, nonatomic) IBOutlet UIImage *originalImage;

@property (strong, nonatomic) IBOutlet UILabel *tagLabel;
@property (strong, nonatomic) IBOutlet UIImageView *tagImageView;

@property (strong, nonatomic) IBOutlet UIView *manualModeView;
@property (strong, nonatomic) IBOutlet SGCleanEditView *cleanEditView;

@property (nonatomic, strong) DirtyExtractor *engine;
@property (nonatomic, strong) DirtyExtractor *manualEngine;

@property (strong, nonatomic) CLLocationManager *locationManager;
@property (strong, nonatomic) EstimateImageModel *estimateImage;
@property (strong, nonatomic) EstimateImageModel *manualEstimateImage;

@property (strong, nonatomic) SGTag *selectedTag;

@property (assign) int addingType;
@end
