//
//  TimeZoneModel.h
//  fitnessII
//
//  Created by Haley on 15/7/16.
//  Copyright (c) 2015年 samples.hankang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TimeZoneModel : NSObject
@property (nonatomic, retain) NSArray *dataArray;

+ (TimeZoneModel *)TZWithInfo:(NSArray *)info;
@end
