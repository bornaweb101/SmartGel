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

@property (strong, nonatomic) IBOutlet UIImageView *takenImageView;
@property (strong, nonatomic) IBOutlet UILabel *valueLabel;
@property (strong, nonatomic) IBOutlet UILabel *dirtyvalueLabel;

@property (strong, nonatomic) IBOutlet UILabel *dateLabel;
@property (strong, nonatomic) IBOutlet UILabel *locationLabel;
@property (strong, nonatomic) IBOutlet UILabel *notificationLabel;

@property (strong, nonatomic) IBOutlet UIButton *showCleanAreaButton;
@property (strong, nonatomic) IBOutlet UIButton *addManualAreaButton;
@property (strong, nonatomic) IBOutlet UILabel *addManualAreaLabel;
@property (strong, nonatomic) IBOutlet UILabel *showCleanAreaLabel;
@property (strong, nonatomic) IBOutlet UIButton *takePhotoButton;

@property (strong, nonatomic) IBOutlet UILabel *tagLabel;
@property (strong, nonatomic) IBOutlet UIImageView *tagImageView;

@property (strong, nonatomic) IBOutlet SGCleanEditView *cleanEditView;
//@property (strong, nonatomic) SGCleanEditView *cleanEditView;

@property (nonatomic, strong) DirtyExtractor *engine;
@property (nonatomic, strong) DirtyExtractor *partyEngine;

@property (strong, nonatomic) CLLocationManager *locationManager;
@property (strong, nonatomic) EstimateImageModel *estimateImage;

@property (strong, nonatomic) SGTag *selectedTag;
@property (strong, nonatomic) NSMutableArray *cleanareaViews;
@property (strong, nonatomic) NSMutableArray *orignialcleanareaViews;

@end
