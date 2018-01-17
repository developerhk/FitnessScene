//
//  MemberProModel.m
//  fitnessII
//
//  Created by Haley on 15/7/7.
//  Copyright (c) 2015年 samples.hankang. All rights reserved.
//

#import "MemberProModel.h"

@implementation MemberProModel

- (id)initWithListInfo:(NSDictionary *)info{
    self = [super init];
    if (self) {
        [self assingmentWithInfo:info];
    }
    
    return self;
}

+ (MemberProModel *)MPWithInfo:(NSDictionary *)info
{
    return [[MemberProModel alloc] initWithListInfo:info];
}

- (void)assingmentWithInfo:(NSDictionary *)info{
    IgnoreNullAssign(self.programID, [info objectForKey:@"ProgramID"]);
    IgnoreNullAssign(self.programName, [info objectForKey:@"ProgramName"]);
    IgnoreNullAssign(self.method, [info objectForKey:@"Method"]);
    IgnoreNullAssign(self.lastScore, [info objectForKey:@"LastScore"]);
}

@end
