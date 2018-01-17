//
//  FamilyModel.m
//  fitnessII
//
//  Created by Haley on 15/7/16.
//  Copyright (c) 2015年 samples.hankang. All rights reserved.
//

#import "FamilyModel.h"
#import "FamilyMembersModel.h"

@implementation FamilyModel
- (id)initWithListInfo:(NSArray *)info{
    self = [super init];
    if (self) {
        [self assingmentWithInfo:info];
    }
    return self;
}

+ (FamilyModel *)FWithInfo:(NSArray *)info
{
    return [[FamilyModel alloc] initWithListInfo:info];
}

- (void)assingmentWithInfo:(NSArray *)info{
    self.dataArray = [self getArrayWithDataArray:info];
}

-(NSArray *)getArrayWithDataArray:(NSArray *)dataArray
{
    NSMutableArray *ar = [[NSMutableArray alloc] initWithCapacity:0];
    [dataArray enumerateObjectsUsingBlock:^(NSDictionary *obj, NSUInteger idx, BOOL *stop) {
        [ar addObject:[FamilyMembersModel FMWithInfo:obj]];
    }];
    return ar;
}
@end
