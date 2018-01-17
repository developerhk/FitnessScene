//
//  TimeShaftModel.m
//  fitnessII
//
//  Created by Haley on 15/7/7.
//  Copyright (c) 2015年 samples.hankang. All rights reserved.
//

#import "TimeShaftModel.h"

@implementation TimeShaftModel
- (id)initWithListInfo:(NSDictionary *)info{
    self = [super init];
    if (self) {
        [self assingmentWithInfo:info];
    }
    
    return self;
}

+ (TimeShaftModel *)TSWithInfo:(NSDictionary *)info
{
    return [[TimeShaftModel alloc] initWithListInfo:info];
}

- (void)assingmentWithInfo:(NSDictionary *)info{
    IgnoreNullAssign(self.userID, [info objectForKey:@"UserID"]);
    IgnoreNullAssign(self.userName, [info objectForKey:@"NickName"]);
    IgnoreNullAssign(self.headPortrait, [info objectForKey:@"HeadPortrait"]);
    IgnoreNullAssign(self.gender, [info objectForKey:@"Gender"]);
    IgnoreNullAssign(self.playTime, [info objectForKey:@"PlayTime"]);
    IgnoreNullAssign(self.content, [info objectForKey:@"Content"]);
    
    IgnoreNullAssign(self.activityPicSize, [info objectForKey:@"ActivityPicSize"]);
    self.activityPicSizeArray = [self getPicSizeArray];
    IgnoreNullAssign(self.activityPicUrl, [info objectForKey:@"ActivityPicUrl"]);
    self.picArray = [self getPicArray];
    IgnoreNullAssign(self.activityPicThumbnailUrl, [info objectForKey:@"ActivityPicThumbnailUrl"]);
    self.activityPicThumbnailArray = [self getThumbnailPicArray];
    
    IgnoreNullAssign(self.activityVidSize, [info objectForKey:@"ActivityVidSize"]);
    self.activityVidSizeArray = [self getVideoSizeArray];
    IgnoreNullAssign(self.activityVIDeoUrl, [info objectForKey:@"ActivityVideoUrl"]);
    self.videoArray = [self getVideoArray];
    IgnoreNullAssign(self.activityVidThumbnailUrl, [info objectForKey:@"ActivityVidThumbnailUrl"]);
    self.activityVidThumbnailArray = [self getThumbnailVideoArray];
    
    IgnoreNullAssign(self.isNew, [info objectForKey:@"IsNew"]);
}

-(NSArray *)getPicSizeArray
{
    if(self.activityPicSize && self.activityPicSize.length > 0)
    {
        NSArray *array = [self.activityPicSize componentsSeparatedByString:@","];
        return array;
    }
    return nil;
}

-(NSArray *)getPicArray
{
    if(self.activityPicUrl && self.activityPicUrl.length > 0)
    {
        NSArray *array = [self.activityPicUrl componentsSeparatedByString:@","];
        return array;
    }
    return nil;
}

-(NSArray *)getThumbnailPicArray
{
    if(self.activityPicThumbnailUrl && self.activityPicThumbnailUrl.length > 0)
    {
        NSArray *array = [self.activityPicThumbnailUrl componentsSeparatedByString:@","];
        return array;
    }
    return nil;
}

-(NSArray *)getVideoSizeArray
{
    if(self.activityVidSize && self.activityVidSize.length > 0)
    {
        NSArray *array = [self.activityVidSize componentsSeparatedByString:@","];
        return array;
    }
    return nil;
}

-(NSArray *)getVideoArray
{
    if(self.activityVIDeoUrl && self.activityVIDeoUrl.length > 0)
    {
        NSArray *array = [self.activityVIDeoUrl componentsSeparatedByString:@","];
        return array;
    }
    return nil;
}

-(NSArray *)getThumbnailVideoArray
{
    if(self.activityVidThumbnailUrl && self.activityVidThumbnailUrl.length > 0)
    {
        NSArray *array = [self.activityVidThumbnailUrl componentsSeparatedByString:@","];
        return array;
    }
    return nil;
}

@end
