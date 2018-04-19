//
//  SGCleanEditView.h
//  SmartGel
//
//  Created by jordi on 02/02/2018.
//  Copyright © 2018 AFCO. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SGGridView.h"

@protocol SGCleanEditViewDelegate <NSObject>
@required
- (void)onTappedGridView:(int)touchLocation;
@end


@interface SGCleanEditView : UIView<UIScrollViewDelegate>

@property (weak, nonatomic) id<SGCleanEditViewDelegate> delegate;

@property (strong, nonatomic) UIImageView *imgview;
@property (strong, nonatomic) UIImageView *manualImgview;

@property (strong, nonatomic) UIImage *takenImage;

@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic) IBOutlet UIView *gridContentView;

@property (strong, nonatomic) SGGridView *gridView;
@property (strong, nonatomic) SGGridView *manualGridView;

@property (strong, nonatomic) NSMutableArray *autoDetectCleanAreaViews;
@property (strong, nonatomic) NSMutableArray *manualCleanAreaViews;

@property (nonatomic) BOOL zoomed;

@property (nonatomic) BOOL isAutoDetect;

-(void)setImage:(UIImage *)image
 withCleanArray: (NSMutableArray *)cleanArray;

-(void)addManualCleanArea:(int)touchPosition;
-(void)addManualDirtyArea:(int)touchPosition;
-(void)removeMaunalArea:(int)touchPosition;

-(void)onSetAutoDetectMode;
-(void)onSetManualMode;

-(void)addPanGesture;
-(void)removePanGesture;
- (UIImage *)croppIngimageByImageName;

@end
