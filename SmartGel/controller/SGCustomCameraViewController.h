//
//  SGCustomCameraViewController.h
//  SmartGel
//
//  Created by jordi on 30/04/2018.
//  Copyright © 2018 AFCO. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AVCamCaptureManager.h"

@interface SGCustomCameraViewController : UIViewController<AVCamCaptureManagerDelegate,AVCaptureVideoDataOutputSampleBufferDelegate>

@property (nonatomic,retain) AVCamCaptureManager *captureManager;
@property (nonatomic,retain) AVCaptureVideoPreviewLayer *captureVideoPreviewLayer;

@property (strong, nonatomic) IBOutlet UIView *videoPreviewView;

@end
