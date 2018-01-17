//
//  NetWorkInvalid.m
//  IXinjiekou
//
//  Created by wkx on 13-3-15.
//  Copyright (c) 2013年 wkx. All rights reserved.
//

#import "NetWorkInvalid.h"
#import "AppDelegate.h"
#import "Reachability.h"

static NetWorkInvalid *_shareNetWorkInvalid = nil;

@implementation NetWorkInvalid

+ (NetWorkInvalid*)shareNetWorkInvalid
{
    if (_shareNetWorkInvalid == nil) {
        @synchronized(self) {
            if (_shareNetWorkInvalid == nil) {
                _shareNetWorkInvalid = [[NetWorkInvalid alloc] init];
            }
        }
    }
    return _shareNetWorkInvalid;
}

- (void)showNetWorkInvalid
{
    NetworkStatus netStatus = [[Reachability reachabilityForInternetConnection] currentReachabilityStatus];
    if (netStatus != NotReachable) {
        return;
    }
    AppDelegate* appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    
    if (_hud == nil) {
        _hud = [[MBProgressHUD alloc] init];
    }
    [_hud setMode:MBProgressHUDModeText];
    _hud.labelText = @"网络异常，请稍后再试";
    _hud.labelFont = [UIFont systemFontOfSize:15];
    //[self.view addSubview:hud];
    [appDelegate.window addSubview:_hud];
    [_hud show:YES];
    _hud.margin = 15.f;
    _hud.removeFromSuperViewOnHide = YES;
    //[_hud hide:YES afterDelay:1.0];

//    if (_networkUnavailableImageView == nil) {
//        _networkUnavailableImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, Screen_Width, Screen_Height+20)];
//    }
//    _networkUnavailableImageView.image = [UIImage imageNamed:@"network_unavailable"];
//    _networkUnavailableImageView.center = appDelegate.window.center;
//    _networkUnavailableImageView.contentMode = UIViewContentModeCenter;
//    _networkUnavailableImageView.userInteractionEnabled = YES;
    

    
    [self performSelector:@selector(dismissImageAlertNetworkUnAvailable) withObject:nil afterDelay:1.0];
}

- (void)dismissImageAlertNetworkUnAvailable {
   [UIView animateWithDuration:0.3
                     animations:^ {
                     }
                     completion:^ (BOOL finished) {
                         [[NSNotificationCenter defaultCenter] postNotificationName:@"RemoveAllHudsNotification" object:nil userInfo:nil];
                         [_hud removeFromSuperview];
                     }];
}

@end
