//
//  MainViewController.h
//  fitnessII
//
//  Created by Haley on 15/7/6.
//  Copyright (c) 2015年 samples.hankang. All rights reserved.
//

#import "RootViewController.h"
#import "FamilyModel.h"

extern NSString * const showMenuNotification;

@interface MainViewController : RootViewController<UIScrollViewDelegate>

@property (nonatomic, strong) IBOutlet UIScrollView *scroller;  //数据的背景

- (id)initWithUserID:(NSString *)userID fromMobileLogin:(BOOL)mobLogin;

@end
