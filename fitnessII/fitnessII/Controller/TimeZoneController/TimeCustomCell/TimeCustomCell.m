//
//  TimeCustomCell.m
//  fitnessII
//
//  Created by Haley on 15/7/6.
//  Copyright (c) 2015年 samples.hankang. All rights reserved.
//

#import "TimeCustomCell.h"
#import "UIImageView+WebCache.h"

@implementation TimeCustomCell

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
}

-(void)showMsgWithModel:(TimeShaftModel *)model
{
    //头像
    UIImage *head = nil;
    if([model.gender isEqualToString:@"B"])    //boy
    {
        head = [UIImage imageNamed:@"timeboy.png"];
    }
    else if ([model.gender isEqualToString:@"G"])  //girl
    {
        head = [UIImage imageNamed:@"timegirl.png"];
    }
    else if ([model.gender isEqualToString:@"M"])  //男
    {
        head = [UIImage imageNamed:@"timedad.png"];
    }
    else
    {
        head = [UIImage imageNamed:@"timemom.png"];
    }

    [self.headImageView sd_setImageWithURL:[NSURL URLWithString:model.headPortrait] placeholderImage:head];

    UIImageView *headImageUp = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.headImageView.frame.size.width, self.headImageView.frame.size.height)];
    headImageUp.image = [UIImage imageNamed:@"ULtouxiangbg.png"];
    [self.headImageView addSubview:headImageUp];

    //time
    self.timeLabel.text = model.playTime;
    
    if([model.isNew isEqualToString:@"T"])
    {
        self.sign.image = [UIImage imageNamed:@"redPoint.png"];
    }
    else
    {
        self.sign.image = [UIImage imageNamed:@"black.png"];
    }
     self.nameLabel.text = model.userName;
    
    //content
    NSString *sizeString = [NSString stringWithFormat:@"%@",model.content];
    CGSize size = [sizeString sizeWithFont:[UIFont systemFontOfSize:12] constrainedToSize:CGSizeMake(227, MAXFLOAT) lineBreakMode:LineBreakByCharWrapping];
    self.contentLabel.frame = CGRectMake(self.contentLabel.frame.origin.x, self.contentLabel.frame.origin.y, self.contentLabel.frame.size.width, size.height+5);
    self.contentLabel.text =model.content;
    
    //图片
    if(model.activityPicUrl.length > 0 && model.activityPicUrl != nil)
    {
        [self prepareForPic];
        [self addImagesWithFiles:CGRectGetMaxY(self.contentLabel.frame) model:model];
    }
    else
    {
        self.picBGView.hidden = YES;
    }
    
    //视频
    if(model.activityVIDeoUrl.length > 0 && model.activityVIDeoUrl != nil)//
    {
        [self prepareForVideo];
        float yy = CGRectGetMaxY(self.contentLabel.frame) + self.picBGView.frame.size.height + 10;
        [self addVideoFiles:yy model:model];
    }
    else
    {
        self.videoView.hidden = YES;
    }
}

-(void)prepareForPic
{
    [super prepareForReuse];
    
    for(UIView * view in _picBGView.subviews)
    {
        [view removeFromSuperview];
    }
}

-(void)prepareForVideo
{
    [super prepareForReuse];
    for(UIView * view in _videoView.subviews)
    {
        [view removeFromSuperview];
    }
}

-(void)addImagesWithFiles:(float)offset model:(TimeShaftModel *)model
{
    self.picBGView.hidden=NO;
    CGRect  frame=self.picBGView.frame;
    frame.origin.y=offset+5;
    frame.size.height=[self getHightFromPicCount:[model.picArray count]];
    self.picBGView.frame=frame;
    
    __weak TimeCustomCell * wself=self;
    dispatch_queue_t queue=dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(queue, ^{
        if (wself) {
            __strong TimeCustomCell * sself=wself;
            dispatch_async(dispatch_get_main_queue(), ^{
                HBShowImageControl * control=[[HBShowImageControl alloc]initWithFrame: sself.picBGView.bounds];
                control.smallTag=THUMB_WEIBO_SMALL_1;
                control.bigTag=THUMB_WEIBO_BIG;
                [control setImagesFileArr:model.activityPicThumbnailArray];
                [sself.picBGView addSubview:control];
                control.delegate=sself;
            });
        }
    });
}

-(float)getHightFromPicCount:(int)count
{
    if(count == 1)
    {
        return 110.0;
    }
    else if (count == 2 || count == 3)
    {
        return 75.0;
    }
    else if (count == 4 || count ==5 || count ==6)
    {
        return 150.0;
    }
    else
    {
        return 225.0;
    }
}

+(float)getHeightByContent:(TimeShaftModel*)data
{
    float height = 0.0;
    float vHeight = 0.0;

    //内容高度
    NSString *sizeString = [NSString stringWithFormat:@"%@%@",data.userName ,data.content];
    CGSize size = [sizeString sizeWithFont:[UIFont systemFontOfSize:10] constrainedToSize:CGSizeMake(227, MAXFLOAT) lineBreakMode:LineBreakByCharWrapping];
    
    //图片高度
    if(data.activityPicUrl.length > 0 && data.activityPicUrl != nil)
    {
        if([data.picArray count] == 1)
        {
            height = 120.0;
        }
        else if ([data.picArray count] == 2 || [data.picArray count] == 3)
        {
            height =75.0;
        }
        else if ([data.picArray count] == 4 || [data.picArray count] ==5 || [data.picArray count] ==6)
        {
            height =150.0;
        }
        else
        {
            height =225.0;
        }
        
    }
    
    //视频高度
    if(data.activityVIDeoUrl.length > 0 && data.activityVIDeoUrl != nil)
    {
        vHeight = 115 * [data.videoArray count];
    }
    
    return size.height +70 + height+vHeight > 100?size.height +70 + height+vHeight:100;
}

-(void)addVideoFiles:(float)offset model:(TimeShaftModel *)model
{
    self.currentModel = model;
    self.videoView.hidden=NO;
    CGRect frame=self.videoView.frame;
    frame.origin.y=offset;
    frame.size.height= 115*[model.videoArray count];
    self.videoView.frame=frame;
    
    dispatch_queue_t queue=dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(queue, ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            
            for (int i = 0; i<[model.videoArray count]; i++) {
                PWMainView *pwView = [[PWMainView alloc] init];
                pwView.frame = CGRectMake(0, (110+5)*i, self.videoView.bounds.size.width, 110);
                pwView.tag = 1000+i;
                [pwView.imageView sd_setImageWithURL:[NSURL URLWithString:[model.activityVidThumbnailArray objectAtIndex:i]] placeholderImage:[UIImage imageNamed:@"spDafult.png"]];
                pwView.progressView.hidden = YES;
                [self.videoView addSubview:pwView];
                
                UIImageView *videoBackView = [[UIImageView alloc] initWithFrame:pwView.bounds];
                videoBackView.tag = 1000+i;
                videoBackView.backgroundColor = [UIColor blackColor];
                videoBackView.alpha = 0.4;
                [pwView addSubview:videoBackView];
                
                UIButton *playBut = [[UIButton alloc] initWithFrame:CGRectMake(87, 30, 50, 50)];
                playBut.tag = 1000+i;
                [playBut setImage:[UIImage imageNamed:@"play.png"] forState:UIControlStateNormal];
                [playBut addTarget:self action:@selector(actionUpload:) forControlEvents:UIControlEventTouchUpInside];
                [pwView addSubview:playBut];
            }
        });
    });
}

-(void)actionUpload:(UIButton *)but
{
    //事件统计 运动时光 点击视频
    [MobClick event:SportsTime_ZoomVideo];
    
    //注意 － 先判断本地有没有视频 有直接播放  没有下载
    NSUInteger index = but.tag-1000;
    self.currentVideoUrl = [self.currentModel.videoArray objectAtIndex:index];
    self.currentVideoSize = [self.currentModel.activityVidSizeArray objectAtIndex:index];
    BOOL isExist = NO;
    if(self.delegate && [self.delegate respondsToSelector:@selector(timeCell:withVideoURL:videoSize:videoTag:)])
    {
        isExist = [self.delegate timeCell:self withVideoURL:self.currentVideoUrl videoSize:self.currentVideoSize videoTag:but.tag];
    }
}

-(void)actionFinishUpload
{

}

-(void)awakeFromNib
{
    [super awakeFromNib];
}

-(void)layoutSubviews
{
    [super layoutSubviews];
}

@end
