//
//  TestView.m
//  PWProgressView
//
//  Created by Peter Willsey on 12/17/13.
//  Copyright (c) 2013 Peter Willsey, Inc. All rights reserved.
//

#import "StarProgressView.h"
#import <QuartzCore/QuartzCore.h>

static const CGFloat PWCenterHoleInsetRatio             = 0.2f;
static const CGFloat PWProgressShapeInsetRatio          = 0.03f;
static const CGFloat PWDefaultAlpha                     = 0.45f;
static const CGFloat PWScaleAnimationScaleFactor        = 2.3f;
static const CFTimeInterval PWScaleAnimationDuration    = 0.5;

#define RECTT

@interface StarProgressView ()

@property (nonatomic, strong) CAShapeLayer *boxShape;
@property (nonatomic, strong) CAShapeLayer *progressShape;

@end

@implementation StarProgressView

- (instancetype)init
{
    return [self initWithFrame:CGRectZero];
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.alpha = PWDefaultAlpha;
        
        self.boxShape = [CAShapeLayer layer];
        
        self.boxShape.fillColor         = [UIColor blackColor].CGColor;
        self.boxShape.anchorPoint       = CGPointMake(0.5f, 0.5f);
        self.boxShape.contentsGravity   = kCAGravityCenter;
        self.boxShape.fillRule          = kCAFillRuleEvenOdd;

        self.progressShape = [CAShapeLayer layer];
        
        self.progressShape.fillColor   = [UIColor clearColor].CGColor;  // 闭环填充的颜色
        self.progressShape.strokeColor = [UIColor blackColor].CGColor;    //边缘线的颜色

        [self.layer addSublayer:self.boxShape];
        [self.layer addSublayer:self.progressShape];
    }
    
    return self;
}

- (void)layoutSubviews
{
    CGFloat centerHoleInset     = PWCenterHoleInsetRatio * CGRectGetWidth(self.bounds);
    CGFloat progressShapeInset  = PWProgressShapeInsetRatio * CGRectGetWidth(self.bounds);
    
    CGRect pathRect = CGRectMake(0,
                                 0,
                                 CGRectGetWidth(self.bounds),
                                 CGRectGetHeight(self.bounds));
    
    UIBezierPath *path = [UIBezierPath bezierPathWithRect:pathRect];  //用弧线创建矩形
    
    [path appendPath:[UIBezierPath bezierPathWithRoundedRect:CGRectMake(self.bounds.size.width/2 - 40,
                                                                        self.bounds.size.height/2 - 40,
                                                                        80,
                                                                        80)
                                                cornerRadius:(CGRectGetWidth(self.bounds) - centerHoleInset * 2) / 2.0f]];

    [path setUsesEvenOddFillRule:YES];
    
    self.boxShape.path = path.CGPath;
    self.boxShape.bounds = pathRect;
    self.boxShape.position = CGPointMake(CGRectGetMidX(pathRect), CGRectGetMidY(pathRect));

    CGFloat diameter = 80-4;//178 - (2 * centerHoleInset) - (2 * progressShapeInset);
    CGFloat radius = diameter / 2.0f;
    
    self.progressShape.path = [UIBezierPath bezierPathWithRoundedRect:CGRectMake((CGRectGetWidth(self.bounds) / 2.0f) - (radius / 2.0f),
                                                                                 (CGRectGetHeight(self.bounds) / 2.0f) - (radius / 2.0f),
                                                                                 radius,
                                                                                 radius)
                                                         cornerRadius:radius].CGPath;
    
    self.progressShape.lineWidth = radius;
}

- (void)setProgress:(float)progress
{
    self.progressShape.strokeStart = progress;

    if (_progress == 1.0f && progress < 1.0f) {
        [self.boxShape removeAllAnimations];
    }
}

- (float)pinnedProgress:(float)progress
{
    float pinnedProgress = MAX(0.0f, progress);
    pinnedProgress = MIN(1.0f, progress);
    
    return pinnedProgress;
}

@end
