//
//  MemberScoreModel.m
//  fitnessII
//
//  Created by Haley on 15/7/16.
//  Copyright (c) 2015年 samples.hankang. All rights reserved.
//

#import "MemberScoreModel.h"
#import "MemberProModel.h"

@implementation MemberScoreModel
- (id)initWithListInfo:(NSArray *)info{
    self = [super init];
    if (self) {
        [self assingmentWithInfo:info];
    }
    return self;
}

+ (MemberScoreModel *)MSWithInfo:(NSArray *)info
{
    return [[MemberScoreModel alloc] initWithListInfo:info];
}

- (void)assingmentWithInfo:(NSArray *)info{
    self.dataArray = [self getArrayWithDataArray:info];
}

-(NSArray *)getArrayWithDataArray:(NSArray *)dataArray
{
    NSMutableArray *ar = [[NSMutableArray alloc] initWithCapacity:0];
    [dataArray enumerateObjectsUsingBlock:^(NSDictionary *obj, NSUInteger idx, BOOL *stop) {
        [ar addObject:[MemberProModel MPWithInfo:obj]];
    }];
    return ar;
}@end
