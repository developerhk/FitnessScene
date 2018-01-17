//
//  AppDelegate.h
//  fitnessII
//
//  Created by Haley on 15/7/3.
//  Copyright (c) 2015年 samples.hankang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RESideMenu.h"
#import "SettingViewController.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate,RESideMenuDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (nonatomic, strong) UINavigationController *navgationController;
@property (nonatomic, strong) SettingViewController *setViewController;

-(void)actionShareWithInviteCode:(NSString *)inviteCode type:(NSString *)type;
@end
