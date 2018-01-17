//
//  HttpInvokeItem.m
//  IXinjiekou
//
//  Created by wkx on 13-2-14.
//  Copyright (c) 2013年 wkx. All rights reserved.
//

#import "HttpInvokeItem.h"


@implementation HttpInvokeItem
- (id)init
{
    if (self=[super init]) {
        self.targetSuper = nil;
        self.actionSuccess = nil;
        self.actionFailure = nil;
        self.cachePolicy = NotUseDefaultCache;
        self.isShowHud = NO;
        self.tip = @"";
        self.dataEncodingType = MKNKPostDataEncodingTypeURL;
    }
    return self;
}

- (void)TargetSuper:(NSObject *)superObject Success:(SEL)success Failure:(SEL)failure
{
    self.targetSuper = superObject;
    self.actionSuccess = success;
    self.actionFailure = failure;
}
@end
