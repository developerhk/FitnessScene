//
//  TimeZoneModel.m
//  fitnessII
//
//  Created by Haley on 15/7/16.
//  Copyright (c) 2015年 samples.hankang. All rights reserved.
//

#import "TimeZoneModel.h"
#import "TimeShaftModel.h"

@implementation TimeZoneModel
- (id)initWithListInfo:(NSArray *)info{
    self = [super init];
    if (self) {
        [self assingmentWithInfo:info];
    }
    return self;
}

+ (TimeZoneModel *)TZWithInfo:(NSArray *)info
{
    return [[TimeZoneModel alloc] initWithListInfo:info];
}

- (void)assingmentWithInfo:(NSArray *)info{
    self.dataArray = [self getArrayWithDataArray:info];
}

-(NSArray *)getArrayWithDataArray:(NSArray *)dataArray
{
    if(dataArray && [dataArray count] > 0)
    {
        NSMutableArray *ar = [[NSMutableArray alloc] initWithCapacity:0];
        [dataArray enumerateObjectsUsingBlock:^(NSDictionary *obj, NSUInteger idx, BOOL *stop) {
            [ar addObject:[TimeShaftModel TSWithInfo:obj]];
        }];
        return ar;
    }
    return nil;
}
@end
