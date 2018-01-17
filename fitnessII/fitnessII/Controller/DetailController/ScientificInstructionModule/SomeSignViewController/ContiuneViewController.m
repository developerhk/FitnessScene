//
//  ContiuneViewController.m
//  fitnessII
//
//  Created by Haley on 15/9/15.
//  Copyright (c) 2015年 samples.hankang. All rights reserved.
//

#import "ContiuneViewController.h"
#import "SoundBellEditor.h"
#import "TimeViewController.h"

@interface ContiuneViewController ()
{
    int timeCount;
    
    NSTimer *_ttimer;
    UITapGestureRecognizer *_tap;
}
@end

@implementation ContiuneViewController

-(id)initWithHKSignType:(HKSignType)type timeCount:(NSString *)count
{
    if(iPhone4S)
    {
        self = [super initWithNibName:@"Contiune4S" bundle:[NSBundle mainBundle]];
    }
    else
    {
        self = [super initWithNibName:@"ContiuneViewController" bundle:[NSBundle mainBundle]];
    }
    if(self)
    {
        self.signType = type;
        NSString *str = [NSString stringWithFormat:@"%@",count];
        if(![str isEqualToString:@"NO"])
        {
            timeCount = [count intValue];
        }
    }
    return self;
}

-(void)uploadTime
{
    [self performSelectorOnMainThread:@selector(actionUplaod) withObject:nil waitUntilDone:YES];
}

-(void)actionUplaod
{
    self.timeLabel.text = [NSString stringWithFormat:@"%d",timeCount --];
    if(timeCount == 0)
    {
        [self actionBackToLast];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [[UIApplication sharedApplication] setStatusBarOrientation:UIInterfaceOrientationLandscapeRight];
    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationSlide];
    self.view.transform = CGAffineTransformMakeRotation(M_PI/2);
    
    switch (self.signType) {
        case HK_Contiune:  //暂停
        {
            self.contiuneBut.userInteractionEnabled = YES;
            [self.contiuneBut setImage:[UIImage imageNamed:@"recipePlay.png"] forState:UIControlStateNormal];
            self.signLabel.text = @"继续训练";
            
            self.timeLabel.hidden = YES;
            self.rewardsLabel.hidden = YES;
            self.nextBut.hidden = YES;
        }
            break;
        case HK_Sleep:   //休息30秒
        {
            [SoundBellEditor playMusic:@"xiu_xi_yi_xia_ba.mp3"];

            _ttimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(uploadTime) userInfo:nil repeats:YES];
            
            [self.contiuneBut setImage:[UIImage imageNamed:@"recipejisu.png"] forState:UIControlStateNormal];
            self.signLabel.text = @"轻触屏幕跳过";
            self.timeLabel.text = [NSString stringWithFormat:@"%d",timeCount];
            
            self.timeLabel.hidden = NO;
            self.rewardsLabel.hidden = YES;
            self.nextBut.hidden = YES;
            
            _tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(actionBackToLast)];
            [self.view addGestureRecognizer:_tap];
        }
            break;
        case HK_Complete:
        {
            [SoundBellEditor playMusic:@"gong_xi_wan_cheng_xun_lian.mp3"];
            
            [self.contiuneBut setImage:[UIImage imageNamed:@"recipeFinish.png"] forState:UIControlStateNormal];
            self.signLabel.text = @"完成训练!";
            
            self.timeLabel.hidden = YES;
            //获得积分暂时不知道  先hidden
            self.rewardsLabel.hidden = YES;
            self.nextBut.hidden = NO;
            
            [self performSelector:@selector(requestForComplete) withObject:nil afterDelay:2.0];
        }
            break;
            
        default:
            break;
    }
}

-(void)requestForComplete
{
    if(self.dataDic && [self.dataDic count]> 0)
    {
        NSString *userID = [self.dataDic objectForKey:@"USERID"];
        NSString *begin = [self.dataDic objectForKey:@"BEGIN"];
        NSString *end = [self.dataDic objectForKey:@"END"];
        NSString *loginUser = [self.dataDic objectForKey:@"LoginUser"];
        
        [self showLoadingHUD];
        HttpInvokeItem *dataItem = [[HttpInvokeItem alloc] init];
        if ([self respondsToSelector:@selector(uploadCompleteSuccess:)] && [self respondsToSelector:@selector(uploadCompleteFailure:)])
        {
            [dataItem TargetSuper:self Success:@selector(uploadCompleteSuccess:) Failure:@selector(uploadCompleteFailure:)];
        }
        dataItem.dataEncodingType = MKNKPostDataEncodingTypeJSON;
        NSString *path = [NSString stringWithFormat:@"%@?userID=%@&startTime=%@&endTime=%@&parentUserID=%@",Request_AddExerciseProcess,userID,begin,end,loginUser];
        path = [path stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        
        [[HttpInvokeEngine shareHttpInvoke] InvokeHttpMethod:path withParams:nil addFile:nil withMethod:@"GET" InvokeItem:dataItem];
    }

}

- (void)uploadCompleteSuccess:(id)response
{
    [self hideHUD];
    if ([[response objectForKey:@"Result"] intValue] == 1)
    {
        [self displayErrorHUDWithText:[response objectForKey:@"Message"]];
    }
    else
    {
        if([[response objectForKey:@"Message"] length] > 1)
        {
            [self displayErrorHUDWithText:[response objectForKey:@"Message"]];
        }
    }
}

-(void)backToTimeZone
{
    TimeViewController *controller = [[TimeViewController alloc] init];
    [self.navigationController pushViewController:controller animated:YES];
}

- (void)uploadCompleteFailure:(id)response
{
    [self hideHUD];
    [self displayErrorHUDWithText:@"请稍后再试"];
}

-(void)actionBackToLast
{
    [_tap removeTarget:self action:nil];
    _tap = nil;
    
    [SoundBellEditor playMusic:@"xiu_xi_jie_shu.mp3"];
    [self performSelector:@selector(actionBackToLastLast) withObject:nil afterDelay:1.2];
}

-(void)actionBackToLastLast
{
    if(self.delegate && [self.delegate respondsToSelector:@selector(sleepBackForRestartFire)])
    {
        [self.delegate sleepBackForRestartFire];
    }
    [_ttimer invalidate];
    _ttimer = nil;
    [self.navigationController popViewControllerAnimated:YES];
}

-(IBAction)actionContiune:(id)sender
{
    if(self.delegate && [self.delegate respondsToSelector:@selector(contiuneBackForRestartFire)])
    {
        [self.delegate contiuneBackForRestartFire];
    }
    [self.navigationController popViewControllerAnimated:YES];
}

-(IBAction)actionNextStep:(UIButton *)sender
{
    //事件统计 视频播放页 点击完成训练按钮
    [MobClick event:SportsGuide_Success];
    
    [self backToTimeZone];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
