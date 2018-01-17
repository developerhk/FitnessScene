//
//  SettingViewController.m
//  fitnessII
//
//  Created by Haley on 15/7/6.
//  Copyright (c) 2015年 samples.hankang. All rights reserved.
//

#import "SettingViewController.h"
#import "AppDelegate.h"
#import "IntegralViewController.h"
#import "AboutUsViewController.h"
#import "FamilyMeberViewController.h"
#import "QuitViewController.h"
#import "LoginBackViewController.h"
#import "FileManager.h"
#import "AddNewViewController.h"
#import "MemberInfoViewController.h"

@interface SettingViewController ()<MemberInfoDelegate>

@end

@implementation SettingViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    
}

-(IBAction)actionSetHeader:(id)sender
{
    if(![self isInternetConnection])
    {
        [self displayErrorHUDWithTextOnWindow:@"网络异常,请稍后再试"];
        return;
    }
    
    //事件统计 点击更换家长头像
    [MobClick event:Menu_OpenParentPortraitPage];
    
    AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    //上传头像
    MemberInfoViewController *memberController = [[MemberInfoViewController alloc] initWithNothing];
    memberController.delegate = self;
    [self.sideMenuViewController setContentViewController:[delegate.navgationController initWithRootViewController:memberController] animated:YES];
    [self.sideMenuViewController hideMenuViewController];
}

-(void)uploadHeadImageToDetailViewWithHeadImageURL:(NSString *)url
{
    
}

-(IBAction)actionPressLeftButton:(UIButton *)but
{
    AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    
    switch (but.tag) {
        case 0:
        {
            if(![self isInternetConnection])
            {
                [self displayErrorHUDWithTextOnWindow:@"网络异常,请稍后再试"];
                return;
            }
            //事件统计 点击家庭积分
            [MobClick event:Menu_OpenFamilyPointPage];
            
            IntegralViewController *controller = [[IntegralViewController alloc]init];
            [self.sideMenuViewController setContentViewController:[delegate.navgationController initWithRootViewController:controller] animated:YES];

        }
            break;
        case 1:
        {
            if(![self isInternetConnection])
            {
                [self displayErrorHUDWithTextOnWindow:@"网络异常,请稍后再试"];
                return;
            }
            //事件统计 点击添加新成员
            [MobClick event:Menu_OpenAddFamilyMemberPage];
            
            AddNewViewController *controller = [[AddNewViewController alloc] init];
            [self.sideMenuViewController setContentViewController:[delegate.navgationController initWithRootViewController:controller] animated:YES];
        }
            break;
        case 2:
        {
            if(![self isInternetConnection])
            {
                [self displayErrorHUDWithTextOnWindow:@"网络异常,请稍后再试"];
                return;
            }
            //事件统计 关于体育+
            [MobClick event:Menu_OpenAboutPage];
            
            AboutUsViewController *controller = [[AboutUsViewController alloc]init];
            [self.sideMenuViewController setContentViewController:[delegate.navgationController initWithRootViewController:controller] animated:YES];
        }
            break;
        case 3:
        {
            //事件统计 清除缓存
            [MobClick event:Menu_ClickClearCache];
            
            [[FileManager sharedInstance] removeALLFile];
            [self displayErrorHUDWithText:@"清除成功"];
            return;
        }
            break;
        case 4:
        {
            //事件统计 退出
            [MobClick event:Menu_ClickLogout];
            
            [[NSUserDefaults standardUserDefaults] removeObjectForKey:MobleNumber];
            [[NSUserDefaults standardUserDefaults] removeObjectForKey:MoblePassword];
            [[NSUserDefaults standardUserDefaults] synchronize];
            LoginBackViewController *controller = [[LoginBackViewController alloc]init];
            controller.isLoginFromMain = YES;
            [self.sideMenuViewController setContentViewController:[delegate.navgationController initWithRootViewController:controller] animated:YES];
        }
            break;
        default:
            break;
    }
    [self.sideMenuViewController hideMenuViewController];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
