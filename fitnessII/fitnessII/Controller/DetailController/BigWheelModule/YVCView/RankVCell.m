//
//  RankVCell.m
//  fitnessII
//
//  Created by Haley on 15/8/11.
//  Copyright (c) 2015年 samples.hankang. All rights reserved.
//

#import "RankVCell.h"

@implementation RankVCell

- (void)awakeFromNib
{
    // Initialization code
    self.timeLabel.adjustsFontSizeToFitWidth = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
