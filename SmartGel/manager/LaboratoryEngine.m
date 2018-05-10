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

-(void)getCropAreaAverageColor:(UIImage *)image
                    widthStart:(float)widthStart
                      widthEnd:(float)widthEnd
                   heightStart:(float)heightStart
                     heightEnd:(float)heightEnd{
    CGContextRef bitmapcrop1 = [[SGColorUtil sharedColorUtil] createARGBBitmapContextFromImage:image.CGImage];
    if (bitmapcrop1 == NULL){
        return;
    }
}

-(void)getCleanAreaAverageValue:(UIImage *)image{
    CGImageRef ref = image.CGImage;
    CGContextRef bitmapcrop1 = [[SGColorUtil sharedColorUtil] createARGBBitmapContextFromImage:ref];
    if (bitmapcrop1 == NULL){
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


@end
