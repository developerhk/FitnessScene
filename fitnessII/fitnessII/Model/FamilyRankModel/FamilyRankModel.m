//
//  FamilyRankModel.m
//  fitnessII
//
//  Created by Haley on 15/11/20.
//  Copyright (c) 2015年 samples.hankang. All rights reserved.
//

#import "FamilyRankModel.h"

@implementation FamilyRankModel
- (id)initWithListInfo:(NSDictionary *)info{
    self = [super init];
    if (self) {
        [self assingmentWithInfo:info];
    }
    
    return self;
}

+ (FamilyRankModel *)FRWithInfo:(NSDictionary *)info
{
    return [[FamilyRankModel alloc] initWithListInfo:info];
}

- (void)assingmentWithInfo:(NSDictionary *)info{
    IgnoreNullAssign(self.position, [info objectForKey:@"Position"]);
    IgnoreNullAssign(self.wkScores, [info objectForKey:@"WKScores"]);
    self.isSelf = ParseBool([info objectForKey:@"IsSelf"]);
    IgnoreNullAssign(self.studentName, [info objectForKey:@"StudentName"]);
}
@end
