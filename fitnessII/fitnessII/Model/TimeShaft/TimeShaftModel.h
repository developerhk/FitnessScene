//
//  TimeShaftModel.h
//  fitnessII
//
//  Created by Haley on 15/7/7.
//  Copyright (c) 2015年 samples.hankang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TimeShaftModel : NSObject
@property (nonatomic, retain) NSString *userID;                     //成员ID
@property (nonatomic, retain) NSString *userName;                   //成员姓名
@property (nonatomic, retain) NSString *headPortrait;               //成员头像
@property (nonatomic, retain) NSString *playTime;                   //运动时间
@property (nonatomic, retain) NSString *gender;                     //成员性别
@property (nonatomic, retain) NSString *content;                    //内容

@property (nonatomic, retain) NSString *activityPicSize;            //图片大小
@property (nonatomic, retain) NSArray  *activityPicSizeArray;
@property (nonatomic, retain) NSString *activityPicUrl;             //运动图片
@property (nonatomic, retain) NSArray  *picArray;
@property (nonatomic, retain) NSString *activityPicThumbnailUrl;    //运动图片缩略图
@property (nonatomic, retain) NSArray  *activityPicThumbnailArray;

@property (nonatomic, retain) NSString *activityVidSize;            //视频大小
@property (nonatomic, retain) NSArray  *activityVidSizeArray;
@property (nonatomic, retain) NSString *activityVIDeoUrl;           //运动视屏
@property (nonatomic, retain) NSArray *videoArray;
@property (nonatomic, retain) NSString *activityVidThumbnailUrl;    //运动视屏第一帧
@property (nonatomic, retain) NSArray *activityVidThumbnailArray;

@property (nonatomic, retain) NSString *isNew;                      //是否是最新的

+ (TimeShaftModel *)TSWithInfo:(NSDictionary *)info;

@end
