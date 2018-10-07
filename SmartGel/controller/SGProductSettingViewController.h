//
//  SGProductSettingViewController.h
//  SmartGel
//
//  Created by rockstar on 10/7/18.
//  Copyright © 2018 AFCO. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SGProductTableViewCell.h"
#import "SGTag.h"
#import "SGFirebaseManager.h"
#import "MBProgressHUD.h"
#import "SGBaseViewController.h"

@protocol SGProductSettingViewControllerDelegate <NSObject>
@required
- (void)didSelectProduct:(NSString *)productName;
@end

@interface SGProductSettingViewController : SGBaseViewController<UITableViewDelegate,UITableViewDataSource>
@property (strong, nonatomic) IBOutlet UITableView *productTableView;
@property (strong, nonatomic) NSMutableArray *tagArray;
@property (strong, nonatomic) NSString *selectedProductName;

@property (weak, nonatomic) id<SGProductSettingViewControllerDelegate> delegate;

@end
