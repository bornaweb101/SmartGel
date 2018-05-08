//
//  LaboratoryEngine.h
//  SmartGel
//
//  Created by jordi on 07/05/2018.
//  Copyright © 2018 AFCO. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DirtyExtractor.h"

#define CLEAN_MAX_VALUE      10

#define IS_CLEAN 1
#define IS_DIRTY 2
#define NO_GEL   3

@interface LaboratoryEngine : NSObject{
    UInt32 *    m_pInBuffer;
    UInt32 *    m_pOutBuffer;
    
    int         m_imageWidth;
    int         m_imageHeight;
    
    BOOL        m_donePreprocess;    
}

@property (nonatomic, strong)   UIImage  *inputImage;
@property (nonatomic, assign)   int   m_colorOffset;
-(bool)analyzeImage:(UIImage *)image;
@end
