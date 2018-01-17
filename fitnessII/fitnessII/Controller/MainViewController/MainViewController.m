//
//  MainViewController.m
//  fitnessII
//
//  Created by Haley on 15/7/6.
//  Copyright (c) 2015年 samples.hankang. All rights reserved.
//

#import "MainViewController.h"
#import "RESideMenu.h"
#import "TimeViewController.h"
#import "DetailView.h"
#import "MemberInfoViewController.h"
#import "RedViewController.h"
#import "GreenViewController.h"
#import "YellowViewController.h"
#import "BlueViewController.h"
#import "AppDelegate.h"
#import "FamilyMembersModel.h"
#import "UIImageView+WebCache.h"
#import "UIButton+WebCache.h"
#import "ImageManager.h"
#import "FMUString.h"
#import<CoreText/CoreText.h>
#import "StarPeopleViewController.h"
#import "CounselViewController.h"
#import "APService.h"


NSString * const showMenuNotification = @"showMenuNotification";

@interface MainViewController () <DetailViewDelegate,MemberInfoDelegate>
{
    FamilyModel *_dataModel;
    FamilyMembersModel *_currentModel;
    
    NSMutableArray *_detailViewArray;   //多个小孩 把View放进数组  方便更换头像 找到目标view
    DetailView *_currentDeatilView;     //当前翻过来的View－蜂巢

    NSString *_userID;

    int indexLine;   //记录当前划到第几个小孩 便于返回刷新时还是回到这个小孩上
}
@property (nonatomic, retain) UIImageView *leaderIV;
@end

@implementation MainViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (id)initWithUserID:(NSString *)userID fromMobileLogin:(BOOL)mobLogin
{
    self = [super init];
    if (self) {
        // Custom initialization
        _userID = userID;
    }
    return self;
}

-(void)actionLeft
{
    //事件统计 侧滑汉堡按钮
    [MobClick event:Home_OpenLeftMenu];
    
    [self performSelector:@selector(presentLeftMenuViewController:) withObject:nil afterDelay:0.01];
}

-(void)actionRight
{
    if(![self isInternetConnection])
    {
        [self displayErrorHUDWithTextOnWindow:@"网络异常,请稍后再试"];
        return;
    }
    //事件统计 运动时光按钮
    [MobClick event:Home_OpenSportsTimeChannel];
    TimeViewController *controller = [[TimeViewController alloc] init];
    [self.navigationController pushViewController:controller animated:YES];
}

//Gender：性别（B：男孩；G：女孩；F:女士；M：男士）
-(void)showDetailViewWithModel:(FamilyMembersModel *)model forView:(UIScrollView *)scrol
{
    //小孩
    NSArray *nibContents = [[NSBundle mainBundle] loadNibNamed:@"DView" owner:nil options:nil];
    DetailView *detailView = (DetailView *)[nibContents objectAtIndex:0];
    detailView.frame = CGRectMake(0, 0, detailView.frame.size.width, detailView.frame.size.height);
    detailView.dvDelegate = self;
    [scrol addSubview:detailView];
    
    detailView.starBut.selected = model.videoRenew;
    detailView.xlfdBut.selected = model.coachRenew;
    
    [_detailViewArray addObject:detailView];
    
    UIImageView *headImageUp = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, detailView.headBut.frame.size.width, detailView.headBut.frame.size.height)];
    headImageUp.image = [UIImage imageNamed:@"ULtouxiangbg.png"];
    [detailView.headBut addSubview:headImageUp];
    
    if([FMUString isEmptyString:model.headPic])
    {
        //空url 则默认头像
        if([model.gender isEqualToString:@"B"])
        {
            [detailView.headBut setBackgroundImage:[UIImage imageNamed:@"mainboyp.png"] forState:UIControlStateNormal];
        }
        else
        {
            [detailView.headBut setBackgroundImage:[UIImage imageNamed:@"maingirlp.png"] forState:UIControlStateNormal];
        }
    }
    else
    {
        NSArray *arr = [model.headPic componentsSeparatedByString:@"/"];
        if([[ImageManager sharedInstance] isExistFileWithFileName:[arr lastObject]])
        {
            //本地图片和网络的图片是一样的  直接显示本地的
            NSString *imageName = [[ImageManager sharedInstance] imagePathWithName:[arr lastObject]];
            [detailView.headBut setBackgroundImage:[UIImage imageWithContentsOfFile:imageName] forState:UIControlStateNormal];
        }
        else
        {
            //不一致 下载图片 并保存
            [[SDWebImageManager sharedManager] downloadImageWithURL:[NSURL URLWithString:model.headPic] options:SDWebImageRetryFailed progress:^(NSInteger receivedSize, NSInteger expectedSize) {
                //
            } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
                //
                [detailView.headBut setBackgroundImage:image forState:UIControlStateNormal];

                [[ImageManager sharedInstance] saveImageWithName:[arr lastObject] image:image];
            }];
        }
    }
}

-(void)uploadHeadImageToDetailViewWithHeadImageURL:(NSString *)url
{
    if([FMUString isEmptyString:url])
    {
        if([_currentModel.relationCode isEqualToString:@"0"])
        {
            //小孩
            if([_currentModel.gender isEqualToString:@"B"])
            {
                [_currentDeatilView.headBut sd_setBackgroundImageWithURL:[NSURL URLWithString:url] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"mainboyp.png"]];
            }
            else
            {
                [_currentDeatilView.headBut sd_setBackgroundImageWithURL:[NSURL URLWithString:url] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"maingirlp.png"]];
            }
        }
        else
        {
            if([_currentModel.gender isEqualToString:@"M"])
            {
                [_currentDeatilView.headBut sd_setBackgroundImageWithURL:[NSURL URLWithString:url] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"mmaindad.png"]];
            }
            else
            {
                [_currentDeatilView.headBut sd_setBackgroundImageWithURL:[NSURL URLWithString:url] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"mmainmom.png"]];
            }
        }
    }
    else
    {
        NSArray *arr = [url componentsSeparatedByString:@"/"];
        NSString *imageName = [[ImageManager sharedInstance] imagePathWithName:[arr lastObject]];
        [_currentDeatilView.headBut setBackgroundImage:[UIImage imageWithContentsOfFile:imageName] forState:UIControlStateNormal];
    }
}

#pragma mark - DetailViewDelegate
-(void)actionPressWithButtonAttribute:(int)tag
{
    if(![self isInternetConnection])
    {
        [self displayErrorHUDWithTextOnWindow:@"网络异常,请稍后再试"];
        return;
    }
    
    switch (tag) {
        case 20:
        {
            //事件统计 修改小孩头像按钮
            [MobClick event:Home_OpenChildPortraitPage];
            
            //上传头像
            MemberInfoViewController *memberController = [[MemberInfoViewController alloc] initWithUserModel:_currentModel];
            memberController.delegate = self;
            [self.navigationController pushViewController:memberController animated:NO];
        }
            break;
        case 22:
        {
            //事件统计 家庭排名按钮
            [MobClick event:Home_OpenFamilyRank];
            
            //家庭排名
            RedViewController *redcontroller = [[RedViewController alloc] initWithUserID:_currentModel.userID];
            [self.navigationController pushViewController:redcontroller animated:YES];
        }
            break;
        case 23:
        {
            //事件统计 名家讲坛按钮
            [MobClick event:Home_OpenProfessorCourse];
            //名家讲坛
            StarPeopleViewController *controller = [[StarPeopleViewController alloc] init];
            controller.childID = _currentModel.userID;
            [self.navigationController pushViewController:controller animated:YES];
        }
            break;
        case 24:
        {
            //事件统计 体质评价按钮
            [MobClick event:Home_OpenConstitutionEval];
            
            //体质评价
            GreenViewController *controller = [[GreenViewController alloc] initWithUserID:_currentModel.userID];
            [self.navigationController pushViewController:controller animated:YES];
        }
            break;
        case 25:
        {
            //国标测评
            //事件统计 国际测评按钮
            [MobClick event:Home_OpenNationalOptions];
            
            //身高体重
            YellowViewController *controller = [[YellowViewController alloc] initWithTag:4 userID:_currentModel.userID];
            [self.navigationController pushViewController:controller animated:NO];
        }
            break;
        case 26:
        {
            //自我锻炼
            //事件统计 自我锻炼按钮
            [MobClick event:Home_OpenCustomizeOptions];
            
            //平板支撑
            BlueViewController *controller = [[BlueViewController alloc] initWithTag:11 userID:_currentModel.userID isStudent:YES];
            [self.navigationController pushViewController:controller animated:NO];
        }
            break;
        case 27:
        {
            //事件统计 心理辅导按钮
            [MobClick event:Home_OpenPsychologyCourse];
            //心理辅导
            CounselViewController *controller = [[CounselViewController alloc] initWithUserID:_currentModel.userID];
            [self.navigationController pushViewController:controller animated:YES];
        }
            break;
        default:
            break;
    }
}

-(void)viewWillAppear:(BOOL)animated
{
    //事件统计 心理辅导按钮
    [MobClick event:Menu_GoBackHome];
    
    [self.navigationController setNavigationBarHidden:NO animated:NO];
    [self checkForNewTime];
    [self requestForFamilyMemberWithStudentID:nil];
}

-(void)checkForNewTime
{
    _userID = [[NSUserDefaults standardUserDefaults] objectForKey:USERID];
    HttpInvokeItem *dataItem = [[HttpInvokeItem alloc] init];
    if ([self respondsToSelector:@selector(checkNewTimeSuccess:)] && [self respondsToSelector:@selector(checkNewTimeFailure:)])
    {
        [dataItem TargetSuper:self Success:@selector(checkNewTimeSuccess:) Failure:@selector(checkNewTimeFailure:)];
    }
    dataItem.dataEncodingType = MKNKPostDataEncodingTypeJSON;
    NSString *path = [NSString stringWithFormat:@"%@?userID=%@", Request_CheckNewEvent,_userID];
    
    [[HttpInvokeEngine shareHttpInvoke] InvokeHttpMethod:path withParams:nil addFile:nil withMethod:@"GET" InvokeItem:dataItem];
}

- (void)checkNewTimeSuccess:(id)response
{
    NSLog(@"%@",[response objectForKey:@"Data"]);
    if ([[response objectForKey:@"Result"] intValue] == 1)
    {
        [self setRightButtonImage:[UIImage imageNamed:@"mian_timeZone_new"] target:self selector:@selector(actionRight)];
    }
    else
    {
        [self setRightButtonImage:[UIImage imageNamed:@"mian_timeZone"] target:self selector:@selector(actionRight)];
    }
}

- (void)checkNewTimeFailure:(id)response
{
    [self setRightButtonImage:[UIImage imageNamed:@"mian_timeZone"] target:self selector:@selector(actionRight)];
}

-(void)showMenu
{
    NSString *isADD =  [[NSUserDefaults standardUserDefaults] objectForKey:AddNewBabySuccess];
    if([isADD isEqualToString:@"NO"])
    {
        [self performSelector:@selector(presentLeftMenuViewController:) withObject:nil afterDelay:0.01];
    }
}

-(void)becomeActive:(id)info
{
    [self requestForFamilyMemberWithStudentID:nil];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.

    [self setNavTitleWithKaiti:@"体育⁺"];
    [self setLeftButtonTitle:nil image:[UIImage imageNamed:@"mainmore.png"] target:self selector:@selector(actionLeft)];
    [self setRightButtonImage:[UIImage imageNamed:@"mian_timeZone"] target:self selector:@selector(actionRight)];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(becomeActive:) name:UIApplicationDidBecomeActiveNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showMenu) name:showMenuNotification object:nil];

    _detailViewArray = [[NSMutableArray alloc] initWithCapacity:0];
    
    _scroller.scrollEnabled = YES;
    _scroller.pagingEnabled = YES;
    _scroller.bounces = NO;
    _scroller.showsHorizontalScrollIndicator = NO;
    _scroller.showsVerticalScrollIndicator = NO;
    
    indexLine = 1;

}

#pragma mark - HttpRequest
-(void)requestForFamilyMemberWithStudentID:(NSString *)childUserID
{
    _userID = [[NSUserDefaults standardUserDefaults] objectForKey:USERID];
    
    [self showLoadingHUD];
    HttpInvokeItem *dataItem = [[HttpInvokeItem alloc] init];
    if ([self respondsToSelector:@selector(getFamilySuccess:)] && [self respondsToSelector:@selector(getFamilyFailure:)])
    {
        [dataItem TargetSuper:self Success:@selector(getFamilySuccess:) Failure:@selector(getFamilyFailure:)];
    }
    dataItem.dataEncodingType = MKNKPostDataEncodingTypeJSON;
    
    if([APService registrationID] && [[APService registrationID] length] > 0)
    {
        NSString *path = [NSString stringWithFormat:@"%@?userID=%@&registrationID=%@", Request_GetFamilyMembers,_userID,[APService registrationID]];
        [[HttpInvokeEngine shareHttpInvoke] InvokeHttpMethod:path withParams:nil addFile:nil withMethod:@"GET" InvokeItem:dataItem];
    }
    else
    {
        NSString *path = [NSString stringWithFormat:@"%@?userID=%@", Request_GetFamilyMembers,_userID];
        [[HttpInvokeEngine shareHttpInvoke] InvokeHttpMethod:path withParams:nil addFile:nil withMethod:@"GET" InvokeItem:dataItem];
    }
}

- (void)getFamilySuccess:(id)response
{
    [self hideHUD];
    NSLog(@"%@",[response objectForKey:@"Data"]);
    if ([[response objectForKey:@"Result"] intValue] == 1)
    {
        //算一次登陆成功 下次走loginBack
        [[NSUserDefaults standardUserDefaults] setObject:@"1" forKey:FirstLogin];
        [[NSUserDefaults standardUserDefaults] synchronize];
        _dataModel = nil;
        _dataModel = [FamilyModel FWithInfo:[response objectForKey:@"Data"]];
    
        [_detailViewArray removeAllObjects];
        
        [self layoutFamilyCenterWithFamilyModel:_dataModel];
        
        [self isLeaderViewShow];
        //处理推送消息
        [self receivedNotification];
    }
    else
    {
        if([[response objectForKey:@"Message"] length] > 1)
        {
            [self displayErrorHUDWithText:[response objectForKey:@"Message"]];
        }
    }
}

- (void)getFamilyFailure:(id)response
{
    [self hideHUD];
    [self displayErrorHUDWithText:@"请稍后再试"];
}

-(void)isLeaderViewShow
{
    NSString *isADD =  [[NSUserDefaults standardUserDefaults] objectForKey:AddNewBabySuccess];
    if([isADD isEqualToString:@"YES"])
    {
        [self performSelector:@selector(addLeaderView) withObject:nil afterDelay:1.0];

    }
}

-(void)addLeaderView
{
    //多小孩 引导页
    [[[UIApplication sharedApplication] keyWindow] addSubview:self.leaderIV];
}

-(UIImageView *)leaderIV
{
    if (!_leaderIV) {
        
        _leaderIV = [[UIImageView alloc]initWithFrame:self.view.window.bounds];
        _leaderIV.backgroundColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.5];
        _leaderIV.userInteractionEnabled = YES;
        
        UIButton *but = [UIButton buttonWithType:UIButtonTypeCustom];
        [but setBackgroundImage:[UIImage imageNamed:@"main_lead"] forState:UIControlStateNormal];
        but.frame = CGRectMake((_leaderIV.bounds.size.width - 258)/2, _leaderIV.bounds.size.height - 131 -120, 258, 131);
        [but addTarget:self action:@selector(actionHideLeaderView) forControlEvents:UIControlEventTouchUpInside];
        [_leaderIV addSubview:but];
    }
    return _leaderIV;
}

-(void)actionHideLeaderView
{
    [[NSUserDefaults standardUserDefaults] setObject:@"NO" forKey:AddNewBabySuccess];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [self.leaderIV removeFromSuperview];
    self.leaderIV = nil;
}

-(void)actionDelayShowNavgation
{
    [_scroller setContentOffset:CGPointMake(self.view.bounds.size.width*(indexLine-1), 0) animated:NO];
    
    [self setNavTitleWithKaiti:[NSString stringWithFormat:@"%@的体育⁺",_currentModel.nickName]];
}

-(void)layoutFamilyCenterWithFamilyModel:(FamilyModel *)model
{
    for (UIView *v in _scroller.subviews) {
        [v removeFromSuperview];
    }
    
    [_scroller setContentSize:CGSizeMake(self.view.bounds.size.width*[model.dataArray count], self.view.bounds.size.height)];

    _currentModel = [model.dataArray objectAtIndex:indexLine-1];
    
    for (int i = 0; i < [model.dataArray count]; i ++) {
        UIScrollView *sc = [[UIScrollView alloc] initWithFrame:CGRectMake(self.view.bounds.size.width * i, 0, self.view.bounds.size.width, self.view.bounds.size.height)];
        sc.bounces = YES;
        sc.clipsToBounds = YES;
        sc.showsHorizontalScrollIndicator = NO;
        sc.showsVerticalScrollIndicator = NO;
        if(iPhone4S)
        {
            [sc setContentSize:CGSizeMake(self.view.bounds.size.width, 500)];
        }
        else
        {
            [sc setContentSize:CGSizeMake(self.view.bounds.size.width, 550)];
        }
        [_scroller addSubview:sc];
        [self showDetailViewWithModel:[model.dataArray objectAtIndex:i] forView:sc];
    }
    [self performSelector:@selector(actionDelayShowNavgation) withObject:nil afterDelay:0.3];

}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    
    NSInteger index = scrollView.contentOffset.x / self.view.bounds.size.width;
    indexLine = index + 1;
    
    _currentModel = [_dataModel.dataArray objectAtIndex:index];
    _currentDeatilView = (DetailView *)[_detailViewArray objectAtIndex:index];
    [self performSelector:@selector(actionDelayShowNavgation) withObject:nil afterDelay:0.3];
}

-(void)receivedNotification
{
    NSString *timeNtf = [[NSUserDefaults standardUserDefaults] objectForKey:@"Time_Notification"];
    NSString *vedioNtf = [[NSUserDefaults standardUserDefaults] objectForKey:@"Veido_Notification"];
    NSString *XinliNtf = [[NSUserDefaults standardUserDefaults] objectForKey:@"Xinli_Notification"];
    

    if([timeNtf isEqualToString:@"YES"])
    {
        //自动进时光轴
        [self actionRight];
    }
    else if ([vedioNtf isEqualToString:@"YES"])
    {
        //自动进名家讲坛
        StarPeopleViewController *controller = [[StarPeopleViewController alloc] init];
        controller.childID = _currentModel.userID;
        [self.navigationController pushViewController:controller animated:YES];
    }
    else if([XinliNtf isEqualToString:@"YES"])
    {
        //心理辅导
        CounselViewController *controller = [[CounselViewController alloc] initWithUserID:_currentModel.userID];
        [self.navigationController pushViewController:controller animated:YES];
    }
    [[NSUserDefaults standardUserDefaults] setObject:@"NO" forKey:@"Veido_Notification"];
    [[NSUserDefaults standardUserDefaults] setObject:@"NO" forKey:@"Time_Notification"];
    [[NSUserDefaults standardUserDefaults] setObject:@"NO" forKey:@"Xinli_Notification"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
