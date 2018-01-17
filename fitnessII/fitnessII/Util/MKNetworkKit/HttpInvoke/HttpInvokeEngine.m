//
//  HttpInvokeEngine.m
//  IXinjiekou
//
//  Created by wkx on 13-2-18.
//  Copyright (c) 2013年 wkx. All rights reserved.
//

#import "HttpInvokeEngine.h"
#import "NetWorkInvalid.h"

NSString * const NotificationDownloadDidReceiveData  = @"notification.downloading.operation.start";

static HttpInvokeEngine *_shareHttpInvokeEngine    = nil;


@implementation HttpInvokeEngine

+ (HttpInvokeEngine *)shareHttpInvoke
{
    if (_shareHttpInvokeEngine == nil) {
        @synchronized(self) {
            if (_shareHttpInvokeEngine == nil) {
                _shareHttpInvokeEngine = [[self alloc] initWithHost:HostName];
                [_shareHttpInvokeEngine useCache];
            }
        }
    }
    return _shareHttpInvokeEngine;
}

- (id)initWithHost:(NSString *)hostName
{
    if (self=[self initWithHostName:hostName]) {
        _hud = [[MBProgressHUD alloc] init];
 
        
    }
    return self;
}

- (void)prepareHeaders:(MKNetworkOperation *)operation
{
    //[operation setStringEncoding:NSUTF8StringEncoding];
    [operation addHeaders:_headerDic];
}

- (NetworkStatus)curNetworkStatus
{
    NetworkStatus netStatus = [[Reachability reachabilityForInternetConnection] currentReachabilityStatus];
    return netStatus;
}

- (BOOL)InvokeHttpMethod:(NSString *)Path withParams:(NSDictionary *)Params addFile:(NSDictionary *)fileParams withMethod:(NSString *)Method InvokeItem:(HttpInvokeItem *)Item
{
    NetworkStatus netStatus = [[Reachability reachabilityForInternetConnection] currentReachabilityStatus];
    if (netStatus==NotReachable && Item.cachePolicy==NotUseDefaultCache) {
        [[NetWorkInvalid shareNetWorkInvalid] showNetWorkInvalid];
        return NO;;
    }

    MKNetworkOperation *op = [self operationWithPath:Path
                                              params:Params
                                          httpMethod:Method];
   
    if (Item.cachePolicy == NotUseDefaultCache) {
        [op setShouldNotCacheResponse:YES];
    }
    if ([Method isEqualToString:@"POST"])
    {
        if (fileParams.count > 0)
        {
            for (NSString *key in fileParams)
            {
                id object = [fileParams objectForKey:key];
                if ([object isKindOfClass:[NSString class]])
                {
                    [op addFile:object forKey:key];
                }
                else if([object isKindOfClass:[NSData class]])
                {
                    [op addData:object forKey:key];
                }
            }
        }
    }
    op.postDataEncoding = Item.dataEncodingType;
    [op addCompletionHandler:^(MKNetworkOperation *completedOperation)
     {
         // the completionBlock will be called twice. usecache;
         // if you are interested only in new values, move that code within the else block
         if (Item.isShowHud) {
             [_hud hide:YES];
             [_hud removeFromSuperview];
            
         }
         if (Item.cachePolicy == UseDefaultCache)
         {
             if (completedOperation.isCachedResponse) {
                 if (Item.targetSuper && [Item.targetSuper respondsToSelector:Item.actionSuccess])
                 {
                     [Item.targetSuper performSelectorOnMainThread:Item.actionSuccess withObject:[completedOperation responseJSON] waitUntilDone:YES];
                 };
             }
             else
             {
                 if (Item.targetSuper && [Item.targetSuper respondsToSelector:Item.actionSuccess])
                 {
                     [Item.targetSuper performSelectorOnMainThread:Item.actionSuccess withObject:[completedOperation responseJSON] waitUntilDone:YES];
                 };
             }
         }
         else
         {
             if (Item.targetSuper && [Item.targetSuper respondsToSelector:Item.actionSuccess])
             {
                 [Item.targetSuper performSelectorOnMainThread:Item.actionSuccess withObject:[completedOperation responseJSON] waitUntilDone:YES];
             };
         }
         
     }errorHandler:^(MKNetworkOperation *errorOp, NSError* error) {
         if (Item.isShowHud) {
             [_hud hide:YES];
             [_hud removeFromSuperview];
         }
         if (Item.targetSuper && [Item.targetSuper respondsToSelector:Item.actionFailure])
         {
             [Item.targetSuper performSelectorOnMainThread:Item.actionFailure withObject:[errorOp responseJSON] waitUntilDone:YES];
         };
     }];

    [self enqueueOperation:op];

    NSLog(@"url : %@",op.url);
    NSLog(@"item : %@",Item);
    return YES;
}

- (BOOL)InvokeHttpMethod:(NSString *)Path withParams:(NSString *)Params withMethod:(NSString *)Method InvokeItem:(HttpInvokeItem *)Item
{
    NetworkStatus netStatus = [[Reachability reachabilityForInternetConnection] currentReachabilityStatus];
    if (netStatus==NotReachable && Item.cachePolicy==NotUseDefaultCache) {
        [[NetWorkInvalid shareNetWorkInvalid] showNetWorkInvalid];
        return NO;;
    }

    MKNetworkOperation *op = [self operationWithPath:Path
                                              params:nil
                                          httpMethod:Method];
    
    if (Item.cachePolicy == NotUseDefaultCache) {
        [op setShouldNotCacheResponse:YES];
    }
    op.postDataEncoding = Item.dataEncodingType;
    [op setCustomPostDataEncodingHandler:^NSString *(NSDictionary *postDataDict){
        return Params;
    } forType:@"application/json"];
    [op addCompletionHandler:^(MKNetworkOperation *completedOperation)
     {
         // the completionBlock will be called twice. usecache;
         // if you are interested only in new values, move that code within the else block
         if (Item.isShowHud) {
             [_hud hide:YES];
             [_hud removeFromSuperview];

         }
         if (Item.cachePolicy == UseDefaultCache)
         {
             if (completedOperation.isCachedResponse) {
                 if (Item.targetSuper && [Item.targetSuper respondsToSelector:Item.actionSuccess])
                 {
                     [Item.targetSuper performSelectorOnMainThread:Item.actionSuccess withObject:[completedOperation responseJSON] waitUntilDone:YES];
                 };
             }
             else
             {
                 if (Item.targetSuper && [Item.targetSuper respondsToSelector:Item.actionSuccess])
                 {
                     [Item.targetSuper performSelectorOnMainThread:Item.actionSuccess withObject:[completedOperation responseJSON] waitUntilDone:YES];
                 };
             }
         }
         else
         {
             if (Item.targetSuper && [Item.targetSuper respondsToSelector:Item.actionSuccess])
             {
                 [Item.targetSuper performSelectorOnMainThread:Item.actionSuccess withObject:[completedOperation responseJSON] waitUntilDone:YES];
             };
         }
         
         
     }errorHandler:^(MKNetworkOperation *errorOp, NSError* error) {
         if (Item.isShowHud) {
             [_hud hide:YES];
             [_hud removeFromSuperview];
         }
         if (Item.targetSuper && [Item.targetSuper respondsToSelector:Item.actionFailure])
         {
             [Item.targetSuper performSelectorOnMainThread:Item.actionFailure withObject:[errorOp responseJSON] waitUntilDone:YES];
         };
     }];
    
    [self enqueueOperation:op];
    
    NSLog(@"url : %@",op.url);
    NSLog(@"item : %@",Item);
    return YES;
}


- (BOOL)InvokeHttpMethod:(NSString *)Path withMethod:(NSString *)Method InvokeItem:(HttpInvokeItem *)Item downloadFatAssFileFrom:(NSString*)remoteURL toFile:(NSString*) filePath;
{
    NetworkStatus netStatus = [[Reachability reachabilityForInternetConnection] currentReachabilityStatus];
    if (netStatus==NotReachable && Item.cachePolicy==NotUseDefaultCache) {
        [[NetWorkInvalid shareNetWorkInvalid] showNetWorkInvalid];
        return NO;;
    }

    MKNetworkOperation *op = [self operationWithURLString:Path
                                                     params:nil
                                                 httpMethod:@"GET"];
    
    if (Item.cachePolicy == NotUseDefaultCache) {
        [op setShouldNotCacheResponse:YES];
    }
    
    [op addDownloadStream:[NSOutputStream outputStreamToFileAtPath:filePath
                                                            append:YES]];
    
    [op onDownloadProgressChanged:^(double progress) {
        //下载进度
        NSString *str = [NSString stringWithFormat:@"%f",progress];
        NSDictionary *dataInfo = [NSDictionary dictionaryWithObjectsAndKeys:str,@"progress",nil];
        [[NSNotificationCenter defaultCenter] postNotificationName:NotificationDownloadDidReceiveData
                                                            object:self
                                                          userInfo:dataInfo];
    }];
    
    [op addCompletionHandler:^(MKNetworkOperation *completedOperation)
     {
         if (Item.cachePolicy == UseDefaultCache)
         {
             if (completedOperation.isCachedResponse) {
                 if (Item.targetSuper && [Item.targetSuper respondsToSelector:Item.actionSuccess])
                 {
                     [Item.targetSuper performSelectorOnMainThread:Item.actionSuccess withObject:[completedOperation responseJSON] waitUntilDone:YES];
                 };
             }
             else
             {
                 if (Item.targetSuper && [Item.targetSuper respondsToSelector:Item.actionSuccess])
                 {
                     [Item.targetSuper performSelectorOnMainThread:Item.actionSuccess withObject:[completedOperation responseJSON] waitUntilDone:YES];
                 };
             }
         }
         else
         {
             if (Item.targetSuper && [Item.targetSuper respondsToSelector:Item.actionSuccess])
             {
                 [Item.targetSuper performSelectorOnMainThread:Item.actionSuccess withObject:[completedOperation responseJSON] waitUntilDone:YES];
             };
         }
         
     }errorHandler:^(MKNetworkOperation *errorOp, NSError* error) {
         if (Item.targetSuper && [Item.targetSuper respondsToSelector:Item.actionFailure])
         {
             [Item.targetSuper performSelectorOnMainThread:Item.actionFailure withObject:[errorOp responseJSON] waitUntilDone:YES];
         };
         
     }];
    

    [self enqueueOperation:op];

    return YES;
}

@end
