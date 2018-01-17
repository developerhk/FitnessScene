//
//  FamilyMembersModel.m
//  fitnessII
//
//  Created by Haley on 15/7/7.
//  Copyright (c) 2015年 samples.hankang. All rights reserved.
//

#import "FamilyMembersModel.h"

@implementation FamilyMembersModel

- (id)initWithListInfo:(NSDictionary *)info{
    self = [super init];
    if (self) {
        [self assingmentWithInfo:info];
    }
    
    return self;
}

+ (FamilyMembersModel *)FMWithInfo:(NSDictionary *)info
{
    return [[FamilyMembersModel alloc] initWithListInfo:info];
}

- (void)assingmentWithInfo:(NSDictionary *)info{
    IgnoreNullAssign(self.isLoginUser, [info objectForKey:@"IsLoginUser"]);
    IgnoreNullAssign(self.userID, [info objectForKey:@"UserID"]);
    IgnoreNullAssign(self.nickName, [info objectForKey:@"NickName"]);
    IgnoreNullAssign(self.headPic, [info objectForKey:@"HeadPortrait"]);
    IgnoreNullAssign(self.relationCode, [info objectForKey:@"RelationCode"]);
    IgnoreNullAssign(self.gender, [info objectForKey:@"Gender"]);
    self.channelLock = ParseBool([info objectForKey:@"ChannelLock"]);
    self.hasNew = ParseBool([info objectForKey:@"HasNew"]);
    self.evaluationLock = ParseBool([info objectForKey:@"EvaluationLock"]);
    self.videoLock = ParseBool([info objectForKey:@"VideoLock"]);
    self.coachLock = ParseBool([info objectForKey:@"CoachLock"]);
    self.videoRenew = ParseBool([info objectForKey:@"VideoRenew"]);
    self.coachRenew = ParseBool([info objectForKey:@"CoachRenew"]);
}

@end
