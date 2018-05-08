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
    self.laboratoryEngine = [[LaboratoryEngine alloc] init];
    isProcessing = false;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self initVideoCaptureSession];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)orientationChanged:(NSNotification *)note
{
}


- (void)initVideoCaptureSession{
    if (self.captureManager == nil) {
        AVCamCaptureManager* manager = [[AVCamCaptureManager alloc] init];
        [self setCaptureManager:manager];
        self.captureManager.delegate = self;
        [self.captureManager setupCaptureSession];
        AVCaptureVideoPreviewLayer*newCaptureVideoPreviewLayer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:self.captureManager.session];
        CALayer* viewLayer = self.videoPreviewView.layer;

        //[viewLayer setMasksToBounds:YES];
        CGRect bounds = self.videoPreviewView.bounds;
        [newCaptureVideoPreviewLayer setFrame:bounds];
        
        [newCaptureVideoPreviewLayer setVideoGravity:AVLayerVideoGravityResizeAspectFill];
        
        [viewLayer insertSublayer:newCaptureVideoPreviewLayer
                            below:[viewLayer.sublayers objectAtIndex:0]];

        [self setCaptureVideoPreviewLayer:newCaptureVideoPreviewLayer];
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
        if([self.laboratoryEngine analyzeImage:uiImage]){
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.statusLabel setText:@"detected clean bottles"];
                UIImageWriteToSavedPhotosAlbum(uiImage,nil,nil,nil);
            });
            isProcessing = false;
        }else{
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.statusLabel setText:@"no clean bottles"];
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
