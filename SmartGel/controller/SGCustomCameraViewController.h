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

@protocol SGCustomCameraViewControllerDelegate <NSObject>
@required
- (void)onDetectedImage:(UIImage *)image;
@end

@interface SGCustomCameraViewController : SGBaseViewController<AVCamCaptureManagerDelegate,AVCaptureVideoDataOutputSampleBufferDelegate>{

    bool isProcessing;
    int detectedCount;
    
//    float detectArea_width;
//    float detectArea_Height;
//    
//    float detectAread_interval;
    CGSize capturedImageSize;
    
    CGRect rectSample;
    CGRect rectBlank;
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
