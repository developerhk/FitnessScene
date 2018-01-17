//
//  RecipeDetailModel.h
//  fitnessII
//
//  Created by Haley on 15/9/14.
//  Copyright (c) 2015年 samples.hankang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RecipeDetailModel : NSObject

//目前可用
@property (nonatomic, retain) NSString *currentDay;      //本次运动指导已完成的天数，默认为0
@property (nonatomic, retain) NSString *days;            //运动指导总天数
@property (nonatomic, retain) NSString *playDuration;    //总耗时
@property (nonatomic, retain) NSString *units;           //流程中多少组动作

//目前不可用
@property (nonatomic, retain) NSString *descrip;         //运动指导的描述信息
@property (nonatomic, retain) NSString *userID;          //用户的编码
@property (nonatomic, retain) NSString *startTime;       //本次运动指导开始的时间
@property (nonatomic, retain) NSString *repeatTimes;     //运动指导已经完成的套数，目前没用
@property (nonatomic, retain) NSString *lastPlayTime;    //本次运动指导最后一次运动的时间
@property (nonatomic, retain) NSString *guideID;         //运动指导的编码
@property (nonatomic, retain) NSString *actionName;      //运动指导的名称

+ (RecipeDetailModel *)RDWithInfo:(NSDictionary *)info;
@end
