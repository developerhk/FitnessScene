//
//  StarModel.m
//  fitnessII
//
//  Created by Haley on 15/11/5.
//  Copyright (c) 2015年 samples.hankang. All rights reserved.
//

#import "StarModel.h"

@implementation StarModel
- (id)initWithListInfo:(NSDictionary *)info{
    self = [super init];
    if (self) {
        [self assingmentWithInfo:info];
    }
    
    return self;
}

+ (StarModel *)SMWithInfo:(NSDictionary *)info
{
    return [[StarModel alloc] initWithListInfo:info];
}

- (void)assingmentWithInfo:(NSDictionary *)info{
    IgnoreNullAssign(self.episode, [info objectForKey:@"Episode"]);
    IgnoreNullAssign(self.topicName, [info objectForKey:@"TopicName"]);
    IgnoreNullAssign(self.thumbnailUrl, [info objectForKey:@"ThumbnailUrl"]);
    IgnoreNullAssign(self.videoUrl, [info objectForKey:@"VideoUrl"]);
    IgnoreNullAssign(self.videoSize, [info objectForKey:@"VideoSize"]);
    IgnoreNullAssign(self.remark, [info objectForKey:@"Remark"]);
    IgnoreNullAssign(self.videoLock, [info objectForKey:@"VideoLock"]);
}
@end
