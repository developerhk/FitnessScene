//
//  StarZoneModel.h
//  fitnessII
//
//  Created by Haley on 15/11/5.
//  Copyright (c) 2015年 samples.hankang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface StarZoneModel : NSObject

@property (nonatomic, retain) NSString *videoCount;

@property (nonatomic, retain) NSString *picName;

@property (nonatomic, retain) NSString *topicName;

@property (nonatomic, retain) NSString *videoContent;

@property (nonatomic, retain) NSArray *dataArray;

+ (StarZoneModel *)SZWithInfo:(NSDictionary *)info;
@end
