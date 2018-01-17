//
//  LoginModel.h
//  fitnessII
//
//  Created by Haley on 15/11/19.
//  Copyright (c) 2015年 samples.hankang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LoginModel : NSObject

@property (nonatomic, retain) NSString *rresult;        //结果
@property (nonatomic, retain) NSString *userID;         //登录人ID
@property (nonatomic, retain) NSString *childCount;     //养了几个
@property (nonatomic, retain) NSString *familyID;       //家庭号
@property (nonatomic, retain) NSString *gender;         //登录人性别
@property (nonatomic, retain) NSString *headPic;        //登录人头像
@property (nonatomic, retain) NSString *mobile;         //登录人手机
@property (nonatomic, retain) NSString *nickName;       //登录人昵称
@property (nonatomic, retain) NSString *password;       //登录人密码
//Gender：性别（B：男孩；G：女孩；F:女士；M：男士）
//RelationCode：关系代码（0：学生；1：爸爸；2：妈妈）
@property (nonatomic, retain) NSString *relationCode;   //成员关系

+ (LoginModel *)LMWithInfo:(NSDictionary *)info;

@end
