//
//  TimeCustomCell.h
//  fitnessII
//
//  Created by Haley on 15/7/6.
//  Copyright (c) 2015年 samples.hankang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TimeShaftModel.h"
#import "HBShowImageControl.h"
#import "PWMainView.h"
#import "PWProgressView.h"

@class TimeCustomCell;
@protocol TimeCustomCellDelegate <NSObject>

-(BOOL)timeCell:(TimeCustomCell *)cell withVideoURL:(NSString *)videoURL videoSize:(NSString*)size videoTag:(NSInteger)tag;

@end

@interface TimeCustomCell : UITableViewCell<HBShowImageControlDelegate>
@property (nonatomic, assign) id<TimeCustomCellDelegate> delegate;
@property (nonatomic, strong) NSString *currentVideoUrl;
@property (nonatomic, strong) NSString *currentVideoSize;
@property (nonatomic, strong) TimeShaftModel *currentModel;

@property (nonatomic, strong) IBOutlet UILabel *nameLabel;
@property (nonatomic, strong) IBOutlet UIImageView *headImageView;
@property (nonatomic, strong) IBOutlet UILabel *timeLabel;
@property (nonatomic, strong) IBOutlet UILabel *contentLabel;
@property (nonatomic, strong) IBOutlet UIImageView *sign;

@property (nonatomic, strong) IBOutlet UIView *picBGView;
@property (nonatomic, strong) IBOutlet UIView *videoView;

-(void)showMsgWithModel:(TimeShaftModel *)model;

-(float)getHightFromPicCount:(int)count;

+(float)getHeightByContent:(TimeShaftModel*)data;

@end
