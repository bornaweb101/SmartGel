//
//  SGBaseViewController.m
//  SmartGel
//
//  Created by jordi on 16/10/2017.
//  Copyright © 2017 AFCO. All rights reserved.
//

#import "SGBaseViewController.h"

@interface SGBaseViewController ()

@end

@implementation SGBaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(void)showAlertdialog:(NSString*)title message:(NSString*)message{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title
                                                                   message:message
                                                            preferredStyle:UIAlertControllerStyleAlert]; // 1
    [alert addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil]];
    [self presentViewController:alert animated:YES completion:nil];
}

-(void)showNoConnectionAlertdialog{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"ATTENTION"
                                                                   message:@"No Internet connection, Please check your network settings and reopen app."
                                                            preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil]];
    [self presentViewController:alert animated:YES completion:nil];
}

-(void)showNoConnectionAlertdialogForSaving{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"ATTENTION"
                                                                   message:@"Failed to Uploading, Image will be saved in your photo library. Please check your network settings and reopen app."
                                                            preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil]];
    [self presentViewController:alert animated:YES completion:nil];
}



@end
