//
//  CounselModel.m
//  fitnessII
//
//  Created by Haley on 16/4/8.
//  Copyright © 2016年 samples.hankang. All rights reserved.
//

#import "CounselModel.h"
#import "StarModel.h"

@implementation CounselModel

- (id)initWithListInfo:(NSDictionary *)info{
    self = [super init];
    if (self) {
        [self assingmentWithInfo:info];
    }
    return self;
}

+ (CounselModel *)CMWithInfo:(NSDictionary *)info
{
    return [[CounselModel alloc] initWithListInfo:info];
}

- (void)assingmentWithInfo:(NSDictionary *)info{
    IgnoreNullAssign(self.videoCount, [info objectForKey:@"Count"]);
    IgnoreNullAssign(self.picName, [info objectForKey:@"PicName"]);
    IgnoreNullAssign(self.topicName, [info objectForKey:@"TopicName"]);
    IgnoreNullAssign(self.videoContent, [info objectForKey:@"VideoContent"]);

    self.dataArray = [self getArrayWithDataArray:[info objectForKey:@"Data"]];
}

-(NSArray *)getArrayWithDataArray:(NSArray *)dataArray
{
    if(dataArray && [dataArray count] > 0)
    {
        NSMutableArray *ar = [[NSMutableArray alloc] initWithCapacity:0];
        [dataArray enumerateObjectsUsingBlock:^(NSDictionary *obj, NSUInteger idx, BOOL *stop) {
            [ar addObject:[StarModel SMWithInfo:obj]];
        }];
        return ar;
    }
    return nil;
}
@end
