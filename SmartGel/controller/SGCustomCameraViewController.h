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
#import "SGBaseViewController.h"

#define RECT_SIZE 50
@protocol SGCustomCameraViewControllerDelegate <NSObject>
@required
- (void)onDetectedImage:(UIImage *)image;
@end

@interface SGCustomCameraViewController : SGBaseViewController<AVCamCaptureManagerDelegate,AVCaptureVideoDataOutputSampleBufferDelegate>{
    bool isProcessing;
}

@property (weak, nonatomic) id<SGCustomCameraViewControllerDelegate> delegate;

@property (nonatomic,retain) AVCamCaptureManager *captureManager;
@property (nonatomic,retain) AVCaptureVideoPreviewLayer *captureVideoPreviewLayer;

@property (strong, nonatomic) IBOutlet UIView *videoPreviewView;

@property (strong, nonatomic) IBOutlet UILabel *statusLabel;
@property (strong, nonatomic) AutoDetectionEngine *autoDetectionEngine;

@property (strong, nonatomic) UIView *markView1;
@property (strong, nonatomic) UIView *markView2;

@end
