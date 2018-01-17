//
//  FamilyMembersModel.h
//  fitnessII
//
//  Created by Haley on 15/7/7.
//  Copyright (c) 2015年 samples.hankang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FamilyMembersModel : NSObject

@property (nonatomic, retain) NSString *userID;         //成员ID
@property (nonatomic, retain) NSString *nickName;       //成员姓名
@property (nonatomic, retain) NSString *headPic;        //成员头像
//Gender：性别（B：男孩；G：女孩；F:女士；M：男士）
//RelationCode：关系代码（0：学生；1：爸爸；2：妈妈）
@property (nonatomic, retain) NSString *relationCode;   //成员关系
@property (nonatomic, retain) NSString *gender;         //成员性别
@property (nonatomic, retain) NSString *isLoginUser;    //是否是当前登陆用户

@property (nonatomic, assign) BOOL channelLock;         //时光轴是否上锁
@property (nonatomic, assign) BOOL hasNew;              //时光轴是否有新消息
@property (nonatomic, assign) BOOL evaluationLock;      //体质评测上锁

@property (nonatomic, assign) BOOL videoLock;           //孙教授视频上锁
@property (nonatomic, assign) BOOL coachLock;           //心理辅导上锁

@property (nonatomic, assign) BOOL videoRenew;          //孙教授视频更新
@property (nonatomic, assign) BOOL coachRenew;          //心理辅导更新

+ (FamilyMembersModel *)FMWithInfo:(NSDictionary *)info;
@end
