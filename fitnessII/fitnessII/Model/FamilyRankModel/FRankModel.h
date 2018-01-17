//
//  FRankModel.h
//  fitnessII
//
//  Created by Haley on 15/11/20.
//  Copyright (c) 2015年 samples.hankang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FRankModel : NSObject
@property (nonatomic, retain) NSArray *dataArray;

+ (FRankModel *)SZWithInfo:(NSArray *)info;
@end
