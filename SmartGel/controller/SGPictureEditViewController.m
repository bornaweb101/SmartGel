//
//  SGPictureEditViewController.m
//  SmartGel
//
//  Created by jordi on 30/11/2017.
//  Copyright © 2017 AFCO. All rights reserved.
//

#import "SGPictureEditViewController.h"

@interface SGPictureEditViewController ()

@end

@implementation SGPictureEditViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.takenImageView setImage:self.takenImage];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)backButtonClicked:(id)sender{
    [self.navigationController popViewControllerAnimated: YES];
}

-(IBAction)widthButtonClicked{
    if(self.widthSlider.isHidden)
        [self.widthSlider setHidden:NO];
    else
        [self.widthSlider setHidden:YES];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
