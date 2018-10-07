//
//  SGLPSettingViewController.m
//  SmartGel
//
//  Created by rockstar on 10/7/18.
//  Copyright © 2018 AFCO. All rights reserved.
//

#import "SGLPSettingViewController.h"
#import "SGProductTableViewCell.h"

@interface SGLPSettingViewController ()

@end

@implementation SGLPSettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tagArray = [NSMutableArray array];
    [self getTagArrays];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(void)getTagArrays{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    __weak typeof(self) wself = self;
    [[SGFirebaseManager sharedManager] getProducts:@"panels" withCompletion:^(NSError *error,NSMutableArray* array) {
        __strong typeof(wself) sself = wself;
        [hud hideAnimated:false];
        if (sself) {
            if(error==nil){
                sself.tagArray = array;
                [sself.lpTableView reloadData];
            }else{
                [sself showAlertdialog:@"Error!" message:error.localizedDescription];
            }
        }
    }];
}

#pragma mark - Table View Data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.tagArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"SGProductTableViewCell";
    SGProductTableViewCell *cell = [self.lpTableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[SGProductTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    SGTag *sgTag = [self.tagArray objectAtIndex:indexPath.row];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    
    if([sgTag.tagName isEqualToString:self.selectedPanelName]){
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }else{
        cell.accessoryType = UITableViewCellAccessoryNone;
    }

    [cell setCell:sgTag];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView cellForRowAtIndexPath:indexPath].accessoryType = UITableViewCellAccessoryCheckmark;
    SGTag *sgTag = [self.tagArray objectAtIndex:indexPath.row];
    if(self.delegate){
        [self.delegate didSelectLightPannel:sgTag.tagName];
    }
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView cellForRowAtIndexPath:indexPath].accessoryType = UITableViewCellAccessoryNone;
}

@end
