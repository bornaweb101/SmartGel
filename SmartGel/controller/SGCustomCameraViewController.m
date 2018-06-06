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
    [[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];
    [[NSNotificationCenter defaultCenter]
     addObserver:self selector:@selector(orientationChanged:)
     name:UIDeviceOrientationDidChangeNotification
     object:[UIDevice currentDevice]];
    isProcessing = false;
    [self initMarkView];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.appDelegate.isLaboratory = true;
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

-(void)initMarkView{
    CGRect rect1 = CGRectMake(self.view.frame.size.width/2 - self.view.frame.size.width/8 - RECT_SIZE , (self.view.frame.size.height*4)/10, RECT_SIZE, RECT_SIZE);
    CGRect rect2 = CGRectMake(self.view.frame.size.width/2 + self.view.frame.size.width/8, (self.view.frame.size.height*4)/10, RECT_SIZE, RECT_SIZE);
    
    self.markView1 = [self drawRectangle:rect1];
    self.markView2 = [self drawRectangle:rect2];
    [self.view addSubview:self.markView1];
    [self.view addSubview:self.markView2];
    
    [self.markView1 setHidden:true];
    [self.markView2 setHidden:true];
}

-(void)markViewHidden:(bool)isHidden{
    [self.markView1 setHidden:isHidden];
    [self.markView2 setHidden:isHidden];
}

- (void) orientationChanged:(NSNotification *)note
{
    [self releasemanager];
    [self initVideoCaptureSession];
    [self.markView1 removeFromSuperview];
    [self.markView2 removeFromSuperview];
    [self initMarkView];
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
                    [self markViewHidden:false];
                    [[self.captureManager session] stopRunning];
                    
                    double delayInSeconds = 2.0;
                    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
                    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                        UIImageWriteToSavedPhotosAlbum(uiImage,nil,nil,nil);
                        if(self.delegate){
                            [self.delegate onDetectedImage:uiImage];
                        }
                        [self.navigationController popViewControllerAnimated:YES];
                    });
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

-(UIView *)drawRectangle:(CGRect)rect{
    UIView *rectView  = [[UIView alloc] initWithFrame:rect];
    rectView.backgroundColor = [UIColor clearColor];
    rectView.layer.borderColor = [UIColor greenColor].CGColor;
    rectView.layer.borderWidth = 3.0f;
    [rectView.layer setMasksToBounds:true];
    return rectView;
}

@end
