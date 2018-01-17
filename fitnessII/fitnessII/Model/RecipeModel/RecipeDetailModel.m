//
//  RecipeDetailModel.m
//  fitnessII
//
//  Created by Haley on 15/9/14.
//  Copyright (c) 2015年 samples.hankang. All rights reserved.
//

#import "RecipeDetailModel.h"

@implementation RecipeDetailModel
- (id)initWithListInfo:(NSDictionary *)info{
    self = [super init];
    if (self) {
        [self assingmentWithInfo:info];
    }
    
    return self;
}

+ (RecipeDetailModel *)RDWithInfo:(NSDictionary *)info
{
    return [[RecipeDetailModel alloc] initWithListInfo:info];
}

- (void)assingmentWithInfo:(NSDictionary *)info{
    IgnoreNullAssign(self.currentDay, [info objectForKey:@"CurrentDay"]);
    IgnoreNullAssign(self.days, [info objectForKey:@"Days"]);
    IgnoreNullAssign(self.playDuration, [info objectForKey:@"PlayDuration"]);
    IgnoreNullAssign(self.units, [info objectForKey:@"Units"]);
   
    IgnoreNullAssign(self.descrip, [info objectForKey:@"Description"]);
    IgnoreNullAssign(self.userID, [info objectForKey:@"UserID"]);
    IgnoreNullAssign(self.startTime, [info objectForKey:@"StartTime"]);
    IgnoreNullAssign(self.repeatTimes, [info objectForKey:@"RepeatTimes"]);
    IgnoreNullAssign(self.lastPlayTime, [info objectForKey:@"LastPlayTime"]);
    IgnoreNullAssign(self.guideID, [info objectForKey:@"GuideID"]);
    IgnoreNullAssign(self.actionName, [info objectForKey:@"Name"]);
}

@end
