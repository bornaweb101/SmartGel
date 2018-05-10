//
//  LaboratoryEngine.h
//  SmartGel
//
//  Created by jordi on 07/05/2018.
//  Copyright © 2018 AFCO. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DirtyExtractor.h"

@interface LaboratoryEngine : NSObject{
    UInt32 *    m_pInBuffer;
    UInt32 *    m_pOutBuffer;
    
    int         m_imageWidth;
    int         m_imageHeight;
    
    BOOL        m_donePreprocess;
}

-(RGBA)getCropAreaAverageColor:(UIImage *)image
                    widthStart:(float)widthStart
                      widthEnd:(float)widthEnd
                   heightStart:(float)heightStart
                     heightEnd:(float)heightEnd;

@end
