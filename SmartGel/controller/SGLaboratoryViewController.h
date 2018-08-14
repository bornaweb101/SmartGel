//
//  SGLaboratoryViewController.h
//  SmartGel
//
//  Created by jordi on 05/12/2017.
//  Copyright © 2017 AFCO. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LaboratoryDataModel.h"
#import "SGBaseViewController.h"
#import "SGCustomCameraViewController.h"
#import "MBProgressHUD.h"
#import "Firebase.h"
#import "LaboratoryEngine.h"
#import <MapKit/MapKit.h>
#import "SCLAlertView.h"

@interface SGLaboratoryViewController : SGBaseViewController<UIImagePickerControllerDelegate,UINavigationControllerDelegate,CLLocationManagerDelegate,SGCustomCameraViewControllerDelegate>{
    int firstrun;
    float vgood,good,satis,adeq,R,G,B,blankR,blankG,blankB,sampleR,sampleG,sampleB;
    uint DIA;
    double Diam;
    NSString *_diam;
    NSString *vgoodlab, *satislab, *inadeqlab,*thePath;
    bool OPorIN,li,ugormg;
    MBProgressHUD *hud;
    bool isSaved;
    int testImageIndex;
    
    
    NSString *prevTag;
    NSString *prevTotalTagText;

    int sameTagCount;
}

@property (strong, nonatomic) LaboratoryDataModel *laboratoryDataModel;
@property (strong, nonatomic) CLLocationManager *locationManager;

@property (strong, nonatomic) IBOutlet UIView *blankView;
@property (strong, nonatomic) IBOutlet UIView *sampleView;
@property (strong, nonatomic) IBOutlet UILabel *resultValueLabel;
@property (strong, nonatomic) IBOutlet UILabel *lbldiam;
@property (strong, nonatomic) IBOutlet UILabel *lblugormg;

@property (strong, nonatomic) UITextField *customerTextField;
@property (strong, nonatomic) UITextField *tagTextField;

//@property (strong, nonatomic) IBOutlet UILabel *timeLabel;

@property (strong, nonatomic) IBOutlet UIImageView *resultfoxImageView;

@property (strong, nonatomic) LaboratoryEngine *laboratoryEngine;


@property (strong, nonatomic) NSArray *testImageArray;
@property (strong, nonatomic) IBOutlet UILabel *testImageLabel;

@property (strong, nonatomic)  SCLAlertView *alertView;

@property (strong, nonatomic) IBOutlet UILabel *testLabel1;
@property (strong, nonatomic) IBOutlet UILabel *testLabel2;


@end
