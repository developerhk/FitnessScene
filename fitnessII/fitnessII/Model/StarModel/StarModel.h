//
//  StarModel.h
//  fitnessII
//
//  Created by Haley on 15/11/5.
//  Copyright (c) 2015年 samples.hankang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface StarModel : NSObject
@property (nonatomic, retain) NSString *episode;       //第几集
@property (nonatomic, retain) NSString *topicName;     //缩标题
@property (nonatomic, retain) NSString *thumbnailUrl;  //缩略图地址
@property (nonatomic, retain) NSString *videoUrl;      //视频地址
@property (nonatomic, retain) NSString *videoSize;     //视频大小，单位kb
@property (nonatomic, retain) NSString *remark;        //描述信息
@property (nonatomic, retain) NSString *videoLock;     //是否上锁

+ (StarModel *)SMWithInfo:(NSDictionary *)info;
@end
