//
//  StarHeaderCell.m
//  fitnessII
//
//  Created by Jack on 15/11/4.
//  Copyright © 2015年 samples.hankang. All rights reserved.
//

#import "StarHeaderCell.h"
#import "UIImageView+WebCache.h"

@implementation StarHeaderCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(IBAction)actionDeatil:(id)sender
{
    //事件统计 名家讲坛 点击孙教授介绍按钮
    [MobClick event:ProfessorCourse_ShowProfile];
    
    if(self.headerBlock)
    {
        self.headerBlock();
    }
}

-(void)showMeassageWithModel:(StarZoneModel*)model
{
    if(model)
    {
        self.topicName.text = model.topicName;
        [self.headerIV sd_setImageWithURL:[NSURL URLWithString:model.picName]];
        NSString *sizeString = [NSString stringWithFormat:@"       %@",model.videoContent];
        CGSize size = [sizeString sizeWithFont:[UIFont systemFontOfSize:14] constrainedToSize:CGSizeMake(self.detailLabel.frame.size.width, MAXFLOAT) lineBreakMode:LineBreakByCharWrapping];
        self.detailLabel.frame = CGRectMake(self.detailLabel.frame.origin.x, self.detailLabel.frame.origin.y, self.detailLabel.frame.size.width, size.height+5);
        self.detailLabel.text = sizeString.length > 0?sizeString:@"";
    }
    else
    {
        self.detailBut.hidden = YES;
    }
}

@end
