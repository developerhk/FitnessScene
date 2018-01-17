//
//  CounselHeaderCell.m
//  fitnessII
//
//  Created by Haley on 16/4/8.
//  Copyright © 2016年 samples.hankang. All rights reserved.
//

#import "CounselHeaderCell.h"
#import "UIImageView+WebCache.h"

@implementation CounselHeaderCell

- (void)awakeFromNib {
    // Initialization code
    
    self.headerIV.layer.masksToBounds = YES;
    self.headerIV.layer.cornerRadius = 6.0;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)showMeassageWithModel:(CounselModel*)model
{
    if(model)
    {
        self.topicName.text = model.topicName;
        
        [self.headerIV sd_setImageWithURL:[NSURL URLWithString:model.picName]];
        NSString *sizeString = [NSString stringWithFormat:@"       %@",model.videoContent];
        CGSize size = [sizeString sizeWithFont:[UIFont systemFontOfSize:14] constrainedToSize:CGSizeMake(self.detailLabel.frame.size.width, MAXFLOAT) lineBreakMode:LineBreakByCharWrapping];
        self.detailLabel.frame = CGRectMake(self.detailLabel.frame.origin.x, self.detailLabel.frame.origin.y, self.detailLabel.frame.size.width, size.height+5);
        self.detailLabel.text = sizeString;
    }

}

@end
