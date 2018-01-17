//
//  MemberProModel.h
//  fitnessII
//
//  Created by Haley on 15/7/7.
//  Copyright (c) 2015年 samples.hankang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MemberProModel : NSObject
//1-BMI 2-肺活量 3-握力 4-坐位体前屈 5-仰卧起坐 6-跳绳 7-立定跳远
//100-深蹲 101-蛙跳 102-俯卧撑 103-平板支撑 104-走路
@property (nonatomic, retain) NSString *programID;     //成员ID
@property (nonatomic, retain) NSString *programName;   //项目名称
@property (nonatomic, retain) NSString *method;        //成绩来源 － M手机 E是设备
@property (nonatomic, retain) NSString *lastScore;     //成绩

+ (MemberProModel *)MPWithInfo:(NSDictionary *)info;
@end
