//
//  RecipeModel.h
//  fitnessII
//
//  Created by Haley on 15/9/6.
//  Copyright (c) 2015年 samples.hankang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RecipeItem.h"
#import "RecipeDetailModel.h"

@interface RecipeModel : NSObject
@property (nonatomic, retain) NSString *zipVersion;        //资源包版本
@property (nonatomic, retain) NSString *unzipSize;         //资源包解压后的大小
@property (nonatomic, retain) NSString *zipUrl;            //资源包网络地址
@property (nonatomic, retain) RecipeDetailModel *rdModel;  //运动详情首页
@property (nonatomic, retain) NSArray *dataArray;

+ (RecipeModel *)RIWithInfo:(NSDictionary *)info;
@end
