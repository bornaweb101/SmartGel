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
     withSampleRect:(CGRect)sampleRect
      withBlankRect:(CGRect)blankRect{
    [self importImage:image];
    [self smoothBufferByAverage];
    bool isDetected = [self detectCleanBottleAreaNew:sampleRect withBlankRect:blankRect];
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


- (bool)detectCleanBottleAreaNew:(CGRect)sampleRect
                   withBlankRect:(CGRect)blankRect
{
    UInt32 * pPixelBuffer = m_donePreprocess ? m_pOutBuffer : m_pInBuffer;
    
    float sampleBottleAreaCleanCount = 0;
    float mixBottleAreaDirtyCount = 0;
    float mixBottleAreaCleanCount = 0;

    float sampleBottleYStart,sampleBottleXStart,mixBottleYStart,mixBottleXStart;
    float areaWidth, areaHeight,detectAread_interval;

    UIDevice *device = UIDevice.currentDevice;
    if((device.orientation == UIDeviceOrientationPortrait)||(device.orientation == UIDeviceOrientationPortraitUpsideDown)){
        detectAread_interval = m_imageWidth/10;
        areaWidth = m_imageWidth/2-m_imageWidth/10-15;
        areaHeight = areaWidth;
    }else{
        detectAread_interval = m_imageHeight/10;
        areaWidth = m_imageWidth/2-m_imageWidth/10-15;
        areaHeight = m_imageHeight/2-m_imageHeight/10-15;
    }
    
    sampleBottleXStart = m_imageWidth/2 - detectAread_interval - areaWidth;
    mixBottleYStart = m_imageWidth/2 + detectAread_interval;
    sampleBottleYStart = mixBottleYStart = (m_imageHeight-areaHeight)/2;
    
    
    
//    int sampleBottleYStart = sampleRect.origin.y
//    int sampleBottleXStart = sampleRect.origin.x;
//
//    int mixBottleYStart = (m_imageHeight-rectSize)/2;
//    int mixBottleXStart =m_imageWidth/2+m_imageWidth/10;

    int totalCount = 0;
    int mixTotalCount = 0;
    
    for (int y = sampleBottleYStart; y < sampleBottleYStart+areaHeight; y++)
    {
        for (int x = sampleBottleXStart; x < sampleBottleXStart+areaWidth; x++)
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
    
//    int rectCount = (int)rectSize;
    
    for (int y = mixBottleYStart; y < mixBottleYStart+areaHeight; y++)
    {
        for (int x = mixBottleXStart; x < mixBottleXStart+areaWidth; x++)
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
    
    totalCount =areaWidth*areaHeight*SAMPLE_MEASURE_OFFSET;
    mixTotalCount = areaWidth*areaHeight*MIX_MEASURE_OFFSET;
    
    if (sampleBottleAreaCleanCount>=totalCount){
        if((mixBottleAreaCleanCount+mixBottleAreaDirtyCount)>=mixTotalCount){
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
