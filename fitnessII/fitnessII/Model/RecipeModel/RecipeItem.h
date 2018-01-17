//
//  RecipeItem.h
//  fitnessII
//
//  Created by Haley on 15/9/6.
//  Copyright (c) 2015年 samples.hankang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RecipeItem : NSObject
@property (nonatomic, retain) NSString *actionName;       //动作的名称           12
@property (nonatomic, retain) NSString *thumbName;        //缩略图名称           1
@property (nonatomic, retain) NSString *picName;          //详情图名称           2
@property (nonatomic, retain) NSString *repeatTimes;      //组数或者坚持的描述    8
@property (nonatomic, retain) NSString *waitTime;         //休息的时间，单位是秒   9
@property (nonatomic, retain) NSString *actionType;       //"N"-次,“T”是秒       3
@property (nonatomic, retain) NSString *difficult;        //难易程度
@property (nonatomic, retain) NSString *pertinence;        //针对项目 锻炼部位

@property (nonatomic, retain) NSString *actionTitle;      //动作描述的标题        10
@property (nonatomic, retain) NSString *actionContent;    //动作描述的内容         7

@property (nonatomic, retain) NSString *videoName;        //视频名称               5

@property (nonatomic, retain) NSString *groupNum;         //动作的组数            13
@property (nonatomic, retain) NSString *audioName;        //动作的语音           14

@property (nonatomic, retain) NSString *guideID;          //动作指导的编码         11
@property (nonatomic, retain) NSString *actionID;         //动作的编码           4
@property (nonatomic, retain) NSString *seq;              //顺序，是一个序列，按照从小到大排列，暂时用不到   6

@property (nonatomic, retain) NSString *thumbUrl;         //介绍页面的缩略图

+ (RecipeItem *)RWithInfo:(NSDictionary *)info;
@end
