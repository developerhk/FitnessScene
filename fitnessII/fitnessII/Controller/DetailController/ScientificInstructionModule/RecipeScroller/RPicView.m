//
//  RPicView.m
//  fitnessII
//
//  Created by Haley on 15/9/14.
//  Copyright (c) 2015年 samples.hankang. All rights reserved.
//

#import "RPicView.h"

@implementation RPicView

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
}

-(IBAction)actionPressButton:(UIButton *)sender
{
    //事件统计 科学运动指导页面 点击动作介绍-查看视频动作内容
    [MobClick event:SportsGuide_ShowActionGuide];
    
    if(self.rPicViewBlock)
    {
        self.rPicViewBlock();
    }
}

@end
