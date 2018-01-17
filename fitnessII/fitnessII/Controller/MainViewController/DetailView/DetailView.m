//
//  DetailView.m
//  fitnessII
//
//  Created by Haley on 15/7/12.
//  Copyright (c) 2015年 samples.hankang. All rights reserved.
//

#import "DetailView.h"

@implementation DetailView
@synthesize dvDelegate;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

-(void)awakeFromNib
{
    [super awakeFromNib];
    
    //UIButton 的排他性
    [self.headBut setExclusiveTouch:YES];
    [self.starBut setExclusiveTouch:YES];
    [self.jtpmBut setExclusiveTouch:YES];
    [self.tzpjBut setExclusiveTouch:YES];
    [self.gbcpBut setExclusiveTouch:YES];
    [self.headBut setExclusiveTouch:YES];
    [self.xlfdBut setExclusiveTouch:YES];
}

-(IBAction)actionPressButton:(UIButton *)sender
{
        NSInteger tag = sender.tag;
        int indx  = [[NSString stringWithFormat:@"%ld",(long)tag] intValue];
        if(self.dvDelegate && [self.dvDelegate respondsToSelector:@selector(actionPressWithButtonAttribute:)])
        {
            [self.dvDelegate actionPressWithButtonAttribute:indx];
        }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
