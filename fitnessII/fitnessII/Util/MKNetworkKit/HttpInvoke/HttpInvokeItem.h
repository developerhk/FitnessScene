//
//  HttpInvokeItem.h
//  IXinjiekou
//
//  Created by wkx on 13-2-14.
//  Copyright (c) 2013年 wkx. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MKNetworkOperation.h"
/*!
 @discussion
 *	HTTPCachePolicy. Default is UseDefaultCache 所读数据不使用缓存;
 */
typedef enum{
    NotUseDefaultCache = 0,
    UseDefaultCache
}HTTPCachePolicy;


@interface HttpInvokeItem : NSObject
@property (nonatomic, assign) NSObject *targetSuper;
@property (nonatomic, assign) SEL actionSuccess;
@property (nonatomic, assign) SEL actionFailure;
@property (nonatomic, assign) HTTPCachePolicy cachePolicy;
@property (nonatomic, assign) BOOL isShowHud;
@property (nonatomic, strong) NSString *tip;
@property (nonatomic, assign) MKNKPostDataEncodingType dataEncodingType;

- (void)TargetSuper:(NSObject *)superObject Success:(SEL)success Failure:(SEL)failure;
@end
