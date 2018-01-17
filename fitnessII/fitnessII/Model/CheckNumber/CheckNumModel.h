//
//  CheckNumModel.h
//  fitnessII
//
//  Created by Haley on 15/7/7.
//  Copyright (c) 2015年 samples.hankang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CheckNumModel : NSObject

@property (nonatomic, retain) NSString *studentName;      //学生姓名
@property (nonatomic, retain) NSString *bindingID;        //已绑定人

@property (nonatomic, assign) BOOL isChooseChild;
@property (nonatomic, assign) BOOL isChooseFather;
@property (nonatomic, assign) BOOL isChooseMather;

+ (CheckNumModel *)CNWithInfo:(NSDictionary *)info;
@end
