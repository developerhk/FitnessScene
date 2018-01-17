//
//  StarView.m
//  fitnessII
//
//  Created by Haley on 15/11/24.
//  Copyright (c) 2015年 samples.hankang. All rights reserved.
//

#import "StarView.h"
#import <QuartzCore/QuartzCore.h>

@implementation StarView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

-(void)awakeFromNib
{
    [super awakeFromNib];
    
    self.webView.layer.masksToBounds = YES;
    self.webView.layer.cornerRadius = 6.0;

    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://%@/VideoInfoForSun",HostName]]]];
    self.webView.scrollView.showsVerticalScrollIndicator = NO;
}

-(IBAction)actionDelete:(id)sender
{
    [self removeFromSuperview];
}

@end
