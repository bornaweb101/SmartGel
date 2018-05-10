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
    isProcessing = false;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self initVideoCaptureSession];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self releasemanager];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)orientationChanged:(NSNotification *)note{
}

- (void)releasemanager
{
    [[self.captureManager session] stopRunning];
    self.captureManager = nil;
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
        UIImage *uiImage = [self imageFromCIImage:ciImage];
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

- (UIImage *)imageFromCIImage:(CIImage *)ciImage {
    CIContext *ciContext = [CIContext contextWithOptions:nil];
    CGImageRef cgImage = [ciContext createCGImage:ciImage fromRect:[ciImage extent]];
    UIImage *image = [UIImage imageWithCGImage:cgImage];
    CGImageRelease(cgImage);
    return image;
}

@end
