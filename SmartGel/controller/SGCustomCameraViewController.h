//
//  SGCustomCameraViewController.h
//  SmartGel
//
//  Created by jordi on 30/04/2018.
//  Copyright © 2018 AFCO. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AVCamCaptureManager.h"
#import "AutoDetectionEngine.h"
#import "SGImageUtil.h"

@protocol SGCustomCameraViewControllerDelegate <NSObject>
@required
- (void)onDetectedImage:(UIImage *)image;
@end

@interface SGCustomCameraViewController : UIViewController<AVCamCaptureManagerDelegate,AVCaptureVideoDataOutputSampleBufferDelegate>{
    bool isProcessing;
}

@property (weak, nonatomic) id<SGCustomCameraViewControllerDelegate> delegate;

@property (nonatomic,retain) AVCamCaptureManager *captureManager;
@property (nonatomic,retain) AVCaptureVideoPreviewLayer *captureVideoPreviewLayer;

@property (strong, nonatomic) IBOutlet UIView *videoPreviewView;

@property (strong, nonatomic) IBOutlet UILabel *statusLabel;
@property (strong, nonatomic) AutoDetectionEngine *autoDetectionEngine;
@end
