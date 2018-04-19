//
//  SGCleanEditView.m
//  SmartGel
//
//  Created by jordi on 02/02/2018.
//  Copyright © 2018 AFCO. All rights reserved.
//

#import "SGCleanEditView.h"
#import "SGUtil.h"
#import "SGConstant.h"
#import "DirtyExtractor.h"

@implementation SGCleanEditView{
    UIPanGestureRecognizer *panTapGesure;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    if(self){
        self.imgview = [[UIImageView alloc] init];
        self.manualImgview = [[UIImageView alloc] init];
        self.autoDetectCleanAreaViews = [NSMutableArray array];
        self.manualCleanAreaViews = [NSMutableArray array];
        panTapGesure = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(singleTapGestureCaptured:)];
        self.isAutoDetect = false;
    }
    return self;
}

-(void)setImage:(UIImage *)image
 withCleanArray: (NSMutableArray *)cleanArray{
    [self initViewwithImage:image];
    CGRect rect = [[SGUtil sharedUtil] calculateClientRectOfImageInUIImageView:self.scrollView takenImage:self.takenImage];
    [self initManualMode:rect];
    [self initAutoDetect:rect withCleanArray:cleanArray];
}

-(void)initViewwithImage:(UIImage *)image{
    [self.scrollView setZoomScale:1];
    self.takenImage = image;
}

/************************************************************************************************************************************
 * init data and view for auto detect
 *************************************************************************************************************************************/

-(void)initAutoDetect:(CGRect)rect
      withCleanArray : (NSMutableArray *)cleanArray{
    
    [self initAutoDetectData:cleanArray];
    [self initAutoDetectGridView:rect];
    [self initAutoDetectImageView:rect];
    //    [self initManualImageView:rect];
    [self initAutoDetectCleanAreaViews];

}

-(void)initAutoDetectData:(NSMutableArray *)cleanArray{
    [self.autoDetectCleanAreaViews removeAllObjects];
    [self.imgview.subviews makeObjectsPerformSelector: @selector(removeFromSuperview)];
    self.autoDetectCleanAreaViews = cleanArray;
}

-(void)initAutoDetectImageView:(CGRect)rect{
    [self.imgview removeFromSuperview];
    self.imgview =  [[UIImageView alloc] initWithFrame:rect];
    self.imgview.image = self.takenImage;
    [self.imgview addSubview:self.gridView];
    [self.scrollView addSubview:self.imgview];
}

-(void)initAutoDetectGridView:(CGRect)rect{
    self.gridView = [[SGGridView alloc] initWithFrame:CGRectMake(0, 0, rect.size.width, rect.size.height)];
    [self.gridView addGridViews:SGGridCount withColCount:SGGridCount];
}

// init auto detect clean area views
-(void)initAutoDetectCleanAreaViews{
    float areaWidth = self.imgview.frame.size.width/AREA_DIVIDE_NUMBER;
    float areaHeight = self.imgview.frame.size.height/AREA_DIVIDE_NUMBER;
    for(int i = 0; i<(AREA_DIVIDE_NUMBER*AREA_DIVIDE_NUMBER);i++){
        int x,y;
        if(self.takenImage.imageOrientation == UIImageOrientationLeft){
            y = (AREA_DIVIDE_NUMBER-1) - i/AREA_DIVIDE_NUMBER;
            x = i%AREA_DIVIDE_NUMBER;
        }else if(self.takenImage.imageOrientation == UIImageOrientationRight){
            y = i/AREA_DIVIDE_NUMBER;
            x = (AREA_DIVIDE_NUMBER-1) - i%AREA_DIVIDE_NUMBER;
        }else if(self.takenImage.imageOrientation == UIImageOrientationUp){
            x = i/AREA_DIVIDE_NUMBER;
            y = i%AREA_DIVIDE_NUMBER;
        }else{
            x = (AREA_DIVIDE_NUMBER-1)-i/AREA_DIVIDE_NUMBER;
            y = (AREA_DIVIDE_NUMBER-1)-i%AREA_DIVIDE_NUMBER;
        }
        UIView *paintView=[[UIView alloc]initWithFrame:CGRectMake(x*areaWidth, y*areaHeight, areaWidth, areaHeight)];
        UIView *manualPaintView=[[UIView alloc]initWithFrame:CGRectMake(x*areaWidth, y*areaHeight, areaWidth, areaHeight)];
        if([[self.autoDetectCleanAreaViews objectAtIndex:i] intValue] == IS_CLEAN){
            [manualPaintView setBackgroundColor:[UIColor redColor]];
            [manualPaintView setAlpha:0.3];

            [paintView setBackgroundColor:[UIColor redColor]];
            [paintView setAlpha:0.3];
        }else if([[self.autoDetectCleanAreaViews objectAtIndex:i] intValue] == IS_DIRTY){
            [manualPaintView setBackgroundColor:[UIColor blueColor]];
            [manualPaintView setAlpha:0.0];

            [paintView setBackgroundColor:[UIColor blueColor]];
            [paintView setAlpha:0.0];
        }
        [self.autoDetectCleanAreaViews addObject:paintView];
        [self.imgview addSubview:paintView];
        
        [self.manualCleanAreaViews addObject:manualPaintView];
        [self.manualImgview addSubview:manualPaintView];
    }
}


-(void)onSetAutoDetectMode{
    [self.scrollView setZoomScale:1];
    [self.imgview setHidden:NO];
    [self.manualImgview setHidden:YES];
    self.isAutoDetect = true;
}

/************************************************************************************************************************************
 * init data and view for manual mode
 *************************************************************************************************************************************/

-(void)initManualMode:(CGRect)rect{
    [self initManualGridView:rect];
    [self initManualImageView:rect];
}

-(void)initManualGridView:(CGRect)rect{
    self.manualGridView = [[SGGridView alloc] initWithFrame:CGRectMake(0, 0, rect.size.width, rect.size.height)];
    [self.manualGridView addGridViews:SGGridCount withColCount:SGGridCount];
}

-(void)initManualImageView:(CGRect)rect{
    [self.manualImgview removeFromSuperview];
    self.manualImgview =  [[UIImageView alloc] initWithFrame:rect];
    self.manualImgview.image = self.takenImage;
    [self.manualImgview addSubview:self.manualGridView];
    [self.scrollView addSubview:self.manualImgview];
}

-(void)onSetManualMode{
    [self.scrollView setZoomScale:1];
    [self.imgview setHidden:YES];
    [self.manualImgview setHidden:NO];
    self.isAutoDetect = false;
}

/************************************************************************************************************************************
 * init panGesture
 *************************************************************************************************************************************/

-(void)addPanGesture{
//    panTapGesure = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(singleTapGestureCaptured:)];
    [self.scrollView addGestureRecognizer:panTapGesure];
}

-(void)removePanGesture{
    [self.scrollView removeGestureRecognizer:panTapGesure];
}

/************************************************************************************************************************************
  * image zooming function
*************************************************************************************************************************************/
- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    if(self.isAutoDetect)
        return self.imgview;
    else
        return self.manualImgview;
}

-(void)scrollViewDidZoom:(UIScrollView *)scrollView {
    [self centerScrollViewContents];
}

- (void)centerScrollViewContents {
    CGSize boundsSize = self.scrollView.bounds.size;
    CGRect contentsFrame;
    if(self.isAutoDetect)
        contentsFrame = self.imgview.frame;
    else
        contentsFrame = self.manualImgview.frame;
    if (contentsFrame.size.width < boundsSize.width) {
        contentsFrame.origin.x = (boundsSize.width - contentsFrame.size.width) / 2.0;
    } else {
        contentsFrame.origin.x = 0.0;
    }
    
    if (contentsFrame.size.height < boundsSize.height) {
        contentsFrame.origin.y = (boundsSize.height - contentsFrame.size.height) / 2.0;
    } else {
        contentsFrame.origin.y = 0.0;
    }
    if(self.isAutoDetect)
        self.imgview.frame = contentsFrame;
    else
        self.manualImgview.frame = contentsFrame;
}


/************************************************************************************************************************************
 * scrollview single tap gestured
 *************************************************************************************************************************************/

- (void)singleTapGestureCaptured:(UIPanGestureRecognizer *)gesture
{
    CGPoint touchPoint=[gesture locationInView:self.manualGridView];
    if(self.takenImage==nil)
        return;
    int touchPosition = [self.manualGridView getContainsFrame:self.takenImage withPoint:touchPoint withRowCount:SGGridCount withColCount:SGGridCount];
    if(touchPosition != -1){
        if(self.delegate != nil)
          [self.delegate onTappedGridView:touchPosition];
    }
}

/************************************************************************************************************************************
 * add maunal clean area
 *************************************************************************************************************************************/

-(void)addManualCleanArea:(int)touchPosition{
    int pointX = touchPosition/SGGridCount;
    int pointY = touchPosition%SGGridCount;
    int rate = AREA_DIVIDE_NUMBER/SGGridCount;
    for(int i = 0; i<rate;i++){
        for(int j = 0; j< rate; j++){
            NSUInteger postion = AREA_DIVIDE_NUMBER*rate*pointX+(i*AREA_DIVIDE_NUMBER)+(rate*pointY+j);
            UIView *view = [self.manualCleanAreaViews objectAtIndex:postion];
            [view removeFromSuperview];
            UIView *manualPinkView = [[UIView alloc] initWithFrame:view.frame];
            [manualPinkView setBackgroundColor:[UIColor redColor]];
            [manualPinkView setAlpha:0.3];
            [self.manualCleanAreaViews replaceObjectAtIndex:postion withObject:manualPinkView];
            [self.manualImgview addSubview:[self.manualCleanAreaViews objectAtIndex:postion]];
        }
    }
}

/************************************************************************************************************************************
 * add manual dirty area
 *************************************************************************************************************************************/

-(void)addManualDirtyArea:(int)touchPosition{
    int pointX = touchPosition/SGGridCount;
    int pointY = touchPosition%SGGridCount;
    int rate = AREA_DIVIDE_NUMBER/SGGridCount;
    for(int i = 0; i<rate;i++){
        for(int j = 0; j< rate; j++){
            NSUInteger postion = AREA_DIVIDE_NUMBER*rate*pointX+(i*AREA_DIVIDE_NUMBER)+(rate*pointY+j);
            UIView *view = [self.manualCleanAreaViews objectAtIndex:postion];
            [view removeFromSuperview];
            UIView *manualPinkView = [[UIView alloc] initWithFrame:view.frame];
            [manualPinkView setBackgroundColor:[UIColor greenColor]];
            [manualPinkView setAlpha:0.3];
            [self.manualCleanAreaViews replaceObjectAtIndex:postion withObject:manualPinkView];
            [self.manualImgview addSubview:[self.manualCleanAreaViews objectAtIndex:postion]];
        }
    }
}

///************************************************************************************************************************************
// * add manual non-gel area
// *************************************************************************************************************************************/
//-(void)addManualNonGelArea:(int)touchPosition{
//    int pointX = touchPosition/SGGridCount;
//    int pointY = touchPosition%SGGridCount;
//    int rate = AREA_DIVIDE_NUMBER/SGGridCount;
//    for(int i = 0; i<rate;i++){
//        for(int j = 0; j< rate; j++){
//            NSUInteger postion = AREA_DIVIDE_NUMBER*rate*pointX+(i*AREA_DIVIDE_NUMBER)+(rate*pointY+j);
//            UIView *view = [self.manualCleanAreaViews objectAtIndex:postion];
//            [view removeFromSuperview];
//            [view setBackgroundColor:[UIColor yellowColor]];
//            [view setAlpha:0.3];
//            [self.manualCleanAreaViews replaceObjectAtIndex:postion withObject:view];
//            [self.manualImgview addSubview:view];
//        }
//    }
//}

/************************************************************************************************************************************
 * remove Manual area
 *************************************************************************************************************************************/

-(void)removeMaunalArea:(int)touchPosition{
    int pointX = touchPosition/SGGridCount;
    int pointY = touchPosition%SGGridCount;
    int rate = AREA_DIVIDE_NUMBER/SGGridCount;
    for(int i = 0; i<rate;i++){
        for(int j = 0; j< rate; j++){
            NSUInteger postion = AREA_DIVIDE_NUMBER*rate*pointX+(i*AREA_DIVIDE_NUMBER)+(rate*pointY+j);
            UIView *view = [self.manualCleanAreaViews objectAtIndex:postion];
            [view removeFromSuperview];
        }
    }
}

- (UIImage *)croppIngimageByImageName
{
    float scale = 1.0f/self.scrollView.zoomScale;
    CGRect visibleRect;
    visibleRect.origin.x = self.scrollView.contentOffset.x * scale;
    visibleRect.origin.y = self.scrollView.contentOffset.y * scale;
    visibleRect.size.width = self.scrollView.bounds.size.width * scale;
    visibleRect.size.height = self.scrollView.bounds.size.height * scale;
    CGImageRef imageRef = CGImageCreateWithImageInRect([self.takenImage CGImage], visibleRect);
    UIImage *cropped = [UIImage imageWithCGImage:imageRef];
    CGImageRelease(imageRef);
    return cropped;
}
@end
