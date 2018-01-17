//
//  MemberScoreModel.h
//  fitnessII
//
//  Created by Haley on 15/7/16.
//  Copyright (c) 2015年 samples.hankang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MemberScoreModel : NSObject
@property (nonatomic, retain) NSArray *dataArray;

+ (MemberScoreModel *)MSWithInfo:(NSArray *)info;
@end
