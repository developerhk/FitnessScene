//
//  NetWorkInvalid.h
//  IXinjiekou
//
//  Created by wkx on 13-3-15.
//  Copyright (c) 2013年 wkx. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MBProgressHUD.h"

@interface NetWorkInvalid : NSObject
{
    //UIImageView *_networkUnavailableImageView;
    MBProgressHUD *_hud;
}

+ (NetWorkInvalid*)shareNetWorkInvalid;

- (void)showNetWorkInvalid;
@end
