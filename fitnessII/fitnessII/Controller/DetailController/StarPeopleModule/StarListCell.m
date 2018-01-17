//
//  StarListCell.m
//  fitnessII
//
//  Created by Jack on 15/11/4.
//  Copyright © 2015年 samples.hankang. All rights reserved.
//

#import "StarListCell.h"
#import "UIImageView+WebCache.h"

@implementation StarListCell

- (void)awakeFromNib {
    // Initialization code
    [self.stateBut setImage:[UIImage imageNamed:@"starplay"] forState:UIControlStateSelected];
    [self.stateBut setImage:[UIImage imageNamed:@"starlock"] forState:UIControlStateNormal];
    
    UILabel *topLine = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.width, SINGLE_LINE)];
    topLine.backgroundColor = [UIColor grayColor];
    topLine.contentMode = UIViewContentModeScaleAspectFit;
    [self.mainView addSubview:topLine];
    
    UILabel *bottomLine = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetHeight(self.mainView.frame) -SINGLE_LINE, self.bounds.size.width, SINGLE_LINE)];
    bottomLine.backgroundColor = [UIColor grayColor];
    bottomLine.contentMode = UIViewContentModeScaleAspectFit;
    [self.mainView addSubview:bottomLine];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)showMessageWithModel:(StarModel *)model
{
    if([model.videoLock intValue] == 1)
    {
        //上锁
        self.stateBut.selected = NO;
    }
    else
    {
        self.stateBut.selected = YES;
    }
    
    self.titleLabel.text = model.topicName;

    StarMainView *pwView = [[StarMainView alloc] init];
    pwView.clipsToBounds = YES;
    pwView.frame = CGRectMake(0, 1, self.mainView.bounds.size.width, self.mainView.bounds.size.height-2);
    [pwView.imageView sd_setImageWithURL:[NSURL URLWithString:model.thumbnailUrl] placeholderImage:[UIImage imageNamed:@"spDafult.png"]];
    pwView.progressView.hidden = YES;
    [self.mainView addSubview:pwView];

}

-(IBAction)actionTapButton:(UIButton *)sender
{
    if(sender.selected)
    {
        //播放
        if(self.delegate && [self.delegate respondsToSelector:@selector(starCell:withtag:isLock:)])
        {
            [self.delegate starCell:self withtag:sender.tag isLock:NO];
        }
    }
    else
    {
        //解锁
        if(self.delegate && [self.delegate respondsToSelector:@selector(starCell:withtag:isLock:)])
        {
            [self.delegate starCell:self withtag:sender.tag isLock:YES];
        }
    }
}

@end
