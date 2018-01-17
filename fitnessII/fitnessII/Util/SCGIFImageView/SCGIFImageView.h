//
//  SCGIFImageView.h
//  TestGIF
//
//  Created by shichangone on 11-7-12.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SCGIFImageView : UIImageView {
}
@property (nonatomic, retain) NSMutableArray *GIF_frames;

- (id)initWithGIFFile:(NSString*)gifFilePath;
- (id)initWithGIFData:(NSData*)gifImageData;
- (void)setGIFData:(NSData*)gifImageData;

- (void)loadImageData;

- (void)stop;

+ (BOOL)isGifImage:(NSData*)imageData ;
@end
