//
//  SGCustomCameraViewController.m
//  SmartGel
//
//  Created by jordi on 30/04/2018.
//  Copyright © 2018 AFCO. All rights reserved.
//

#import "SGCustomCameraViewController.h"
#import "LaboratoryEngine.h"

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
    isStartTracking = false;
    self.navigationItem.title = @"Stopped Tracking";
    [self startTracking];
}


-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.appDelegate.isLaboratory = false;
    detectedCount = 0;
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self initVideoCaptureSession];

//    [self initDetectAreaSize];
//    [self initMarkView];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self releasemanager];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)initDetectAreaSize{
    float width = self.videoPreviewView.bounds.size.width;
    float height = self.videoPreviewView.bounds.size.height;
    
    float detectAread_interval;
    float detectArea_width = width/2-width/10-15;
    float detectArea_Height = height/2-height/10-15;
    
    capturedImageSize = self.videoPreviewView.bounds.size;
    
    UIDevice *device = UIDevice.currentDevice;
    if(device.orientation == UIDeviceOrientationPortrait){
        detectAread_interval = width/10;
        rectSample = CGRectMake(self.view.frame.size.width/2 - detectAread_interval - detectArea_width , (self.view.frame.size.height-detectArea_width)/2, detectArea_width, detectArea_width);
        rectBlank = CGRectMake(self.view.frame.size.width/2 + detectAread_interval, (self.view.frame.size.height-detectArea_width)/2, detectArea_width, detectArea_width);
    }else if(device.orientation == UIDeviceOrientationPortraitUpsideDown){
        detectAread_interval = width/10;
        rectBlank = CGRectMake(self.view.frame.size.width/2 - detectAread_interval - detectArea_width , (self.view.frame.size.height-detectArea_width)/2, detectArea_width, detectArea_width);
        rectSample = CGRectMake(self.view.frame.size.width/2 + detectAread_interval, (self.view.frame.size.height-detectArea_width)/2, detectArea_width, detectArea_width);
    }else if(device.orientation == UIDeviceOrientationLandscapeLeft){
        detectAread_interval = height/10;
        rectSample = CGRectMake((self.view.frame.size.width-detectArea_width)/2, self.view.frame.size.height/2 - detectAread_interval - detectArea_width ,detectArea_width, detectArea_width);
        rectBlank = CGRectMake((self.view.frame.size.width-detectArea_width)/2, self.view.frame.size.height/2 + detectAread_interval,  detectArea_width, detectArea_width);
    }
    else{
        detectAread_interval = height/10;
        rectBlank = CGRectMake((self.view.frame.size.width-detectArea_width)/2, self.view.frame.size.height/2 - detectAread_interval - detectArea_width ,detectArea_width, detectArea_width);
        rectSample = CGRectMake((self.view.frame.size.width-detectArea_width)/2, self.view.frame.size.height/2 + detectAread_interval,  detectArea_width, detectArea_width);
    }
}

-(void)initMarkView{
    
    if(self.markView1!=nil){
        [self.markView1 removeFromSuperview];
    }
    
    if(self.markView2!=nil){
        [self.markView2 removeFromSuperview];
    }
    
    if(isStartTracking){
        self.markView1 = [self drawRectangle:rectSample withColor:UIColor.redColor];
        self.markView2 = [self drawRectangle:rectBlank withColor:UIColor.greenColor];
        [self.view addSubview:self.markView1];
        [self.view addSubview:self.markView2];
    }
}

-(void)removeMarkView{
    if(self.markView1!=nil){
        [self.markView1 removeFromSuperview];
    }
    if(self.markView2!=nil){
        [self.markView2 removeFromSuperview];
    }
    self.markView1 = nil;
    self.markView2 = nil;
}

-(void)markViewHidden:(bool)isHidden{
    [self.markView1 setHidden:isHidden];
    [self.markView2 setHidden:isHidden];
}

- (void) orientationChanged:(NSNotification *)note
{
    [self.markView1 removeFromSuperview];
    [self.markView2 removeFromSuperview];
    
    
    UIDevice *device = UIDevice.currentDevice;
    if(device.orientation == UIDeviceOrientationLandscapeLeft ||
       device.orientation == UIDeviceOrientationLandscapeRight){
        [self showAlert];
        [self stopTracking];
    }else{
        [self startTracking];
        if(isShowAlert){
            [self dismissViewControllerAnimated:YES completion:nil];
            isShowAlert = false;
        }
    }
    [self initDetectAreaSize];
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
        
        [self setCaptureVideoPreviewLayer:self.captureVideoPreviewLayer];
        // Start the session. This is done asychronously since -startRunning doesn't return until the session is running.
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            [[self.captureManager session] startRunning];
        });
    }
}

- (void) captureManagerRealTimeImageCaptured:(CVImageBufferRef )imageBuffer withTimeStamp:(CMTime)timeStamp{
    if((isStartTracking) && (!isProcessing)){
        isProcessing = true;
        CIImage *ciImage = [[CIImage alloc] initWithCVImageBuffer:imageBuffer];
        self.capturedImage = [[SGImageUtil sharedImageUtil] imageFromCIImage:ciImage withImageSize:capturedImageSize];
        
        __weak typeof(self) wself = self;
        dispatch_async(dispatch_get_main_queue(), ^{
            [self initDetectAreaSize];
//            double resultvalue = [self calculateResultValue:uiImage];
//            self.statusLabel.text = [NSString stringWithFormat:@"%.2f",resultvalue];
        });
        
        if([self.autoDetectionEngine analyzeImage:self.capturedImage withSampleRect:rectSample withBlankRect:rectBlank]){
            detectedCount++;
            dispatch_async(dispatch_get_main_queue(), ^{
                if(wself){
                    [self initMarkView];
                    double resultvalue = [self calculateResultValue:self.capturedImage];
                    self.statusLabel.text = [NSString stringWithFormat:@"%.2f",resultvalue];

                    if(detectedCount>10){
                        [[self.captureManager session] stopRunning];
                        UIImageWriteToSavedPhotosAlbum(self.capturedImage,nil,nil,nil);
                        if(self.delegate){
                            [self.delegate onDetectedImage:self.capturedImage];
                        }
                        [self.navigationController popViewControllerAnimated:YES];
                    }
                }
            });
            isProcessing = false;
        }else{
            detectedCount =  0;
            dispatch_async(dispatch_get_main_queue(), ^{
                if(wself){
                    [self removeMarkView];
                }
            });
            isProcessing = false;
        }
    }
}

-(UIView *)drawRectangle:(CGRect)rect
               withColor:(UIColor*)borderColor{
    UIView *rectView  = [[UIView alloc] initWithFrame:rect];
    rectView.backgroundColor = [UIColor clearColor];
    rectView.layer.borderColor = borderColor.CGColor;
    rectView.layer.borderWidth = 3.0f;
    [rectView.layer setMasksToBounds:true];
    return rectView;
}

-(double)calculateResultValue: (UIImage *)image{
    
    LaboratoryEngine *laboratoryEngine= [[LaboratoryEngine alloc] init];
    RGBA sampleColor = [laboratoryEngine getCropAreaAverageColor:image isSampleColor:true];
    RGBA blankColor = [laboratoryEngine getCropAreaAverageColor:image isSampleColor:false];
    int colorHighLight = [[SGColorUtil sharedColorUtil] getColorHighLightStatus:blankColor];
    
    return [laboratoryEngine calculateResultValue:sampleColor withBlankColor:blankColor withColorHighLight:colorHighLight];
}

-(IBAction)startTrackingButtonClicked{
    
    if(isStartTracking){
        [self stopTracking];
    }else{
        [self startTracking];
    }
    [self removeMarkView];
    detectedCount = 0;
}

- (void)stopTracking{
    self.navigationItem.title = @"Stopped Tracking";
    [self.startButton setTitle:@"Start Tracking" forState:UIControlStateNormal];
    isStartTracking = false;
}

-(void)startTracking{
    self.navigationItem.title = @"Tracking...";
    [self.startButton setTitle:@"Stop tracking" forState:UIControlStateNormal];
    isStartTracking = true;
}

-(void)showAlert{
    if(!isShowAlert){
        self.oriWariningalert = [UIAlertController
                                     alertControllerWithTitle:@"Stopped Tracking"
                                     message:@"Auto tracking is only available in portrait screen. Please keep with portrait mode and try to track again."
                                     preferredStyle:UIAlertControllerStyleAlert];

        UIAlertAction* yesButton = [UIAlertAction
                                    actionWithTitle:@"OK"
                                    style:UIAlertActionStyleDefault
                                    handler:^(UIAlertAction * action) {
                                        isShowAlert = false;
                                    }];
        [self.oriWariningalert addAction:yesButton];
        [self presentViewController:self.oriWariningalert animated:YES completion:nil];
        isShowAlert = true;
    }
}

-(IBAction)manualCaptureButtonClick{
    if (self.capturedImage != nil){
        [[self.captureManager session] stopRunning];
        UIImageWriteToSavedPhotosAlbum(self.capturedImage,nil,nil,nil);
        if(self.delegate){
            [self.delegate onDetectedImage:self.capturedImage];
        }
        [self.navigationController popViewControllerAnimated:YES];
    }
}

@end
