//
//  CounselModel.h
//  fitnessII
//
//  Created by Haley on 16/4/8.
//  Copyright © 2016年 samples.hankang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CounselModel : NSObject

@property (nonatomic, retain) NSString *videoCount;
@property (nonatomic, retain) NSString *picName;
@property (nonatomic, retain) NSString *topicName;
@property (nonatomic, retain) NSString *videoContent;

@property (nonatomic, retain) NSArray *dataArray;

+ (CounselModel *)CMWithInfo:(NSDictionary *)info;
@end
