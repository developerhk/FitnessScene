//
//  LoginModel.m
//  fitnessII
//
//  Created by Haley on 15/11/19.
//  Copyright (c) 2015年 samples.hankang. All rights reserved.
//

#import "LoginModel.h"

@implementation LoginModel
- (id)initWithListInfo:(NSDictionary *)info{
    self = [super init];
    if (self) {
        [self assingmentWithInfo:info];
    }
    
    return self;
}

+ (LoginModel *)LMWithInfo:(NSDictionary *)info
{
    return [[LoginModel alloc] initWithListInfo:info];
}

- (void)assingmentWithInfo:(NSDictionary *)info{
    IgnoreNullAssign(self.rresult, [info objectForKey:@"Result"]);
    IgnoreNullAssign(self.userID, [info objectForKey:@"UserID"]);
    IgnoreNullAssign(self.childCount, [info objectForKey:@"Count"]);
    IgnoreNullAssign(self.familyID, [info objectForKey:@"FamilyID"]);
    IgnoreNullAssign(self.gender, [info objectForKey:@"Gender"]);
    IgnoreNullAssign(self.headPic, [info objectForKey:@"HeadPortrait"]);
    IgnoreNullAssign(self.mobile, [info objectForKey:@"Mobile"]);
    IgnoreNullAssign(self.nickName, [info objectForKey:@"NickName"]);
    IgnoreNullAssign(self.password, [info objectForKey:@"Password"]);
    IgnoreNullAssign(self.relationCode, [info objectForKey:@"RelationCode"]);
}

@end
