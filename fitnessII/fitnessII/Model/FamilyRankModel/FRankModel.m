//
//  FRankModel.m
//  fitnessII
//
//  Created by Haley on 15/11/20.
//  Copyright (c) 2015年 samples.hankang. All rights reserved.
//

#import "FRankModel.h"
#import "FamilyRankModel.h"

@implementation FRankModel
- (id)initWithListInfo:(NSArray *)info{
    self = [super init];
    if (self) {
        [self assingmentWithInfo:info];
    }
    return self;
}

+ (FRankModel *)SZWithInfo:(NSArray *)info
{
    return [[FRankModel alloc] initWithListInfo:info];
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
            [ar addObject:[FamilyRankModel FRWithInfo:obj]];
        }];
        return ar;
    }
    return nil;
}
@end
