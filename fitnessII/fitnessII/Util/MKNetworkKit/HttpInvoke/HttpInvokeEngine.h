//
//  HttpInvokeEngine.h
//  IXinjiekou
//
//  Created by wkx on 13-2-18.
//  Copyright (c) 2013年 wkx. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MKNetworkEngine.h"
#import "HttpInvokeItem.h"
#import "MBProgressHUD.h"
#import "Reachability.h"

extern NSString * const NotificationDownloadDidReceiveData;

@interface HttpInvokeEngine : MKNetworkEngine
{
    MBProgressHUD *_hud;
}
@property (readwrite, nonatomic, strong) NSRecursiveLock *lock;
@property(nonatomic,strong)NSDictionary *headerDic;

+ (HttpInvokeEngine *)shareHttpInvoke;

- (NetworkStatus)curNetworkStatus;


- (id)initWithHost:(NSString *)hostName;

/*!
 *  @abstract Creates a simple HttpInvoke
 *
 *  @discussion
 *	Creates a HttpInvoke.
 *  ApiURL
 *  Params
 *  Method
 *  Item
 */

- (BOOL)InvokeHttpMethod:(NSString *)Path withMethod:(NSString *)Method InvokeItem:(HttpInvokeItem *)Item downloadFatAssFileFrom:(NSString*) remoteURL toFile:(NSString*) filePath;

- (BOOL)InvokeHttpMethod:(NSString *)Path withParams:(NSDictionary *)Params addFile:(NSDictionary *)fileParams withMethod:(NSString *)Method InvokeItem:(HttpInvokeItem *)Item;

- (BOOL)InvokeHttpMethod:(NSString *)Path withParams:(NSString *)Params withMethod:(NSString *)Method InvokeItem:(HttpInvokeItem *)Item;

@end
