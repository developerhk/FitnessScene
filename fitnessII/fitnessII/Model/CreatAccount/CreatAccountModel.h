//
//  CreatAccountModel.h
//  fitnessII
//
//  Created by Haley on 15/7/7.
//  Copyright (c) 2015年 samples.hankang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CreatAccountModel : NSObject
@property (nonatomic, retain) NSString *userID;      //登陆人ID
@property (nonatomic, retain) NSString *userGender;  //登陆人性别

+ (CreatAccountModel *)CAWithInfo:(NSDictionary *)info;
@end
