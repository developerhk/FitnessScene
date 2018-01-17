//
//  CheckNumModel.m
//  fitnessII
//
//  Created by Haley on 15/7/7.
//  Copyright (c) 2015年 samples.hankang. All rights reserved.
//

#import "CheckNumModel.h"

@implementation CheckNumModel

- (id)initWithListInfo:(NSDictionary *)info{
    self = [super init];
    if (self) {
        [self assingmentWithInfo:info];
    }
    
    return self;
}

+ (CheckNumModel *)CNWithInfo:(NSDictionary *)info
{
    return [[CheckNumModel alloc] initWithListInfo:info];
}

- (void)assingmentWithInfo:(NSDictionary *)info{
    IgnoreNullAssign(self.studentName, [info objectForKey:@"StudentName"]);
    IgnoreNullAssign(self.bindingID, [info objectForKey:@"HasBindingRD"]);
    [self judgeState];
}

-(void)judgeState
{
    NSArray *a = [self.bindingID componentsSeparatedByString:@","];
    [a enumerateObjectsUsingBlock:^(NSString *obj, NSUInteger idx, BOOL *stop) {
        //
        if([obj isEqualToString:@"0"])
        {
            _isChooseChild = YES;
        }
        else if ([obj isEqualToString:@"1"])
        {
            _isChooseFather = YES;
        }
        else if ([obj isEqualToString:@"2"])
        {
            _isChooseMather = YES;
        }
        else
        {
            //nothing
        }
    }];
}

@end
