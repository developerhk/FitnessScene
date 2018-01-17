//
//  ImageData.h
//  fitnessII
//
//  Created by Haley on 15/8/7.
//  Copyright (c) 2015年 samples.hankang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ImageData : NSObject
@property (strong, nonatomic) NSString *url;
@property (strong, nonatomic) NSString *createDate;
@property (strong, nonatomic) NSString *mime;
@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSString *type; //1-图片 2-语音 3-视频 4-其他文件
@property (strong, nonatomic) NSString *fileSize;
@end
