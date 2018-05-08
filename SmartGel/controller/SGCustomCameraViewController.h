//
//  SGCustomCameraViewController.h
//  SmartGel
//
//  Created by jordi on 30/04/2018.
//  Copyright © 2018 AFCO. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AVCamCaptureManager.h"
#import "LaboratoryEngine.h"

@interface SGCustomCameraViewController : UIViewController<AVCamCaptureManagerDelegate,AVCaptureVideoDataOutputSampleBufferDelegate>{
    bool isProcessing;
}

@property (nonatomic,retain) AVCamCaptureManager *captureManager;
@property (nonatomic,retain) AVCaptureVideoPreviewLayer *captureVideoPreviewLayer;

@property (strong, nonatomic) IBOutlet UIView *videoPreviewView;

@property (strong, nonatomic) IBOutlet UILabel *statusLabel;
@property (strong, nonatomic) LaboratoryEngine *laboratoryEngine;
@end
