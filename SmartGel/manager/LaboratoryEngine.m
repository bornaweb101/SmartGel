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

-(RGBA)getCropAreaAverageColor:(UIImage *)image
                    widthStart:(float)widthStart
                      widthEnd:(float)widthEnd
                   heightStart:(float)heightStart
                     heightEnd:(float)heightEnd{
    [self importImage:image];
    [self smoothBufferByAverage];
//    RGBA rgba;
//    CGImageRef ref = image.CGImage;
//    CGContextRef bitmapcrop1 = [[SGColorUtil sharedColorUtil] createARGBBitmapContextFromImage:image.CGImage];
//    size_t width = CGImageGetWidth(ref);
//    size_t height = CGImageGetHeight(ref);
//
//    CGRect rect = {{0,0},{width,height}};
//    CGContextDrawImage(bitmapcrop1, rect, ref);
//    unsigned char* data = CGBitmapContextGetData (bitmapcrop1);
//
    widthStart=(m_imageWidth*widthStart/100.0);
    widthEnd=(m_imageWidth*widthEnd/100.0);
    heightStart=(m_imageHeight*heightStart/100.0);
    heightEnd=(m_imageHeight*heightEnd/100.0);
    

    int sumR = 0, sumG =0, sumB = 0, nCount = 0;
    
    if(m_pOutBuffer != NULL){
        for(int i = heightStart;i<heightEnd;i++){
            for(int j = widthStart;j<widthEnd;j++){
                RGBA rgba;
                int index = i * m_imageWidth + j;
                memcpy(&rgba, &m_pInBuffer[index], sizeof(RGBA));
                sumR += rgba.r;
                sumG += rgba.g;
                sumB += rgba.b;
                nCount ++;
            }
        }
    }
    RGBA averageRGB;
    averageRGB.r = sumR / nCount;
    averageRGB.g = sumG / nCount;
    averageRGB.b = sumB / nCount;
    averageRGB = [self filterPickColors:averageRGB widthStart:widthStart widthEnd:widthEnd heightStart:heightStart heightEnd:heightEnd];
    [self reset];
    return averageRGB;
}

- (RGBA) filterPickColors:(RGBA)averageRGB
               widthStart:(float)widthStart
                 widthEnd:(float)widthEnd
              heightStart:(float)heightStart
                heightEnd:(float)heightEnd{
    
    int sumR = 0, sumG =0, sumB = 0, nCount = 0;
    if(m_pOutBuffer != NULL){
        for(int i = heightStart;i<heightEnd;i++){
            for(int j = widthStart;j<widthEnd;j++){
                RGBA rgba;
                int index = i * m_imageWidth + j;
                memcpy(&rgba, &m_pInBuffer[index], sizeof(RGBA));
                UInt8 minValue = 0x8F;
                if (rgba.r > minValue || rgba.g > minValue || rgba.b > minValue){
                    sumR += rgba.r;
                    sumG += rgba.g;
                    sumB += rgba.b;
                    nCount ++;
                }
            }
        }
    }
    RGBA resultRGB;
    resultRGB.r = sumR / nCount;
    resultRGB.g = sumG / nCount;
    resultRGB.b = sumB / nCount;
    [self reset];
    return resultRGB;
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

@end
