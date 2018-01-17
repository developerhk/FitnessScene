//
//  FamilyModel.h
//  fitnessII
//
//  Created by Haley on 15/7/16.
//  Copyright (c) 2015年 samples.hankang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FamilyModel : NSObject
@property (nonatomic, retain) NSArray *dataArray;

+ (FamilyModel *)FWithInfo:(NSArray *)info;
@end
