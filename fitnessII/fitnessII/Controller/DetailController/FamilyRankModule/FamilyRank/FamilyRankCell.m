//
//  FamilyRankCell.m
//  fitnessII
//
//  Created by Haley on 15/11/20.
//  Copyright (c) 2015年 samples.hankang. All rights reserved.
//

#import "FamilyRankCell.h"

@implementation FamilyRankCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)showMessageWithModel:(FamilyRankModel *)model
{
    if(model.isSelf)
    {
        self.backgroundColor = UIColorFromRGB(0xfeab69);
    }
    else
    {
        self.backgroundColor = UIColorFromRGB(0xfedcc1);
    }
    self.nameLabel.text = model.studentName;
    self.scoreLabel.text = [NSString stringWithFormat:@"%@分",model.wkScores];

}

@end
