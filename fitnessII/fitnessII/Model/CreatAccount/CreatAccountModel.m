//
//  CreatAccountModel.m
//  fitnessII
//
//  Created by Haley on 15/7/7.
//  Copyright (c) 2015年 samples.hankang. All rights reserved.
//

#import "CreatAccountModel.h"

@implementation CreatAccountModel

- (id)initWithListInfo:(NSDictionary *)info{
    self = [super init];
    if (self) {
        [self assingmentWithInfo:info];
    }
    
    return self;
}

+ (CreatAccountModel *)CAWithInfo:(NSDictionary *)info
{
    return [[CreatAccountModel alloc] initWithListInfo:info];
}

- (void)assingmentWithInfo:(NSDictionary *)info{
    IgnoreNullAssign(self.userID, [info objectForKey:@"UserID"]);
    IgnoreNullAssign(self.userGender, [info objectForKey:@"UserGender"]);
}

@end
