//
//  FamilyRankModel.h
//  fitnessII
//
//  Created by Haley on 15/11/20.
//  Copyright (c) 2015年 samples.hankang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FamilyRankModel : NSObject
@property (nonatomic, retain) NSString *position;         //排名
@property (nonatomic, retain) NSString *wkScores;         //得分
@property (nonatomic, assign) BOOL isSelf;           //是否是自己
@property (nonatomic, retain) NSString *studentName;      //家庭姓名

+ (FamilyRankModel *)FRWithInfo:(NSDictionary *)info;

@end
