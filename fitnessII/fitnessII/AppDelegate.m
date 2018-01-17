//
//  AppDelegate.m
//  fitnessII
//
//  Created by Haley on 15/7/3.
//  Copyright (c) 2015年 samples.hankang. All rights reserved.
//

#import "AppDelegate.h"
#import "SFHFKeychainUtils.h"
#import <ShareSDK/ShareSDK.h>
#import "WXApi.h"
#import <TencentOpenAPI/QQApiInterface.h>
#import <TencentOpenAPI/TencentOAuth.h>
#import "MainViewController.h"
#import "LoginViewController.h"
#import "LoginBackViewController.h"
#import "MBProgressHUD.h"
#import "UIImageView+WebCache.h"
#import "FMUString.h"
#import "ImageManager.h"
#import "APService.h"

@implementation AppDelegate

-(void)shareSDKForThirdParty
{
    //shareSDK注册
    [ShareSDK registerApp:@"8c0dfa8407d0"];
    //短信连接
    [ShareSDK connectSMS];
    //邮件连接
    [ShareSDK connectMail];
    //QQ连接
    [ShareSDK connectQQWithQZoneAppKey:@"1104776488"
                     qqApiInterfaceCls:[QQApiInterface class]
                       tencentOAuthCls:[TencentOAuth class]];
    //qq空间
    [ShareSDK connectQZoneWithAppKey:@"1104776488"
                           appSecret:@"YU4J88hnNbXGV9Gt"
                   qqApiInterfaceCls:[QQApiInterface class]
                     tencentOAuthCls:[TencentOAuth class]];
    //微信好友连接
    [ShareSDK connectWeChatSessionWithAppId:WXAPPID
                                  appSecret:WXAPPSECRET
                                  wechatCls:[WXApi class]];
    //微信朋友圈
    [ShareSDK connectWeChatTimelineWithAppId:WXAPPID
                                   appSecret:WXAPPSECRET
                                   wechatCls:[WXApi class]];

}


//配合keyshain 设备唯一
// http://blog.csdn.net/woruosuifenglang/article/details/50598500
-(NSString *)getUUID
{
    CFUUIDRef puuid = CFUUIDCreate(nil);
    CFStringRef uuidString = CFUUIDCreateString( nil, puuid );
    NSString * result = (NSString *)CFBridgingRelease(CFStringCreateCopy( NULL, uuidString));
    CFRelease(puuid);
    CFRelease(uuidString);
    return result;
}

- (void)umengTrack {
    //统计
    [MobClick startWithAppkey:UMENG_KEY reportPolicy:(ReportPolicy)BATCH channelId:nil];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    
//    NSArray *familys = [UIFont familyNames];
//    
//    for (int i = 0; i < [familys count]; i++)
//    {
//        NSString *family = [familys objectAtIndex:i];
//        NSLog(@"=====Fontfamily:%@", family);
//        NSArray *fonts = [UIFont fontNamesForFamilyName:family];
//        for(int j = 0; j < [fonts count]; j++)
//        {
//            NSLog(@"***FontName:%@", [fonts objectAtIndex:j]);
//        }
//    }
    
    [self umengTrack];
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    NSString *isfirst = [[NSUserDefaults standardUserDefaults] objectForKey:FirstLogin];
    if([isfirst intValue] != 1)
    {
        //第一次登陆
        [self initializeFirstIn];
    }
    else
    {
        //loginback
        [self initializeRootViewController];
    }
    
    _setViewController = [[SettingViewController alloc] init];
    RESideMenu *sideMenuViewController = [[RESideMenu alloc] initWithContentViewController:_navgationController
                                                                    leftMenuViewController:_setViewController
                                                                   rightMenuViewController:nil];
    sideMenuViewController.panGestureEnabled = NO;
    sideMenuViewController.backgroundImage = [UIImage imageNamed:@"Stars"];
    sideMenuViewController.menuPreferredStatusBarStyle = 1;
    sideMenuViewController.delegate = self;
    sideMenuViewController.contentViewShadowColor = [UIColor blackColor];
    sideMenuViewController.contentViewShadowOffset = CGSizeMake(0, 0);
    sideMenuViewController.contentViewShadowOpacity = 0.6;
    sideMenuViewController.contentViewShadowRadius = 12;
    sideMenuViewController.contentViewShadowEnabled = YES;
    self.window.rootViewController = sideMenuViewController;
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    
    NSNotificationCenter *defaultCenter = [NSNotificationCenter defaultCenter];
    [defaultCenter addObserver:self selector:@selector(networkDidSetup:) name:kJPFNetworkDidSetupNotification object:nil];
    [defaultCenter addObserver:self selector:@selector(networkDidClose:) name:kJPFNetworkDidCloseNotification object:nil];
    [defaultCenter addObserver:self selector:@selector(networkDidRegister:) name:kJPFNetworkDidRegisterNotification object:nil];
    [defaultCenter addObserver:self selector:@selector(networkDidLogin:) name:kJPFNetworkDidLoginNotification object:nil];
    [defaultCenter addObserver:self selector:@selector(networkDidReceiveMessage:) name:kJPFNetworkDidReceiveMessageNotification object:nil];
    
    //推送功能
    NSDictionary *userInfo = [launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey];
    if (userInfo)
    {
        
    }
    application.applicationIconBadgeNumber = 0;
    [APService registerForRemoteNotificationTypes:(UIUserNotificationTypeBadge |
                                                   UIUserNotificationTypeSound |
                                                   UIUserNotificationTypeAlert)
                                       categories:nil];
    [APService setupWithOption:launchOptions];
    
    //三方分享  暂时停用
//    [self shareSDKForThirdParty];
    
    //关闭屏幕常亮
    [[UIApplication sharedApplication] setIdleTimerDisabled:NO];
    //关闭红外感应
    UIDevice *_curDevice = [UIDevice currentDevice];
    [_curDevice setProximityMonitoringEnabled:NO];

    return YES;
}

-(void)actionShareWithInviteCode:(NSString *)inviteCode type:(NSString *)type
{
    //构造分享内容
    id<ISSContent> publishContent = [ShareSDK content:[NSString stringWithFormat:@"快来安装%@",@"https://itunes.apple.com/cn/app/ti-yu/id1001830454?mt=8"]
                                       defaultContent:@"体育＋"
                                                image:nil
                                                title:[NSString stringWithFormat:@"%@ %@",@"体育＋邀请码",inviteCode]
                                                  url:@"https://itunes.apple.com/cn/app/ti-yu/id1001830454?mt=8"
                                          description:@"“体育＋”分享信息"
                                            mediaType:SSPublishContentMediaTypeNews];
    //创建弹出菜单容器
    id<ISSContainer> container = [ShareSDK container];
    [container setIPadContainerWithView:nil arrowDirect:UIPopoverArrowDirectionUp];
    
    ShareType ttype = -100;
    if([type isEqualToString:@"QQ"])
    {
        ttype = ShareTypeQQ;
    }
    else if ([type isEqualToString:@"QQKJ"])
    {
        ttype = ShareTypeQQSpace;
    }
    else if ([type isEqualToString:@"WX"])
    {
        ttype = ShareTypeWeixiSession;
    }
    else if ([type isEqualToString:@"WXPYQ"])
    {
        ttype = ShareTypeWeixiTimeline;
    }
    else
    {
        ttype = ShareTypeSMS;
    }
    [ShareSDK showShareViewWithType:ttype container:container content:publishContent statusBarTips:YES authOptions:nil shareOptions:nil result:^(ShareType type, SSResponseState state, id<ISSPlatformShareInfo> statusInfo, id<ICMErrorInfo> error, BOOL end) {
        if (state == SSResponseStateSuccess)
        {
            [self displayErrorHUDWithText:@"分享成功!" global:YES];
        }
        else if (state == SSResponseStateFail)
        {
            [self displayErrorHUDWithText:[error errorDescription] global:YES];
        }
        else
        {
            
        }
    }];
}

- (void)displayErrorHUDWithText:(NSString *)error global:(BOOL)global
{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.window
                                              animated:YES];
    // Configure for text only and offset down
    hud.mode = MBProgressHUDModeCustomView;
    //    hud.labelText = error;
    NSString *msg2Show = [NSString stringWithString:error];
    CGSize msgSize = [msg2Show sizeWithFont:[UIFont systemFontOfSize:15.0f]
                          constrainedToSize:CGSizeMake(260.0f, MAXFLOAT)
                              lineBreakMode:LineBreakByWordWrapping];
    
    
    int lines = (int)ceilf(msgSize.height / 19.0f);
    
    UILabel *textLabel = [[UILabel alloc]initWithFrame:CGRectMake(0.0f, 0.0f, msgSize.width, 19.0f * lines)];
    [textLabel setTextAlignment:TextAlignmentCenter];
    [textLabel setLineBreakMode:LineBreakByWordWrapping];
    [textLabel setText:msg2Show];
    [textLabel setFont:[UIFont systemFontOfSize:15.0f]];
    [textLabel setTextColor:[UIColor whiteColor]];
    [textLabel setBackgroundColor:[UIColor clearColor]];
    [textLabel setNumberOfLines:lines];
    hud.customView = textLabel;
    
    hud.margin = 20.f;
    //    hud.yOffset = 0.f;
    hud.removeFromSuperViewOnHide = YES;
    [hud hide:YES afterDelay:2.0f];
}

-(void)initializeFirstIn
{
    LoginViewController *loginViewController = [[LoginViewController alloc] init];
    _navgationController = [[UINavigationController alloc] initWithRootViewController:loginViewController];
    _navgationController.hidesBottomBarWhenPushed = YES;
    _navgationController.navigationBarHidden = YES;
    
    _navgationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName:ColorRGBA(255, 255, 255 ,1),NSFontAttributeName:[UIFont boldSystemFontOfSize:15]};
    
    if (IOS7_OR_LATER) {
        UIImage *image = [[UIImage imageNamed:@"navigationBar_background-7.png"] stretchableImageWithLeftCapWidth:1 topCapHeight:0];
        [_navgationController.navigationBar setBackgroundImage:image forBarMetrics:UIBarMetricsDefault];
    }
    else {
        UIImage *image = [[UIImage imageNamed:@"navigationBar_background-7.png"] stretchableImageWithLeftCapWidth:1 topCapHeight:0];
        [_navgationController.navigationBar setBackgroundImage:image forBarMetrics:UIBarMetricsDefault];
        _navgationController.navigationBar.clipsToBounds = YES;
    }
}

-(void)initializeRootViewController
{
    LoginBackViewController *lViewController = [[LoginBackViewController alloc] init];
    lViewController.isLoginFromBegin = YES;
    _navgationController = [[UINavigationController alloc] initWithRootViewController:lViewController];
    _navgationController.hidesBottomBarWhenPushed = YES;
    
    _navgationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName:ColorRGBA(255, 255, 255 ,1),NSFontAttributeName:[UIFont boldSystemFontOfSize:15]};
    
    if (IOS7_OR_LATER) {
        UIImage *image = [[UIImage imageNamed:@"navigationBar_background-7.png"] stretchableImageWithLeftCapWidth:1 topCapHeight:0];
        [_navgationController.navigationBar setBackgroundImage:image forBarMetrics:UIBarMetricsDefault];
    }
    else {
        UIImage *image = [[UIImage imageNamed:@"navigationBar_background-7.png"] stretchableImageWithLeftCapWidth:1 topCapHeight:0];
        [_navgationController.navigationBar setBackgroundImage:image forBarMetrics:UIBarMetricsDefault];
        _navgationController.navigationBar.clipsToBounds = YES;
    }
}

- (void)sideMenu:(RESideMenu *)sideMenu willShowMenuViewController:(UIViewController *)menuViewController
{
    //展示侧栏
    NSString *gender =[[NSUserDefaults standardUserDefaults] objectForKey:LoginUserGender];
    NSString *headImage =[[NSUserDefaults standardUserDefaults] objectForKey:LoginUserHead];
    NSString *nickName =[[NSUserDefaults standardUserDefaults] objectForKey:LoginUserNickName];
    
    _setViewController.loginName.text = nickName;
    if([FMUString isEmptyString:headImage])
    {
        if([gender isEqualToString:@"M"])
        {
            _setViewController.headImageV.image = [UIImage imageNamed:@"sdad.png"];
        }
        else if ([gender isEqualToString:@"F"])
        {
            _setViewController.headImageV.image = [UIImage imageNamed:@"smom.png"];
        }
        else if ([gender isEqualToString:@"B"])
        {
            _setViewController.headImageV.image = [UIImage imageNamed:@"sboy.png"];
        }
        else
        {
            _setViewController.headImageV.image = [UIImage imageNamed:@"sgirl.png"];
        }
    }
    else
    {

        NSArray *arr = [headImage componentsSeparatedByString:@"/"];
        if([[ImageManager sharedInstance] isExistFileWithFileName:[arr lastObject]])
        {
            //本地图片和网络的图片是一样的  直接显示本地的
            NSString *imageName = [[ImageManager sharedInstance] imagePathWithName:[arr lastObject]];
            _setViewController.headImageV.image = [UIImage imageWithContentsOfFile:imageName];
        }
        else
        {
            //不一致 下载图片 并保存
            [[SDWebImageManager sharedManager] downloadImageWithURL:[NSURL URLWithString:headImage] options:SDWebImageRetryFailed progress:^(NSInteger receivedSize, NSInteger expectedSize) {
                //
            } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
                //
                _setViewController.headImageV.image = image;
                [[ImageManager sharedInstance] saveImageWithName:[arr lastObject] image:image];
            }];
        }
    }
}
							
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (BOOL)application:(UIApplication *)application
      handleOpenURL:(NSURL *)url
{
    return [ShareSDK handleOpenURL:url
                        wxDelegate:self];
}

- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation
{
    return [ShareSDK handleOpenURL:url
                 sourceApplication:sourceApplication
                        annotation:annotation
                        wxDelegate:self];
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error
{
    //如果注册不成功，打印错误信息，可以在网上找到对应的解决方案
    //如果注册成功，可以删掉这个方法
    NSLog(@"application:didFailToRegisterForRemoteNotificationsWithError: %@", error);
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult result))completionHandler
{
    //通过推送打开或正处于app中
    
    // IOS 7 Support Required
    [APService handleRemoteNotification:userInfo];
    completionHandler(UIBackgroundFetchResultNewData);
    
    if (application.applicationState == UIApplicationStateActive)
    {
        application.applicationIconBadgeNumber = 1;
    }
    else
    {
        NSString *type = [userInfo objectForKey:@"type"];
        if([type isEqualToString:@"1"])
        {
            //视频
            [[NSUserDefaults standardUserDefaults] setObject:@"YES" forKey:@"Veido_Notification"];
            [[NSUserDefaults standardUserDefaults] synchronize];
        }
        else if([type isEqualToString:@"2"])
        {
            //时光轴
            [[NSUserDefaults standardUserDefaults] setObject:@"YES" forKey:@"Time_Notification"];
            [[NSUserDefaults standardUserDefaults] synchronize];
        }
        else if([type isEqualToString:@"3"])
        {
            //心理辅导
            [[NSUserDefaults standardUserDefaults] setObject:@"YES" forKey:@"Xinli_Notification"];
            [[NSUserDefaults standardUserDefaults] synchronize];
        }
    }
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    // Required
    [APService registerDeviceToken:deviceToken];
}

#pragma mark - 极光推送
- (void)networkDidSetup:(NSNotification *)notification {
    NSLog(@"\n\n\n已连接...\n\n\n");
}

- (void)networkDidClose:(NSNotification *)notification {
    NSLog(@"\n\n\n未连接...\n\n\n");
}

- (void)networkDidRegister:(NSNotification *)notification {
    NSLog(@"\n\n\n已注册...\n\n\n");
    //注册后在此可拿到单设备推送的RegistrationID
    NSString *registrationID = [APService registrationID];
    NBLog(@"%@",registrationID);
}

- (void)networkDidLogin:(NSNotification *)notification {
    NSLog(@"\n\n\n已登录...\n\n\n");
    //登录可以调用专门的API获取RegistrationID
    NSString *registrationID = [APService registrationID];
    NBLog(@"%@",registrationID);
}

-(void)requestForUploadRegistrationID:(NSString *)registrationID
{
    NSString *userId = [[NSUserDefaults standardUserDefaults] objectForKey:USERID];
    if(userId && userId.length > 1)
    {
        HttpInvokeItem *dataItem = [[HttpInvokeItem alloc] init];
        if ([self respondsToSelector:@selector(uploadRegistrationIDSuccess:)] && [self respondsToSelector:@selector(uploadRegistrationIDFailure:)])
        {
            [dataItem TargetSuper:self Success:@selector(uploadRegistrationIDSuccess:) Failure:@selector(uploadRegistrationIDFailure:)];
        }
        dataItem.dataEncodingType = MKNKPostDataEncodingTypeJSON;
        NSString *path = [NSString stringWithFormat:@"%@?userID=%@&registrationID=%@", Request_UpdateUserRegistrationID,userId,registrationID];
        
        [[HttpInvokeEngine shareHttpInvoke] InvokeHttpMethod:path withParams:nil addFile:nil withMethod:@"GET" InvokeItem:dataItem];
    }
}

- (void)uploadRegistrationIDSuccess:(id)response
{

}

- (void)uploadRegistrationIDFailure:(id)response
{

}

- (void)networkDidReceiveMessage:(NSNotification *)notification {
    
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
        application.applicationIconBadgeNumber = 0;
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
        application.applicationIconBadgeNumber = 0;
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application
{

}

@end
