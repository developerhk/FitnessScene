//
//  RecipeItem.m
//  fitnessII
//
//  Created by Haley on 15/9/6.
//  Copyright (c) 2015年 samples.hankang. All rights reserved.
//

#import "RecipeItem.h"

@implementation RecipeItem

- (id)initWithListInfo:(NSDictionary *)info{
    self = [super init];
    if (self) {
        [self assingmentWithInfo:info];
    }
    
    return self;
}

+ (RecipeItem *)RWithInfo:(NSDictionary *)info
{
    return [[RecipeItem alloc] initWithListInfo:info];
}

- (void)assingmentWithInfo:(NSDictionary *)info{
    IgnoreNullAssign(self.actionName, [info objectForKey:@"Name"]);
    IgnoreNullAssign(self.thumbName, [info objectForKey:@"ThumbName"]);
    IgnoreNullAssign(self.picName, [info objectForKey:@"PicName"]);
    IgnoreNullAssign(self.repeatTimes, [info objectForKey:@"RepeatTimes"]);
    IgnoreNullAssign(self.waitTime, [info objectForKey:@"WaitTime"]);
    IgnoreNullAssign(self.actionType, [info objectForKey:@"ActionType"]);
    IgnoreNullAssign(self.difficult, [info objectForKey:@"Difficulty"]);
    IgnoreNullAssign(self.pertinence, [info objectForKey:@"Pertinence"]);
   
    IgnoreNullAssign(self.actionTitle, [info objectForKey:@"ActionTitle"]);
    IgnoreNullAssign(self.actionContent, [info objectForKey:@"ActionContent"]);
    
    IgnoreNullAssign(self.groupNum, [info objectForKey:@"Group"]);
    IgnoreNullAssign(self.audioName, [info objectForKey:@"AudioName"]);
    
    IgnoreNullAssign(self.videoName, [info objectForKey:@"VideoName"]);
    IgnoreNullAssign(self.guideID, [info objectForKey:@"GuideID"]);
    IgnoreNullAssign(self.actionID, [info objectForKey:@"ActionID"]);
    IgnoreNullAssign(self.seq, [info objectForKey:@"SEQ"]);
    
    IgnoreNullAssign(self.thumbUrl, [info objectForKey:@"ThumbUrl"]);
}

@end
