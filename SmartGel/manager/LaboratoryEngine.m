//
//  LaboratoryEngine.m
//  SmartGel
//
//  Created by jordi on 07/05/2018.
//  Copyright © 2018 AFCO. All rights reserved.
//

#import "LaboratoryEngine.h"
#import "SGConstant.h"
#import "GPUImage.h"
#include <math.h>

#define NO_DIRTY_PIXEL          0x0
#define PINK_DIRTY_PIXEL        0xFF00FFFF
#define BLUE_DIRTY_PIXEL        0x00FFFFFF

#define PIXEL_STEP              3
#define AREA_DIRTY_RATE      0.8

#define MAX_DIRTY_VALUE         10.0f

#define MIN_LOCAL_AREA_PERCENT  0.01f

#define PINK_COLOR_OFFSET  25.0f

@implementation LaboratoryEngine
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

- (void) dealloc
{
    [self reset];
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

-(bool)analyzeImage:(UIImage *)image{
    [self importImage:image];
    [self smoothBufferByAverage];
    bool isDetected = [self detectCleanBottleArea];
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

- (bool)detectCleanBottleArea
{
    UInt32 * pPixelBuffer = m_donePreprocess ? m_pOutBuffer : m_pInBuffer;
    float cleanCount = 0;
    float dirtyCount = 0;
    float totalCount = 0;
    
    float edgeTotalCount = 0;
    
    for (int y = m_imageHeight/5; y < (4*m_imageHeight/5); y++)
    {
        for (int x = m_imageWidth/4; x < (m_imageWidth/2); x++)
        {
            int index = y * m_imageWidth + x;
            
            RGBA rgba;
            memcpy(&rgba, &pPixelBuffer[index], sizeof(RGBA));
            
            UInt32 dirtyPixel = [self getDirtyPixel:&rgba];
            if (dirtyPixel == PINK_DIRTY_PIXEL ){
                cleanCount ++;
            }
        }
    }
    
    
    for (int y = m_imageHeight/5; y < (4*m_imageHeight/5); y++)
    {
        for (int x = 0; x < (m_imageWidth/4); x++)
        {
            int index = y * m_imageWidth + x;
            RGBA rgba;
            memcpy(&rgba, &pPixelBuffer[index], sizeof(RGBA));
            UInt32 dirtyPixel = [self getDirtyPixel:&rgba];
            if (dirtyPixel != PINK_DIRTY_PIXEL ){
                dirtyCount ++;
            }
        }
    }

    
    totalCount =(3*m_imageHeight/5)*(m_imageWidth/4);
    edgeTotalCount =(3*m_imageHeight/5)*(m_imageWidth/4);
    if((cleanCount>totalCount*0.9) && (dirtyCount > edgeTotalCount*0.9)){
        return true;
    }else{
        return false;
    }
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

- (UInt32)   getDirtyPixel:(RGBA *)rgba
{
    self.m_colorOffset = 0;
    UInt8 minValue = 0x4F;
    if (rgba->r < minValue && rgba->g < minValue && rgba->b < minValue)
        return BLUE_DIRTY_PIXEL;
    
    int yellowValue = rgba->r + rgba->g;
    int greenValue = rgba->g + rgba->b;
    int pinkValue = rgba->r + rgba->b;
    
    BOOL isPinkSerial = pinkValue > greenValue;
    if (isPinkSerial)
    {
        if(pinkValue>(yellowValue-self.m_colorOffset))
            return PINK_DIRTY_PIXEL;
        else
            return BLUE_DIRTY_PIXEL;
        //        float distance = [self getDistanceWithPinkColor:rgba];
        //        if(distance<PINK_COLOR_OFFSET)
        //            return PINK_DIRTY_PIXEL;
        //        else
        //            return NO_DIRTY_PIXEL;
        
    }
    else //means green serial
    {
        return BLUE_DIRTY_PIXEL;
    }
}

@end
