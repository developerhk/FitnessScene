//
//  SCGIFImageView.m
//  TestGIF
//
//  Created by shichangone on 11-7-12.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "SCGIFImageView.h"

#import <ImageIO/ImageIO.h>

#if __has_feature(objc_arc)
#define toCF (__bridge CFTypeRef)
#define ARCCompatibleAutorelease(object) object
#else
#define toCF (CFTypeRef)
#define ARCCompatibleAutorelease(object) [object autorelease]
#endif


@implementation SCGIFImageView
@synthesize GIF_frames;

+ (BOOL)isGifImage:(NSData*)imageData {
    if(!imageData){
        return NO;
    }
	const char* buf = (const char*)[imageData bytes];
	if (buf[0] == 0x47 && buf[1] == 0x49 && buf[2] == 0x46 && buf[3] == 0x38) {
		return YES;
	}
	return NO;
}

- (id)initWithGIFFile:(NSString*)gifFilePath {
	NSData* imageData = [NSData dataWithContentsOfFile:gifFilePath];
	return [self initWithGIFData:imageData];
}

- (id)initWithGIFData:(NSData*)gifImageData {
	
	
	self = [super init];
    
    if (self) {
        [self setGIFImageData:gifImageData];
    }
	
	
	return self;
}

- (void)setGIFData:(NSData*)gifImageData {
	[self setGIFImageData:gifImageData];
	
}
- (void)loadImageData{
    
}


- (void)setGIFImageFilePath:(NSString *)path
{
    NSData *data = [NSData dataWithContentsOfFile:path];
    return [self setGIFImageData:data];
}

- (void)setGIFImageData:(NSData *)data
{
    NSTimeInterval duration = [self durationForGifData:data];
    CGImageSourceRef source = CGImageSourceCreateWithData(toCF data, NULL);
    
    if (!source) return;
    size_t count = CGImageSourceGetCount(source);
    NSMutableArray *images = [NSMutableArray arrayWithCapacity:count];
    for (size_t i = 0; i < count; ++i) {
        CGImageRef cgImage = CGImageSourceCreateImageAtIndex(source, i, NULL);
        if (!cgImage)
            return;
        [images addObject:[UIImage imageWithCGImage:cgImage]];
        CGImageRelease(cgImage);
    }
    
    [self setAnimationImages:images];
    [self setAnimationDuration:duration];
    [self startAnimating];
    CFRelease(source);
}

- (NSTimeInterval)durationForGifData:(NSData *)data {
    char graphicControlExtensionStartBytes[] = {0x21,0xF9,0x04};
    double duration=0;
    NSRange dataSearchLeftRange = NSMakeRange(0, data.length);
    while(YES){
        NSRange frameDescriptorRange = [data rangeOfData:[NSData dataWithBytes:graphicControlExtensionStartBytes
                                                                        length:3]
                                                 options:NSDataSearchBackwards
                                                   range:dataSearchLeftRange];
        if(frameDescriptorRange.location!=NSNotFound){
            NSData *durationData = [data subdataWithRange:NSMakeRange(frameDescriptorRange.location+4, 2)];
            unsigned char buffer[2];
            [durationData getBytes:buffer];
            double delay = (buffer[0] | buffer[1] << 8);
            duration += delay;
            dataSearchLeftRange = NSMakeRange(0, frameDescriptorRange.location);
        }else{
            break;
        }
    }
    return duration/100;
}

-(void)stop
{
    [self stopAnimating];
}

@end
