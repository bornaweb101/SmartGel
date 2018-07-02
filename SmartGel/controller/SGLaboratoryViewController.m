//
//  SGLaboratoryViewController.m
//  SmartGel
//
//  Created by jordi on 05/12/2017.
//  Copyright © 2017 AFCO. All rights reserved.
//

#import "SGLaboratoryViewController.h"
#import "SCLAlertView.h"
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
    isSaved = true;
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

    self.testImageArray = [NSArray arrayWithObjects:
                           @"28_2_0.01.jpeg",
                           @"28_2_0.05.jpeg",
                           @"28_2_0.jpeg",

                           @"28_5_0.07.jpeg",
                           @"28_5_0.08.jpeg",
                           @"28_5_0.09.jpeg",
                           @"28_5_0.11.jpeg",

                           @"28_10_0.17.jpeg",
                           @"28_10_0.21.jpeg",
                           @"28_10_0.25.jpeg",
                           @"28_10_0.26.jpeg",
                           
                           @"28_15_0.12.jpeg",
                           @"28_15_0.14.jpeg",
                           @"28_15_0.18.jpeg",

                           @"28_20_0.20.jpeg",
                           @"28_20_0.22.jpeg",
                           @"28_20_0.23.jpeg",
                           @"28_20_0.25.jpeg",
                           @"28_20_0.26.jpeg",

                           @"28_30_0.27.jpeg",
                           @"28_30_0.32.jpeg",
                           @"28_30_0.36.jpeg",
                           @"28_30_0.37.jpeg",
                           @"28_30_0.38.jpeg",

                           @"28_40_0.38.jpeg",
                           @"28_40_0.41.jpeg",
                           @"28_40_0.42.jpeg",
                           @"28_40_0.47.jpeg",
                           @"28_40_0.48.jpeg",

                           @"28_50_0.49.jpeg",
                           @"28_50_0.54.jpeg",
                           @"28_50_0.57.jpeg",

                           @"28_60_0.53.jpeg",
                           @"28_60_0.55.jpeg",
                           @"28_60_0.62.jpeg",
                           @"28_60_0.69.jpeg",
                           @"28_60_0.76.jpeg",

                           nil];

    testImageIndex = 0;
    
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
}

- (void)onDetectedImage:(UIImage *)image{
    isSaved = false;
    self.laboratoryDataModel.image = image;
    self.laboratoryDataModel.date = [[SGUtil sharedUtil] getCurrentTimeString];
    [self estimateValue:image];
}


-(IBAction)launchCameraController{
    if(isSaved){
//        SGCustomCameraViewController *customCameraVC = [[UIStoryboard storyboardWithName:@"Main_iPhone" bundle:nil] instantiateViewControllerWithIdentifier:@"SGCustomCameraViewController"];
//        customCameraVC.delegate = self;
//        [self.navigationController pushViewController:customCameraVC animated:YES];

        [self capturePhoto];
    }else{
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil
                                                                       message:@"Do you want to save the Result?"
                                                                preferredStyle:UIAlertControllerStyleAlert]; // 1
        [alert addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            [self showSaveAlertView];
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
            [self showSaveAlertView];
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

//        UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
//        imagePickerController.delegate = self;
//        imagePickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
//        [self presentViewController:imagePickerController animated:NO completion:nil];
//    UIImage *image = [UIImage imageNamed:@"test.png"];
//    self.laboratoryDataModel.image = image;
//    self.laboratoryDataModel.date = [self getCurrentTimeString];
//
//    [self estimateValue:image];
}

-(void)loadPhoto{
    UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
    imagePickerController.delegate = self;
    imagePickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    [self presentViewController:imagePickerController animated:NO completion:nil];
}

- (void)estimateValue:(UIImage *)image{
    firstrun=false;
    RGBA sampleBAverageColor = [self.laboratoryEngine getCropAreaAverageColor:image isSampleColor:false];
    RGBA mixBAverageColor = [self.laboratoryEngine getCropAreaAverageColor:image isSampleColor:true];

    self.laboratoryDataModel.sampleColor = ((unsigned)(sampleBAverageColor.r) << 16) + ((unsigned)(sampleBAverageColor.g) << 8) + ((unsigned)(sampleBAverageColor.b) << 0);
    self.laboratoryDataModel.blankColor =((unsigned)(mixBAverageColor.r) << 16) + ((unsigned)(mixBAverageColor.g) << 8) + ((unsigned)(mixBAverageColor.b) << 0);

    self.sampleView.backgroundColor = [UIColor colorWithRed:sampleBAverageColor.r/255.0 green:sampleBAverageColor.g/255.0 blue:sampleBAverageColor.b/255.0 alpha:1];
    self.blankView.backgroundColor = [UIColor colorWithRed:mixBAverageColor.r/255.0 green:mixBAverageColor.g/255.0 blue:mixBAverageColor.b/255.0 alpha:1];

    float ssred,ssgreen,ssblue,bbblue,bbgreen,bbred;
    ssred = sampleBAverageColor.r;
    ssgreen = sampleBAverageColor.g;
    ssblue = sampleBAverageColor.b;

    bbred = mixBAverageColor.r;
    bbgreen = mixBAverageColor.g;
    bbblue = mixBAverageColor.b;
    
    float yellowValue = ssred + ssgreen;
    float greenValue = ssgreen + ssblue;
    float pinkValue = ssred + ssblue;

//    float colorDistance;
//    colorDistance = [[SGColorUtil sharedColorUtil] getDistancebetweenColors:&sampleBAverageColor with:&mixBAverageColor];
//
//    if((pinkValue>greenValue)&&(pinkValue>yellowValue)){
//        colorDistance = [[SGColorUtil sharedColorUtil] getDistancebetweenColors:&sampleBAverageColor with:&mixBAverageColor];
//    }else{
////
////        mixBAverageColor.r = 255;
////        mixBAverageColor.g = 255;
////        mixBAverageColor.b = 0;
//
//        colorDistance = [[SGColorUtil sharedColorUtil] getDistancebetweenColors:&sampleBAverageColor with:&mixBAverageColor];
//    }
//
//    self.resultValueLabel.text = [NSString stringWithFormat:@"%2f",colorDistance];

    double E535_S,E435_S,E405_S,Mn7_S,Mn6_S,Mn2_S,E535_CS,E435_CS,E405_CS,Mn7_CS,Mn6_CS,Mn2_CS,I,T,RSF,mgl_CH2O,ug_cm2,Mn7R,ERR,maxmgl,maxug,RSFGO;
    I=4.07;
    T=8.53;
    // Diamter Berechnung
    DIA = [[NSUserDefaults standardUserDefaults] integerForKey:@"DIAMETER"];
    switch (DIA) {
        case 1:Diam=0.2;
            break;
        case 2:Diam=0.35;
            break;
        case 3:Diam=0.5;
            break;
        case 4:Diam=0.6;
            break;
        case 5:Diam=2.5;
            break;
        case 6:Diam=0.3175;
            break;
        case 7:Diam=0.47625;
            break;
        case 8:Diam=0.635;
            break;
        case 9:Diam=0.95252;
            break;
        case 10:Diam=1.27;
            break;
        default:Diam=0.5;
            break;
    }

    Diam = 1;

    switch (DIA) {
        case 1:_diam=@"4mm";
            break;
        case 2:_diam=@"7mm";
            break;
        case 3:_diam=@"10mm";
            break;
        case 4:_diam=@"12mm";
            break;
        case 5:_diam=@"50mm";
            break;
        case 6:_diam=@"1/4\"";
            break;
        case 7:_diam=@"3/8\"";
            break;
        case 8:_diam=@"1/2\"";
            break;
        case 9:_diam=@"3/4\"";
            break;
        case 10:_diam=@"1\"";
            break;
        default:_diam=@"10mm";
            break;
    }


    int colorHiglight = 0;
    pinkValue = pinkValue + 20;
    if((pinkValue>greenValue)&&(pinkValue>yellowValue)){
        colorHiglight = RED;
    }else{
        if((ssblue>=ssgreen)&&(ssblue>=ssred)){
            colorHiglight = BLUE;
        }else{
            colorHiglight = GREEN;
        }
    }
    
    if(colorHiglight == RED){
        ssgreen = (ssgreen+120+120)/3;
        bbgreen = (bbgreen+120+120)/3;
        
        ssblue = (ssblue+140+140)/3;
        bbblue = (bbblue+140+140)/3;
    }else{
        ssgreen = (ssgreen+120)/2;
        bbgreen = (bbgreen+120)/2;
        
        ssblue = (ssblue+140)/2;
        bbblue = (bbblue+140)/2;
    }
//         Berechnungsstufe 1_S:

    E535_S = ((-log10(((ssred/(I-4.0)*((T-4.0)*100.0/16.0*(-0.3327)+107.64)/100.0))/3205.0))*112.0+(-log10(((ssgreen/(I-4.0)*((T-4.0)*100.0/16.0*(-0.3327)+107.64)/100.0))/3205.0))*411.0)/100.0;
    E435_S = ((-log10(((ssred/(I-4)*((T-4)*100.0/16.0*(-0.3327)+107.64)/100))/3205))*35+(-log10(((ssblue/(I-4)*((T-4)*100/16*(-0.3327)+107.64)/100))/3205))*306)/100;
    E405_S = ((-log10(((ssred/(I-4)*((T-4)*100/16*(-0.3327)+107.64)/100))/3205))*130+(-log10(((ssblue/(I-4)*((T-4)*100/16*(-0.3327)+107.64)/100))/3205))*200)/100;

    // Berechnungsstufe 2_S:

    Mn7_S = (-1670.2*E535_S-1969.1*E435_S+4201.7*E405_S)/(-26606.7);
    Mn6_S = (-555.1*E535_S-5931*E435_S+8130.7*E405_S)/(26606.7);
    Mn2_S = (E535_S-26.6*(-1670.2*E535_S-1969.1*E435_S+4201.7*E405_S)/(-26606.7)-20*(-555.1*E535_S-5931*E435_S+8130.7*E405_S)/(26606.7))/18.3;

    // Berechnungsstufe 1_CS:

    E535_CS = ((-log10(((bbred/(I-4)*((T-4)*100/16*(-0.3327)+107.64)/100))/3205))*112+(-log10(((bbgreen/(I-4)*((T-4)*100/16*(-0.3327)+107.64)/100))/3205))*411)/100;
    E435_CS = ((-log10(((bbred/(I-4)*((T-4)*100/16*(-0.3327)+107.64)/100))/3205))*35+(-log10(((bbblue/(I-4)*((T-4)*100/16*(-0.3327)+107.64)/100))/3205))*306)/100;
    E405_CS = ((-log10(((bbred/(I-4)*((T-4)*100/16*(-0.3327)+107.64)/100))/3205))*130+(-log10(((bbblue/(I-4)*((T-4)*100/16*(-0.3327)+107.64)/100))/3205))*200)/100;

    // Berechnungsstufe 2_CS:

    Mn7_CS = (-1670.2*E535_CS-1969.1*E435_CS+4201.7*E405_CS)/(-26606.7);
    Mn6_CS = (-555.1*E535_CS-5931*E435_CS+8130.7*E405_CS)/(26606.7);
    Mn2_CS = (E535_CS-26.6*(-1670.2*E535_CS-1969.1*E435_CS+4201.7*E405_CS)/(-26606.7)-20*(-555.1*E535_CS-5931*E435_CS+8130.7*E405_CS)/(26606.7))/18.3;

    // Berechnungsstufe 3:

    RSF = (Mn6_S - Mn6_CS) + ((Mn2_S - Mn2_CS)*4);
    Mn7R = (Mn7_CS - Mn7_S);
    ERR = fabs((Mn7R-RSF)*100/Mn7R);

    if(colorHiglight == GREEN){
//        RSFGO = (RSF*7.5)*1-0.08;
        RSFGO = (RSF*7.5)*2-0.18;
    }else if(colorHiglight == BLUE){
        RSFGO = (RSF*7.5)/2;
    }else{
        RSFGO = (RSF*7.5)/2;
    }

    mgl_CH2O = RSFGO;
    ug_cm2 = (RSFGO*1000)/(2*1000/(Diam));
    
    if(ug_cm2<0){
        ug_cm2 = 0;
    }

//    if(RSF<=0.1)
//    {
        self.resultValueLabel.text =[ NSString stringWithFormat:@"%.2f",ug_cm2/0.4975];
        self.laboratoryDataModel.cleanValue = ug_cm2/0.4975;
//    }else{
//        self.resultValueLabel.text =[ NSString stringWithFormat:@"> %.2f",1.0];
//        self.laboratoryDataModel.cleanValue = ug_cm2;
//    }
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
        [self showSaveAlertView];
}

- (void)showSaveAlertView{
    
    SCLAlertView *alert = [[SCLAlertView alloc] init];
    alert.customViewColor = SGColorBlack;
    alert.iconTintColor = [UIColor whiteColor];
    alert.tintTopCircle = NO;
    alert.backgroundViewColor = SGColorDarkGray;
    alert.view.backgroundColor = SGColorDarkGray;
    alert.backgroundType = SCLAlertViewBackgroundTransparent;
    
    alert.labelTitle.textColor = [UIColor whiteColor];
    self.tagTextField = [alert addTextField:@"Type Tag in here!"];
    self.customerTextField = [alert addTextField:@"no Customer Selected!"];
    UITapGestureRecognizer *singleFingerTap =
    [[UITapGestureRecognizer alloc] initWithTarget:self
                                            action:@selector(customerTextFieldTapped)];
    [self.customerTextField addGestureRecognizer:singleFingerTap];
    [alert addButton:@"Done" actionBlock:^(void) {
        self.laboratoryDataModel.tag = self.tagTextField.text;
        self.laboratoryDataModel.customer = self.customerTextField.text;
        [self saveLaboratoryDatas];
    }];
    [alert showEdit:self title:@"TAG YOUR RESULT" subTitle:nil closeButtonTitle:@"Cancel" duration:0.0f];
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
    if(testImageIndex == self.testImageArray.count)
        testImageIndex =0;
}

-(IBAction)testMinusButtonClicked:(id)sender{
    if(testImageIndex != 0){
        testImageIndex--;
        NSString *imageFileName = [self.testImageArray objectAtIndex:testImageIndex];
        UIImage *image = [UIImage imageNamed:imageFileName];
        [self estimateValue:image];
        self.testImageLabel.text = imageFileName;
    }
}



@end
