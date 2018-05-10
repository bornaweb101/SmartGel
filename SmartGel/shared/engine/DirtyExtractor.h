//
//  ExtractDirty.h
//  grayscale test
//
//  Created by jordi on 4/10/17.
//  Copyright © 2017 afco. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SGColorUtil.h"

#define AREA_DIVIDE_NUMBER      100
#define CLEAN_MAX_VALUE      10

#define IS_CLEAN 1
#define IS_DIRTY 2
#define NO_GEL   3


@interface DirtyExtractor : NSObject
{
    UInt32 *    m_pInBuffer;
    UInt32 *    m_pOutBuffer;
    
    int         m_imageWidth;
    int         m_imageHeight;
    
    BOOL        m_donePreprocess;
    
    int         m_nPinkCount;
    int         m_nBlueCount;
    
    int         m_nNoGelCount;
}
@property (nonatomic, strong)   NSMutableArray  *areaCleanState;
@property (nonatomic, strong)   NSMutableArray  *originalAreaCleanState;

@property (nonatomic, assign, readonly)   float   cleanValue;

@property (nonatomic, assign)   int   m_colorOffset;

- (void)        reset;

- (void)        importImage:(UIImage *)image;
- (UIImage *)   exportImage;

- (void)        extract;
- (void) setNonGelAreaState:(NSMutableArray *)nonGelAreaArray;
-(void)addCleanArea:(int)touchPosition;
-(void)addDirtyArea:(int)touchPosition;
-(void)removeManualCleanArea:(int)touchPosition;

-(instancetype)initWithImage:(UIImage *)image;
-(instancetype)initWithImage:(UIImage *)image withColoroffset:(int)coloroffset;

@end
