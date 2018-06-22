//
//  AutoDetectionEngine.m
//  SmartGel
//
//  Created by jordi on 10/05/2018.
//  Copyright © 2018 AFCO. All rights reserved.
//

#import "AutoDetectionEngine.h"

@implementation AutoDetectionEngine

- (id) init
{
    self = [super init];
    return self;
}

-(instancetype)initWithImage:(UIImage *)image{
    self = [super init];
    if(self){
    }
    return self;
}


- (void) reset
{
    m_imageWidth = 0;
    m_imageHeight = 0;
    
    if (m_pInBuffer)
    {
        free (m_pInBuffer);
        m_pInBuffer = NULL;
    }
    
    if (m_pOutBuffer)
    {
        free (m_pOutBuffer);
        m_pOutBuffer = NULL;
    }
}

-(bool)analyzeImage:(UIImage *)image
 withDetectAreaSize:(float)detecSize
withDetectAreaInterval:(float)interval{
    [self importImage:image];
    [self smoothBufferByAverage];
    bool isDetected = [self detectCleanBottleAreaNew:detecSize withAreaInterval:interval];
    [self reset];
    return isDetected;
}

- (void) importImage:(UIImage *)image
{
    m_imageWidth = image.size.width;
    m_imageHeight = image.size.height;
    
    m_pInBuffer = (UInt32 *)calloc(sizeof(UInt32), m_imageWidth * m_imageHeight);
    m_pOutBuffer = (UInt32 *)calloc(sizeof(UInt32), m_imageWidth * m_imageHeight);
    
    int nBytesPerRow = m_imageWidth * 4;
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef context = CGBitmapContextCreate(m_pInBuffer, m_imageWidth, m_imageHeight, 8, nBytesPerRow, colorSpace, kCGBitmapByteOrder32Little | kCGImageAlphaNoneSkipLast);
    
    CGContextSetInterpolationQuality(context, kCGInterpolationHigh);
    CGContextSetShouldAntialias(context, NO);
    CGContextDrawImage(context, CGRectMake(0, 0, m_imageWidth, m_imageHeight), image.CGImage);
    CGContextRelease(context);
    CGColorSpaceRelease(colorSpace);
}


- (bool)detectCleanBottleAreaNew:(float)rectSize
                withAreaInterval:(float)interval
{
    UInt32 * pPixelBuffer = m_donePreprocess ? m_pOutBuffer : m_pInBuffer;
    float sampleBottleAreaCleanCount = 0;
    float mixBottleAreaDirtyCount = 0;
    float mixBottleAreaCleanCount = 0;

//    CGRect rect1 = CGRectMake(self.view.frame.size.width/2 - self.view.frame.size.width/8 - RECT_SIZE , (self.view.frame.size.height*4)/10, RECT_SIZE, RECT_SIZE);
//    CGRect rect2 = CGRectMake(self.view.frame.size.width/2 + self.view.frame.size.width/8, (self.view.frame.size.height*4)/10, RECT_SIZE, RECT_SIZE);

    
    int sampleBottleYStart = (m_imageHeight-rectSize)/2;
    int sampleBottleXStart = m_imageWidth/2-m_imageWidth/10-rectSize;
    
    
    int mixBottleYStart = (m_imageHeight-rectSize)/2;
    int mixBottleXStart =m_imageWidth/2+m_imageWidth/10;

    int totalCount = 0;
    int mixTotalCount = 0;
    
    for (int y = sampleBottleYStart; y < sampleBottleYStart+(int)rectSize; y++)
    {
        for (int x = sampleBottleXStart; x < sampleBottleXStart+(int)rectSize; x++)
        {
            int index = y * m_imageWidth + x;
            
            RGBA rgba;
            memcpy(&rgba, &pPixelBuffer[index], sizeof(RGBA));
            
            UInt32 dirtyPixel = [[SGColorUtil sharedColorUtil] getDirtyPixelLaboratory:&rgba];
            if (dirtyPixel == IS_CLEAN ){
                sampleBottleAreaCleanCount ++;
            }
        }
    }
    
    int rectCount = (int)rectSize;
    
    for (int y = mixBottleYStart; y < mixBottleYStart+rectCount; y++)
    {
        for (int x = mixBottleXStart; x < mixBottleXStart+rectCount; x++)
        {
            int index = y * m_imageWidth + x;
            
            RGBA rgba;
            memcpy(&rgba, &pPixelBuffer[index], sizeof(RGBA));
            
            UInt32 dirtyPixel = [[SGColorUtil sharedColorUtil] getDirtyPixelLaboratory:&rgba];
            if (dirtyPixel == IS_CLEAN ){
                mixBottleAreaCleanCount ++;
            }else if(dirtyPixel == IS_DIRTY){
                mixBottleAreaDirtyCount++;
            }
        }
    }
    
    totalCount =rectCount*rectCount*SAMPLE_MEASURE_OFFSET;
    mixTotalCount = rectCount*rectCount*MIX_MEASURE_OFFSET;
    
    if (sampleBottleAreaCleanCount>totalCount){
        if((mixBottleAreaCleanCount+mixBottleAreaDirtyCount)>mixTotalCount){
            return true;
        }
    }
    
    return false;
}



- (void)smoothBufferByAverage
{
    int pixelStep = PIXEL_STEP;
    for (int y = 0; y < m_imageHeight; y += pixelStep)
    {
        for(int x = 0; x < m_imageWidth; x+= pixelStep)
        {
            int endX = MIN(m_imageWidth, x + pixelStep);
            int endY = MIN(m_imageHeight, y + pixelStep);
            
            int sR = 0;
            int sG = 0;
            int sB = 0;
            int nCount = 0;
            for (int yy = y; yy < endY; yy++)
            {
                for (int xx = x; xx < endX; xx++)
                {
                    RGBA rgba;
                    int index = yy * m_imageWidth + xx;
                    memcpy(&rgba, &m_pInBuffer[index], sizeof(RGBA));
                    sR += rgba.r;
                    sG += rgba.g;
                    sB += rgba.b;
                    
                    nCount++;
                }
            }
            
            RGBA averageRGB;
            averageRGB.r = sR / nCount;
            averageRGB.g = sG / nCount;
            averageRGB.b = sB / nCount;
            
            for (int yy = y; yy < endY; yy++)
            {
                for (int xx = x; xx < endX; xx++)
                {
                    int index = yy * m_imageWidth + xx;
                    memcpy(&m_pOutBuffer[index], &averageRGB, sizeof(RGBA));
                }
            }
        }
    }
    m_donePreprocess = YES;
}

@end
