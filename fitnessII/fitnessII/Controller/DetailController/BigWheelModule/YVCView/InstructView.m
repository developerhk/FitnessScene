//
//  InstructView.m
//  fitnessII
//
//  Created by Haley on 15/7/14.
//  Copyright (c) 2015年 samples.hankang. All rights reserved.
//

#import "InstructView.h"

@implementation InstructView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

-(void)showMessageWithTag:(int)tag
{
    switch (tag) {
        case 1:
        {
            self.pic.image = [UIImage imageNamed:@"pbzcImage.png"];
            self.detailLabel.text = TEXT_PBZC;
        }
            break;
        case 2:
        {
            self.pic.image = [UIImage imageNamed:@"ywqzImage.png"];
            self.detailLabel.text = TEXT_YWQZ;
        }
            break;
        case 3:
        {
            self.pic.image = [UIImage imageNamed:@"fwcImage.png"];
            self.detailLabel.text = TEXT_FWC;
        }
            break;
        case 4:
        {
            self.pic.image = [UIImage imageNamed:@"sdImage.png"];
            self.detailLabel.text = TEXT_SD;
        }
            break;
            
        default:
            break;
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
