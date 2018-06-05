//
//  SGCustomCameraViewController.m
//  SmartGel
//
//  Created by jordi on 30/04/2018.
//  Copyright © 2018 AFCO. All rights reserved.
//

#import "SGCustomCameraViewController.h"

@interface SGCustomCameraViewController ()

@end

@implementation SGCustomCameraViewController

@synthesize captureManager;
@synthesize videoPreviewView;
@synthesize captureVideoPreviewLayer;

- (void)viewDidLoad {
    [super viewDidLoad];
    self.autoDetectionEngine = [[AutoDetectionEngine alloc] init];
//    [[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];
//    [[NSNotificationCenter defaultCenter]
//     addObserver:self selector:@selector(orientationChanged:)
//     name:UIDeviceOrientationDidChangeNotification
//     object:[UIDevice currentDevice]];
//    isProcessing = false;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
//    [self initVideoCaptureSession];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self releasemanager];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void) orientationChanged:(NSNotification *)note
{
    [self releasemanager];
    [self initVideoCaptureSession];
}

- (void)releasemanager
{
    [[self.captureManager session] stopRunning];
    self.captureManager = nil;
    [self.captureVideoPreviewLayer removeFromSuperlayer];
    self.captureVideoPreviewLayer = nil;
    
}

- (void)initVideoCaptureSession{
    if (self.captureManager == nil) {
        self.captureManager = [[AVCamCaptureManager alloc] init];
        [self setCaptureManager:self.captureManager];
        self.captureManager.delegate = self;
        [self.captureManager setupCaptureSession];
        self.captureVideoPreviewLayer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:self.captureManager.session];
        CALayer* viewLayer = self.videoPreviewView.layer;

        //[viewLayer setMasksToBounds:YES];
        CGRect bounds = self.videoPreviewView.bounds;
        [self.captureVideoPreviewLayer setFrame:bounds];
        
        [self.captureVideoPreviewLayer setVideoGravity:AVLayerVideoGravityResizeAspectFill];
        
        [viewLayer insertSublayer:self.captureVideoPreviewLayer
                            below:[viewLayer.sublayers objectAtIndex:0]];
        UIDevice *device = [UIDevice currentDevice];
        switch(device.orientation)
        {
            case UIDeviceOrientationPortrait:
                [self.captureVideoPreviewLayer.connection setVideoOrientation:AVCaptureVideoOrientationPortrait];
                break;
            case UIDeviceOrientationLandscapeLeft:
                [self.captureVideoPreviewLayer.connection setVideoOrientation:AVCaptureVideoOrientationLandscapeRight];
                break;
            case UIDeviceOrientationLandscapeRight:
                [self.captureVideoPreviewLayer.connection setVideoOrientation:AVCaptureVideoOrientationLandscapeLeft];
                break;
            case UIDeviceOrientationPortraitUpsideDown:
                [self.captureVideoPreviewLayer.connection setVideoOrientation:AVCaptureVideoOrientationPortraitUpsideDown];
                break;
            default:
                break;
        };

        [self setCaptureVideoPreviewLayer:self.captureVideoPreviewLayer];
        // Start the session. This is done asychronously since -startRunning doesn't return until the session is running.
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            [[self.captureManager session] startRunning];
        });
    }
}

- (void) captureManagerRealTimeImageCaptured:(CVImageBufferRef )imageBuffer withTimeStamp:(CMTime)timeStamp{
    if(!isProcessing){
        isProcessing = true;
        CIImage *ciImage = [[CIImage alloc] initWithCVImageBuffer:imageBuffer];
        UIImage *uiImage = [[SGImageUtil sharedImageUtil] imageFromCIImage:ciImage];        
        __weak typeof(self) wself = self;
        if([self.autoDetectionEngine analyzeImage:uiImage]){
            dispatch_async(dispatch_get_main_queue(), ^{
                if(wself){
                    [self.statusLabel setText:@"detected clean bottles"];
                    UIImageWriteToSavedPhotosAlbum(uiImage,nil,nil,nil);
                    if(self.delegate){
                        [self.delegate onDetectedImage:uiImage];
                    }
                    [self.navigationController popViewControllerAnimated:YES];
                }
            });
            isProcessing = false;
        }else{
            dispatch_async(dispatch_get_main_queue(), ^{
                if(wself){
                    [self.statusLabel setText:@"no clean bottles"];
                }
            });
            isProcessing = false;
        }
    }
}


/// testing mode with test image
- (void) initTestImage{
    self.testImageArray = [NSArray arrayWithObjects:@"0.5mg:L_after5min_-0.01.jpeg",
                           @"0.5mg:L_after5min_0.02.jpeg",
                           @"1mg:L_after5min_0.04_2.jpeg",
                           @"1mg:L_after5min_0.04.jpeg",
                           @"1mg:L_after5min_3.jpeg",
                           @"1mg:L_after5min_4.jpeg",
                           @"2mg_nach_1min_0.01.jpeg",
                           @"2mg:L_after5min_0.04_2.jpeg",
                           @"2mg:L_after5min_0.04.jpeg",
                           @"4mg:L_after5min_0.06.jpeg",
                           @"8mg:L_after5min_0.08_2.jpeg",
                           @"8mg:L_after5min_0.16.jpeg",
                           @"8mg:Lafter5min_0.08.jpeg",
                           @"10mg:L_after5min_0.08.jpeg",
                           @"10mg:L_after5min_0.09.jpeg",
                           @"15mg:L_after5min_0.09.jpeg",
                           @"15mg:L_after5min_0.12_2.jpeg",
                           @"15mg:L_after5min_0.12.jpeg",
                           @"20mg:L_after5min_0.11.jpeg",
                           @"20mg:L_after5min_0.16.jpeg",
                           @"20mg:L_after5min_0.17.jpeg",
                           @"20mg:L_after10min_0.24.jpeg",
                           @"blank_-0.15.jpeg",
                           nil];
    testImageIndex = 0;
}

-(IBAction)testButtonClicked:(id)sender{
    
    NSString *imageFileName = [self.testImageArray objectAtIndex:testImageIndex];
    UIImage *image = [UIImage imageNamed:imageFileName];
    
//    if(self.delegate){
//        [self.delegate onDetectedImage:uiImage];
//    }
//    [self.navigationController popViewControllerAnimated:YES];
    if(testImageIndex == self.testImageArray.count)
        testImageIndex =0;
}


@end
