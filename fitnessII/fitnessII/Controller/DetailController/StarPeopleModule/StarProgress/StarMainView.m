//
//  PWMainView.m
//  PWProgressView
//
//  Created by Peter Willsey on 1/8/14.
//  Copyright (c) 2014 Peter Willsey. All rights reserved.
//

#import "StarMainView.h"
#import "StarProgressView.h"

static const CGSize StarProgressViewSize      = {320.0f, 178.0f};


@implementation StarMainView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.imageView = [[UIImageView alloc] init];
        self.imageView.clipsToBounds = YES;
        [self addSubview:self.imageView];
        
        self.progressView = [[StarProgressView alloc] init];
        self.progressView.clipsToBounds = YES;
        [self addSubview:self.progressView];
    }
    return self;
}

- (void)layoutSubviews
{
    self.imageView.frame = CGRectMake(0,
                                      0,
                                      StarProgressViewSize.width,
                                      StarProgressViewSize.height);

    self.progressView.frame = CGRectMake(0,
                                         0,
                                         320,
                                         178);
}

@end
