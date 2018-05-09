//
//  AnalyzeEngine.m
//  SmartGel
//
//  Created by jordi on 09/05/2018.
//  Copyright © 2018 AFCO. All rights reserved.
//

#import "AnalyzeEngine.h"

@implementation AnalyzeEngine

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

-(void)getCleanAreaAverageValue:(UIImage *)image{
    CGImageRef ref = image.CGImage;
    CGContextRef bitmapcrop1 = [self createARGBBitmapContextFromImage:ref];
    if (bitmapcrop1 == NULL)
    {
        return;
    }
    
    size_t w = CGImageGetWidth(ref);
    size_t h = CGImageGetHeight(ref);
    CGRect rect = {{0,0},{w,h}};
    CGContextDrawImage(bitmapcrop1, rect, ref);
    unsigned char* data = CGBitmapContextGetData (bitmapcrop1);
    if (data != NULL)
    {
        
        //_________________________________________________________
        //BLANK Crop
        
        int xb=0,yb=0,rednewbx=0,greennewbx=0,bluenewbx=0,rednewby=0,greennewby=0,bluenewby=0,nb=0;
        //br = (width*width%/100)
        float br,bl,bt,bb;
        br=(w*20.0/100.0);
        bl=(w*35.0/100.0);
        bt=(h*75.0/100.0);//55
        bb=(h*90.0/100.0);//70
        
        for(yb=bt;yb<bb;yb++)
        {
            for(xb=br;xb<bl;xb++)
            {
                nb++;
                int offset = 4*((w*yb)+xb);
                int redb = data[offset+1];
                data[offset+1]=255;
                int greenb = data[offset+2];
                data[offset+2]=255;
                int blueb = data[offset+3];
                data[offset+3]=255;
                rednewbx=rednewbx+redb;
                greennewbx=greennewbx+greenb;
                bluenewbx=bluenewbx+blueb;
            }
            nb++;
            rednewby=rednewby+rednewbx;
            greennewby=greennewby+greennewbx;
            bluenewby=bluenewby+bluenewbx;
            rednewbx=0;greennewbx=0;bluenewbx=0;
        }
        
        int xs=0,ys=0,rednewsx=0,greennewsx=0,bluenewsx=0,rednewsy=0,greennewsy=0,bluenewsy=0,ns=0;
        float sr,sl,st,sb;
        sr=(w*70.0/100.0);
        sl=(w*85.0/100.0);
        st=(h*75.0/100.0);//55
        sb=(h*90.0/100.0);//70
        int alpha;
        for(ys=st;ys<sb;ys++)
        {
            for(xs=sr;xs<sl;xs++)
            {
                ns++;
                int offset = 4*((w*ys)+xs);
                alpha =  data[offset]; //maybe we need it?
                int reds = data[offset+1];
                data[offset+1]=255;
                int greens = data[offset+2];
                data[offset+1]=255;
                int blues = data[offset+3];
                data[offset+1]=255;
                rednewsx=rednewsx+reds;
                greennewsx=greennewsx+greens;
                bluenewsx=bluenewsx+blues;
            }
            ns++;
            rednewsy=rednewsy+rednewsx;
            greennewsy=greennewsy+greennewsx;
            bluenewsy=bluenewsy+bluenewsx;
            rednewsx=0; greennewsx=0; bluenewsx=0;
        }
        
        float sred,sgreen,sblue,bred,bgreen,bblue,ssred,ssgreen,ssblue,bbblue,bbgreen,bbred;
        bred=rednewby/(nb*255.0f);
        bgreen=greennewby/(nb*255.0f);
        bblue=bluenewby/(nb*255.0f);
        sred=rednewsy/(ns*255.0f);
        sgreen=greennewsy/(ns*255.0f);
        sblue=bluenewsy/(ns*255.0f);
    }

}

-(void)getDirtyAreaAverageValue:(UIImage *)image{
    
}

- (CGContextRef) createARGBBitmapContextFromImage:(CGImageRef) inImage {
    
    CGContextRef    context = NULL;
    CGColorSpaceRef colorSpace;
    void *          bitmapData;
    int             bitmapByteCount;
    int             bitmapBytesPerRow;
    
    // Get image width, height. We'll use the entire image.
    size_t pixelsWide = CGImageGetWidth(inImage);
    size_t pixelsHigh = CGImageGetHeight(inImage);
    
    // Declare the number of bytes per row. Each pixel in the bitmap in this
    // example is represented by 4 bytes; 8 bits each of red, green, blue, and
    // alpha.
    bitmapBytesPerRow   = (pixelsWide * 4);
    bitmapByteCount     = (bitmapBytesPerRow * pixelsHigh);
    
    // Use the generic RGB color space.
    colorSpace = CGColorSpaceCreateDeviceRGB();
    if (colorSpace == NULL)
    {
        fprintf(stderr, "Error allocating color space\n");
        return NULL;
    }
    
    // Allocate memory for image data. This is the destination in memory
    // where any drawing to the bitmap context will be rendered.
    bitmapData = malloc( bitmapByteCount );
    if (bitmapData == NULL)
    {
        fprintf (stderr, "Memory not allocated!");
        CGColorSpaceRelease( colorSpace );
        return NULL;
    }
    
    // Create the bitmap context. We want pre-multiplied ARGB, 8-bits
    // per component. Regardless of what the source image format is
    // (CMYK, Grayscale, and so on) it will be converted over to the format
    // specified here by CGBitmapContextCreate.
    context = CGBitmapContextCreate (bitmapData,
                                     pixelsWide,
                                     pixelsHigh,
                                     8,      // bits per component
                                     bitmapBytesPerRow,
                                     colorSpace,
                                     kCGImageAlphaPremultipliedFirst);
    if (context == NULL)
    {
        free (bitmapData);
        fprintf (stderr, "Context not created!");
    }
    
    // Make sure and release colorspace before returning
    CGColorSpaceRelease( colorSpace );
    return context;
}


@end
