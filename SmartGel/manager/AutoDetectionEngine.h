//
//  AutoDetectionEngine.h
//  SmartGel
//
//  Created by jordi on 10/05/2018.
//  Copyright © 2018 AFCO. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SGColorUtil.h"

#define RECT_SIZE 100
#define SAMPLE_MEASURE_OFFSET 0.6
#define MIX_MEASURE_OFFSET 0.9

@interface AutoDetectionEngine:NSObject{
    UInt32 *    m_pInBuffer;
    UInt32 *    m_pOutBuffer;
    
    int         m_imageWidth;
    int         m_imageHeight;
    
    BOOL        m_donePreprocess;
}

@property (nonatomic, strong)   UIImage  *inputImage;
@property (nonatomic, assign)   int  colorOffset;
-(bool)analyzeImage:(UIImage *)image
     withSampleRect:(CGRect)sampleRect
      withBlankRect:(CGRect)blankRect;

@end
