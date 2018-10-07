//
//  SGLaboratoryViewController.m
//  SmartGel
//
//  Created by jordi on 05/12/2017.
//  Copyright © 2017 AFCO. All rights reserved.
//

#import "SGLaboratoryViewController.h"
#import "SGConstant.h"
#import <ContactsUI/ContactsUI.h>
#import "MBProgressHUD.h"
#import "SGFirebaseManager.h"
#import "SGUtil.h"

@interface SGLaboratoryViewController ()<UITextFieldDelegate,CNContactPickerDelegate>

@end

@implementation SGLaboratoryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initFlag];
    
    //////////sample images //////////////////////////
//        self.testImageArray = [NSArray arrayWithObjects:
//                               @"2.JPG",
//                               @"5.JPG",
//                               @"10.JPG",
//                               @"15.JPG",
//                               @"20.JPG",
//                               @"30.JPG",
//                               @"40.JPG",
//                               @"50.JPG",
//                               @"60.JPG",
//                               @"70.JPG",
//                               nil];

    /////////626 test images///////////////////////////////////

//    self.testImageArray = [NSArray arrayWithObjects:
//
//                           @"2mg_0.04.jpeg",
//                           @"5mg_0.05.jpeg",
//                           @"5mg_0.09.jpeg",
//
//                           @"15mg_0.10.jpeg",
//                           @"15mg_0.11.jpeg",
//
//                           @"20mg_0.14.jpeg",
//                           @"20mg_0.15.jpeg",
//
//                           @"30mg_0.16.jpeg",
//                           @"30mg_0.17.jpeg",
//                           @"30mg_0.18.jpeg",
//                           @"30mg_0.19.jpeg",
//
//                           @"40mg_0.20.jpeg",
//                           @"40mg_0.21.jpeg",
//                           @"40mg_0.23.jpeg",
//                           @"40mg_0.25.jpeg",
//
//                           @"50mg_0.23.jpeg",
//                           @"50mg_0.25.jpeg",
//                           @"50mg_0.27.jpeg",
//                           @"50mg_0.29.jpeg",
//                           @"50mg_0.30.jpeg",
//                           @"50mg_0.32.jpeg",
//                           @"50mg_0.33.jpeg",
//
//                           @"60mg_0.23.jpeg",
//                           @"60mg_0.25.jpeg",
//                           @"60mg_0.28.jpeg",
//                           @"60mg_0.29.jpeg",
//                           @"60mg_0.30.jpeg",
//                           @"60mg_0.31.jpeg",
//                           @"60mg_0.33.jpeg",
//
//
//                           nil];
    
    
    /////////628 test images///////////////////////////////////

//    self.testImageArray = [NSArray arrayWithObjects:
//                           @"28_2_0.01.jpeg",
//                           @"28_2_0.05.jpeg",
//                           @"28_2_0.jpeg",
//
//                           @"28_5_0.07.jpeg",
//                           @"28_5_0.08.jpeg",
//                           @"28_5_0.09.jpeg",
//                           @"28_5_0.11.jpeg",
//
//
//                           @"28_10_0.17.jpeg",
//                           @"28_10_0.21.jpeg",
//                           @"28_10_0.25.jpeg",
//                           @"28_10_0.26.jpeg",
//
//                           @"28_15_0.12.jpeg",
//                           @"28_15_0.14.jpeg",
//                           @"28_15_0.18.jpeg",
//
//                           @"28_20_0.20.jpeg",
//                           @"28_20_0.22.jpeg",
//                           @"28_20_0.23.jpeg",
//                           @"28_20_0.25.jpeg",
//                           @"28_20_0.26.jpeg",
//
//                           @"28_30_0.27.jpeg",
//                           @"28_30_0.32.jpeg",
//                           @"28_30_0.36.jpeg",
//                           @"28_30_0.37.jpeg",
//                           @"28_30_0.38.jpeg",
//
//                           @"28_40_0.38.jpeg",
//                           @"28_40_0.41.jpeg",
//                           @"28_40_0.42.jpeg",
//                           @"28_40_0.47.jpeg",
//                           @"28_40_0.48.jpeg",
//
//                           @"28_50_0.49.jpeg",
//                           @"28_50_0.54.jpeg",
//                           @"28_50_0.57.jpeg",
//
//                           @"28_60_0.53.jpeg",
//                           @"28_60_0.55.jpeg",
//                           @"28_60_0.62.jpeg",
//                           @"28_60_0.69.jpeg",
//                           @"28_60_0.76.jpeg",
//
//                           nil];

    /////////////924 test images////////////////////////////
//    self.testImageArray = [NSArray arrayWithObjects:
//                           @"2_0.45.jpeg",
//                           @"2_0.46.jpeg",
//                           @"2_0.47.jpeg",
//                           @"2_0.49.jpeg",
//                           @"2_0.53.jpeg",
//                           @"2_0.56.jpeg",
//                           @"8_1.04.jpeg",
//                           @"8_1.05.jpeg",
//                           @"8_1.06.jpeg",
//                           @"8_1.07.jpeg",
//
//                           @"15_4.06.jpeg",
//                           @"15_4.27.jpeg",
//                           @"15_4.42.jpeg",
//                           @"15_4.45.jpeg",
//                           @"15_4.57.jpeg",
//                           @"15_4.58.jpeg",
//                           @"15_4.64.jpeg",
//                           nil];
    
//    self.testImageArray = [NSArray arrayWithObjects:
//                           @"2_0.00_2.jpeg",
//                           @"2_0.00_3.jpeg",
//                           @"2_0.00_5.jpeg",
//
//                           @"2_0.00_6.jpeg",
//                           @"2_0.00_7.jpeg",
//                           @"2_0.00_8.jpeg",
//                           @"2_0.01_4.jpeg",
//
//                           @"2_0.03.jpeg",
//                           @"4_0.00_3.jpeg",
//                           @"4_0.00_4.jpeg",
//                           @"4_0.01_2.jpeg",
//
//                           @"4_0.03_1.jpeg",
//                           @"6_0.02_4.jpeg",
//                           @"6_0.05_5.jpeg",
//
//                           @"6_0.05_6.jpeg",
//                           @"6_0.09_2.jpeg",
//                           @"6_0.09_3.jpeg",
//                           @"6_0.10_1.jpeg",
//                           @"8_0.05.jpeg",
//
//                           @"8_0.06_1.jpeg",
//                           @"8_0.06_2.jpeg",
//                           @"10_0.00_2.jpeg",
//                           @"10_0.00_3.jpeg",
//                           @"10_0.02_1.jpeg",
//
//                           @"12_0.00_1.jpeg",
//                           @"12_0.00_2.jpeg",
//                           @"12_0.00_3.jpeg",
//                           nil];
    
    
    ///green color images//////////
//    self.testImageArray = [NSArray arrayWithObjects:
//                           @"28_15_0.12.jpeg",
////                           @"28_15_0.14.jpeg",
//                           @"28_15_0.18.jpeg",
//
//                           @"15_4.06.jpeg",
//                           @"15_4.27.jpeg",
////                           @"15_4.42.jpeg",
////                           @"15_4.45.jpeg",
////                           @"15_4.57.jpeg",
////                           @"15_4.58.jpeg",
//                           @"15_4.64.jpeg",
//
//                           @"28_20_0.20.jpeg",
//                           @"28_20_0.22.jpeg",
////                           @"28_20_0.23.jpeg",
////                           @"28_20_0.25.jpeg",
//                           @"28_20_0.26.jpeg",
//
//                           @"28_30_0.27.jpeg",
////                           @"28_30_0.32.jpeg",
////                           @"28_30_0.36.jpeg",
////                           @"28_30_0.37.jpeg",
//                           @"28_30_0.38.jpeg",
//
//                           @"28_40_0.38.jpeg",
////                           @"28_40_0.41.jpeg",
////                           @"28_40_0.42.jpeg",
////                           @"28_40_0.47.jpeg",
//                           @"28_40_0.48.jpeg",
//                           nil];
//

    /////////////927 test images////////////////////////////
    self.testImageArray = [NSArray arrayWithObjects:
                           @"2mg_new_1.jpeg",
                           @"2mg_new_2.jpeg",
                           @"2mg_new_3.jpeg",

                           @"5mg_new_1.jpeg",
                           @"5mg_new_2.jpeg",
                           @"5mg_new_3.jpeg",

                           @"8mg_new_1.jpeg",
                           @"8mg_new_2.jpeg",
                           @"8mg_new_3.jpeg",
                           @"8mg_new_6.jpeg",

                           @"10mg_new_1.jpeg",
                           @"10mg_new_2.jpeg",
                           @"10mg_new_3.jpeg",

                           @"15mg_new_1.jpeg",
                           @"15mg_new_2.jpeg",
                           @"15mg_new_3.jpeg",

                           @"20mg_new_1.jpeg",
                           @"20mg_new_2.jpeg",
                           @"20mg_new_3.jpeg",

                           @"30mg_new_1.jpeg",
                           @"30mg_new_2.jpeg",
                           @"30mg_new_3.jpeg",

                           @"40mg_new_1.jpeg",
                           @"40mg_new_2.jpeg",
                           @"40mg_new_3.jpeg",

                           @"50mg_new_1.jpeg",
                           @"50mg_new_2.jpeg",
                           @"50mg_new_3.jpeg",

                           @"60mg_new_1.jpeg",
                           @"60mg_new_2.jpeg",
                           @"60mg_new_3.jpeg",
                           nil];

    
    self.laboratoryDataModel = [[LaboratoryDataModel alloc] init];
    self.laboratoryEngine = [[LaboratoryEngine alloc] init];
    [self initLocationManager];

    DIA = [[NSUserDefaults standardUserDefaults] integerForKey:@"DIAMETER"];
    if( [[NSUserDefaults standardUserDefaults] integerForKey:@"ugormg"]==0)
    {
        ugormg=FALSE;
        self.lblugormg.text = @"ug/cm2 Organic";
    }
    else
    {
        ugormg=TRUE;
        self.lblugormg.text = @"mg/l Organic";
    }
    
    vgood = [[NSUserDefaults standardUserDefaults] floatForKey:@"vgood"];
    satis = [[NSUserDefaults standardUserDefaults] floatForKey:@"satis"];
    vgoodlab = [[NSUserDefaults standardUserDefaults] stringForKey:@"vgoodlab"];
    satislab = [[NSUserDefaults standardUserDefaults] stringForKey:@"satislab"];
    inadeqlab = [[NSUserDefaults standardUserDefaults] stringForKey:@"inadeqlab"];
    
    R = [[NSUserDefaults standardUserDefaults] floatForKey:@"BlankR"];
    G = [[NSUserDefaults standardUserDefaults] floatForKey:@"BlankG"];
    B = [[NSUserDefaults standardUserDefaults] floatForKey:@"BlankB"];
    
    firstrun=true;
    
    NSString *rootPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES) objectAtIndex:0];
    thePath = [rootPath stringByAppendingPathComponent:@"Data.xml"];
    
    NSMutableArray *bData = [[NSMutableArray alloc] initWithContentsOfFile:thePath];
    //NSLog(@"bd:%@",bData);
    
    int len;
    len = [bData count];
    
    if(len<=1)
    {
        //Ausgabe mit RGB
        NSArray *plistentries = [[NSArray alloc] initWithObjects:@"Date",@"Customer",@"Tag",@"Diameter",@"Result",@"UgorMg",@"BlankR",@"BlankG",@"BlankB",@"SampleR",@"SampleG",@"SampleB",nil];
        NSMutableArray *dData= [[NSMutableArray alloc] init];
        [dData addObject:plistentries];
        [dData writeToFile:thePath atomically:YES];
    }
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.appDelegate.isLaboratory = false;
}

-(void)initFlag{
    
    testImageIndex = 0;
    prevTag = @"";
    prevTotalTagText = @"";
    
    sameTagCount = 1;
    isSaved = true;
    isInputMode = false;
}

-(void)initLocationManager{
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    self.locationManager.distanceFilter = kCLDistanceFilterNone;
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    if ([[[UIDevice currentDevice] systemVersion] floatValue]>=8.0) {
        [self.locationManager requestWhenInUseAuthorization];
        [self.locationManager requestAlwaysAuthorization];
    }
    [self.locationManager startMonitoringSignificantLocationChanges];
    [self.locationManager startUpdatingLocation];
}

- (void)locationManager:(CLLocationManager *)manager
    didUpdateToLocation:(CLLocation *)newLocation
           fromLocation:(CLLocation *)oldLocation {
    [self.locationManager stopUpdatingLocation];
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    [geocoder reverseGeocodeLocation:newLocation completionHandler:^(NSArray *placemarks, NSError *error)
     {
         if(placemarks && placemarks.count > 0)
         {
             CLPlacemark *placemark= [placemarks objectAtIndex:0];
             NSString *address = [NSString stringWithFormat:@"%@ %@,%@ %@", [placemark subThoroughfare],[placemark thoroughfare],[placemark locality], [placemark administrativeArea]];
             self.laboratoryDataModel.location = address;
         }
     }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(NSDictionary *)editingInfo{
    isSaved = false;
    self.laboratoryDataModel.image = image;
    self.laboratoryDataModel.date = [[SGUtil sharedUtil] getCurrentTimeString];
    [self estimateValue:image];
    [self dismissViewControllerAnimated:YES completion:nil];
    
//    [self showSaveAlertView:false];
}

- (void)onDetectedImage:(UIImage *)image{
    isSaved = false;
    self.laboratoryDataModel.image = image;
    self.laboratoryDataModel.date = [[SGUtil sharedUtil] getCurrentTimeString];
    [self estimateValue:image];
}


-(IBAction)launchCameraController{
    if(isSaved || isInputMode){
        [self capturePhoto];
    }else{
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil
                                                                       message:@"Do you want to save the Result?"
                                                                preferredStyle:UIAlertControllerStyleAlert]; // 1
        [alert addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            [self showSaveAlertView:false];
        }]];
        [alert addAction:[UIAlertAction actionWithTitle:@"CANCEL" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            [self capturePhoto];
        }]];
        [self presentViewController:alert animated:YES completion:nil];
    }
}

-(IBAction)choosePhotoPickerController{
    if(isSaved){
        [self loadPhoto];
    }else{
        
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil
                                                                       message:@"Do you want to save the Result?"
                                                                preferredStyle:UIAlertControllerStyleAlert]; // 1
        [alert addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            [self showSaveAlertView:false];
        }]];
        [alert addAction:[UIAlertAction actionWithTitle:@"CANCEL" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            [self loadPhoto];
        }]];
        [self presentViewController:alert animated:YES completion:nil];
    }
}

-(void)capturePhoto{
    SGCustomCameraViewController *customCameraVC = [[UIStoryboard storyboardWithName:@"Main_iPhone" bundle:nil] instantiateViewControllerWithIdentifier:@"SGCustomCameraViewController"];
    customCameraVC.delegate = self;
    [self.navigationController pushViewController:customCameraVC animated:YES];
}

-(void)loadPhoto{
    UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
    imagePickerController.delegate = self;
    imagePickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    [self presentViewController:imagePickerController animated:NO completion:nil];
}

- (void)estimateValue:(UIImage *)image{
    firstrun=false;
    RGBA sampleAverageColor = [self.laboratoryEngine getCropAreaAverageColor:image isSampleColor:true];
    RGBA blankAverageColor = [self.laboratoryEngine getCropAreaAverageColor:image isSampleColor:false];
    self.laboratoryDataModel.sampleColor = ((unsigned)(sampleAverageColor.r) << 16) + ((unsigned)(sampleAverageColor.g) << 8) + ((unsigned)(sampleAverageColor.b) << 0);
    self.laboratoryDataModel.blankColor =((unsigned)(blankAverageColor.r) << 16) + ((unsigned)(blankAverageColor.g) << 8) + ((unsigned)(blankAverageColor.b) << 0);

    self.sampleView.backgroundColor = [UIColor colorWithRed:sampleAverageColor.r/255.0 green:sampleAverageColor.g/255.0 blue:sampleAverageColor.b/255.0 alpha:1];
    self.blankView.backgroundColor = [UIColor colorWithRed:blankAverageColor.r/255.0 green:blankAverageColor.g/255.0 blue:blankAverageColor.b/255.0 alpha:1];

    if (isInputMode){
        [self showSampleDataInputDialog:blankAverageColor];
    }else{
        
        
//        int colorHighLight = [[SGColorUtil sharedColorUtil] getColorHighLightStatus:blankAverageColor];
        
//        self.laboratoryDataModel.cleanValue = [self.laboratoryEngine calculateResultValue:sampleAverageColor withBlankColor:blankAverageColor withColorHighLight:colorHighLight];
        self.laboratoryDataModel.cleanValue = [self.laboratoryEngine calculateResultValueWithSample:blankAverageColor];

//        self.resultValueLabel.text =[ NSString stringWithFormat:@"%.1f",self.laboratoryDataModel.cleanValue];
        
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];

        [self.laboratoryEngine calculateResultValueWithFIR:blankAverageColor withTag:@"tag1" withCompletion:^(NSError *error,double resultValue) {
            [hud hideAnimated:false];
            if(error==nil){
                self.resultValueLabel.text = [ NSString stringWithFormat:@"%.1f",resultValue];
            }else{
                [self showAlertdialog:@"" message:error.localizedDescription];
            }
        }];
        
//        if(colorHighLight == PINK){
//            self.testLabel2.text = @"PINK";
//        }else if(colorHighLight == GREEN){
//            self.testLabel2.text = @"GREEN";
//        }else if(colorHighLight == BLUE){
//            self.testLabel2.text = @"BLUE";
//        }else{
//            self.testLabel2.text = @"YELLOW";
//        }
    }

}

-(void)customerTextFieldTapped{
    [self launchContactPickerViewController];
}

-(void) contactPicker:(CNContactPickerViewController *)picker didSelectContact:(CNContact *)contact{
    self.customerTextField.text = contact.givenName;
}

-(void)contactPickerDidCancel:(CNContactPickerViewController *)picker {
}

-(void)launchContactPickerViewController{
    CNContactPickerViewController *contactPicker = [[CNContactPickerViewController alloc] init];
    contactPicker.delegate = self;
    contactPicker.displayedPropertyKeys = @[CNContactGivenNameKey];
    [self presentViewController:contactPicker animated:YES completion:nil];
}

-(IBAction)uploadImage{
    if(self.laboratoryDataModel.image==nil)
        [self showAlertdialog:nil message:@"Please take a photo."];
    else
        [self showSaveAlertView:false];
}

- (void)showSaveAlertView:(bool)isExport{
    self.alertView = [[SGUtil sharedUtil] getSGAlertView];
    self.tagTextField = [self.alertView addTextField:@"Type Tag in here!"];
    self.tagTextField.delegate = self;
    self.tagTextField.text = [self getAlertTagText:isExport];
    __weak typeof(self) weakSelf = self;

    [self.alertView addButton:@"Done" actionBlock:^(void) {
        if(isExport){
            weakSelf.laboratoryDataModel.tag = weakSelf.tagTextField.text;
            [weakSelf shareContent];
        }else{
            [weakSelf saveAlertDoneButtonClicked];
        }
    }];
    
    [self.alertView showEdit:self title:@"TAG YOUR RESULT" subTitle:nil closeButtonTitle:nil duration:0.0f];
}

-(NSString *)getAlertTagText:(bool)isExport{
    if(isExport){
        prevTotalTagText = [NSString stringWithFormat:@"%@", prevTag];
    }else{
        if ((sameTagCount != 1) && (![prevTag isEqualToString:@""])){
            prevTotalTagText = [NSString stringWithFormat:@"%@ %d", prevTag,sameTagCount];
        }else{
            prevTotalTagText = [NSString stringWithFormat:@"%@", prevTag];
        }
    }
    return prevTotalTagText;
}

-(void)saveAlertDoneButtonClicked{
    
    self.laboratoryDataModel.tag = self.tagTextField.text;
    [self saveLaboratoryDatas];
    
    if([prevTag isEqualToString:@""]){
        if(![self.tagTextField.text isEqualToString:@""]){
            prevTag = self.tagTextField.text;
            sameTagCount++;
        }
    }else{
        if([prevTotalTagText isEqualToString:self.tagTextField.text]){
            sameTagCount++;
        }else{
            sameTagCount = 2;
            prevTag = self.tagTextField.text;
        }
    }
}

-(void)saveLaboratoryDatas{
    
    NSString *userID = [FIRAuth auth].currentUser.uid;
    if(userID == nil){
        [self showNoConnectionAlertdialogForSaving];
        return;
    }

    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.label.text = @"Uploading image...";
    __weak typeof(self) wself = self;
    [[SGFirebaseManager sharedManager] saveLaboratoryResult:self.laboratoryDataModel
                                          completionHandler:^(NSError *error) {
                                              [hud hideAnimated:false];
                                              __strong typeof(wself) sself = wself;
                                              if(sself){
                                                  if(error==nil){
                                                      isSaved = true;
                                                      [self showAlertdialog:@"Image Uploading Success!" message:nil];
                                                  }else{
                                                      [sself showAlertdialog:@"Image Uploading Failed!" message:error.localizedDescription];
                                                  }
                                              }
                                          }];
}



///test function

-(IBAction)testButtonClicked:(id)sender{
    NSString *imageFileName = [self.testImageArray objectAtIndex:testImageIndex];
    UIImage *image = [UIImage imageNamed:imageFileName];
    [self estimateValue:image];
    self.testImageLabel.text = imageFileName;
    testImageIndex++;
    if(testImageIndex == self.testImageArray.count-1)
        testImageIndex =0;
    
}

-(IBAction)testMinusButtonClicked:(id)sender{
    if(testImageIndex != 0){
        testImageIndex--;
        NSString *imageFileName = [self.testImageArray objectAtIndex:testImageIndex];
        UIImage *image = [UIImage imageNamed:imageFileName];
        [self estimateValue:image];
        self.testImageLabel.text = imageFileName;
    }else{
        testImageIndex = self.testImageArray.count-1;
        NSString *imageFileName = [self.testImageArray objectAtIndex:testImageIndex];
        UIImage *image = [UIImage imageNamed:imageFileName];
        [self estimateValue:image];
        self.testImageLabel.text = imageFileName;
    }
}

-(void)shareContent{
    NSString * message = [NSString stringWithFormat:@"Value : %.2f\n Tag: %@\n Location:  %@\n SampleColor: 0x%llX\n BlankColor: 0x%llX\n",self.laboratoryDataModel.cleanValue,self.laboratoryDataModel.tag,self.laboratoryDataModel.location,self.laboratoryDataModel.sampleColor, self.laboratoryDataModel.blankColor];
    NSArray * shareItems = @[message, self.laboratoryDataModel.image];
    UIActivityViewController * avc = [[UIActivityViewController alloc] initWithActivityItems:shareItems applicationActivities:nil];
    [self presentViewController:avc animated:YES completion:nil];
}


- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if(self.alertView !=nil){
        [self.alertView hideView];
    }
    return YES;
}


-(void)showSampleDataInputDialog:(RGBA) inputBlankColor{
    self.sampleInputAlertView = [[SGUtil sharedUtil] getSGAlertView];
    self.sampleValueTextField = [self.sampleInputAlertView addTextField:@"Type value in here!"];
    self.sampleValueTextField.delegate = self;

    __weak typeof(self) weakSelf = self;
    
    [self.sampleInputAlertView addButton:@"Done" actionBlock:^(void) {
//        SGLaboratorySample  *sampleData = [[SGLaboratorySample alloc] init];
//        sampleData.value = [weakSelf.sampleValueTextField.text doubleValue];
//        sampleData.rgbValue = weakSelf.laboratoryDataModel.blankColor;
//
//        sampleData.r = inputBlankColor.r;
//        sampleData.g = inputBlankColor.g;
//        sampleData.b = inputBlankColor.b;
//        [[SGRealmManager sharedManager] addLaboartorySampleData:sampleData];

        SGLabSampleFIR *sgLabSampleFIR = [[SGLabSampleFIR alloc] init];
        sgLabSampleFIR.value = [weakSelf.sampleValueTextField.text doubleValue];
        sgLabSampleFIR.r = inputBlankColor.r;
        sgLabSampleFIR.g = inputBlankColor.g;
        sgLabSampleFIR.b = inputBlankColor.b;
        sgLabSampleFIR.tag = @"tag1";
        sgLabSampleFIR.date = [[SGUtil sharedUtil] getCurrentTimeString];
        [[SGFirebaseManager sharedManager] saveLaboratorySample:sgLabSampleFIR];
    }];

    [self.sampleInputAlertView showEdit:self title:@"Input value" subTitle:nil closeButtonTitle:@"Cancel" duration:0.0f];
}

-(IBAction)editButtonClicked{
    if(isInputMode){
        isInputMode = false;
        self.bottleView.alpha = 1;
        [self.inputModeNotificationLabel setHidden:true];
    }else{
        isInputMode = true;
        self.bottleView.alpha = 0.2;
        [self.inputModeNotificationLabel setHidden:false];
    }
}

-(IBAction)productSettingClicked{
    SGProductSettingViewController *productVC = [[UIStoryboard storyboardWithName:@"Main_iPhone" bundle:nil] instantiateViewControllerWithIdentifier:@"SGProductSettingViewController"];
    [self.navigationController pushViewController:productVC animated:YES];
}

-(IBAction)lightSettingClicked{
    SGLPSettingViewController *lpVC = [[UIStoryboard storyboardWithName:@"Main_iPhone" bundle:nil] instantiateViewControllerWithIdentifier:@"SGLPSettingViewController"];
    [self.navigationController pushViewController:lpVC animated:YES];
}
@end
