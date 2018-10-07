//
//  SGLPSettingViewController.h
//  SmartGel
//
//  Created by rockstar on 10/7/18.
//  Copyright © 2018 AFCO. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SGFirebaseManager.h"
#import "MBProgressHUD.h"
#import "SGBaseViewController.h"

@protocol SGLPSettingViewControllerDelegate <NSObject>
@required
- (void)didSelectLightPannel:(NSString *)panelName;
@end

@interface SGLPSettingViewController : SGBaseViewController
@property (strong, nonatomic) IBOutlet UITableView *lpTableView;
@property (strong, nonatomic) NSMutableArray *tagArray;

@property (strong, nonatomic) NSString *selectedPanelName;

@property (weak, nonatomic) id<SGLPSettingViewControllerDelegate> delegate;

@end
