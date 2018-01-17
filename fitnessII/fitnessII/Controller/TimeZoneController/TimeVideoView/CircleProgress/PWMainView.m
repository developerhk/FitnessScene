//
//  PWMainView.m
//  PWProgressView
//
//  Created by Peter Willsey on 1/8/14.
//  Copyright (c) 2014 Peter Willsey. All rights reserved.
//

#import "PWMainView.h"
#import "PWProgressView.h"

static const CGSize PWProgressViewSize      = {225.0f, 110.0f};


@implementation PWMainView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.imageView = [[UIImageView alloc] init];
        self.imageView.clipsToBounds = YES;
        [self addSubview:self.imageView];
        
        self.progressView = [[PWProgressView alloc] init];
        self.progressView.layer.cornerRadius = 5.0f;
        self.progressView.clipsToBounds = YES;
        [self addSubview:self.progressView];
    }
    return self;
}

- (void)layoutSubviews
{
    self.imageView.frame = CGRectMake(0,
                                      0,
                                      PWProgressViewSize.width,
                                      PWProgressViewSize.height);

    self.progressView.frame = CGRectMake(0,
                                         0,
                                         225,
                                         110);
}

@end
