//
//  AddNewViewController.m
//  fitnessII
//
//  Created by Haley on 15/8/6.
//  Copyright (c) 2015年 samples.hankang. All rights reserved.
//

#import "AddNewViewController.h"
#import "FamilyMembersModel.h"
#import "AppDelegate.h"

@interface AddNewViewController ()<UIAlertViewDelegate>
{
    BOOL isFather;
    BOOL isMother;
}

@end

@implementation AddNewViewController

//Gender：性别（B：男孩；G：女孩；F:女士；M：男士）
- (id)initWithFamilyModel:(FamilyModel *)model
{
    self = [super init];
    if (self) {
        // Custom initialization
        [model.dataArray enumerateObjectsUsingBlock:^(FamilyMembersModel *mm, NSUInteger idx, BOOL *stop) {
            //
            if([mm.gender isEqualToString:@"M"])
            {
                isFather = YES;
            }
            if([mm.gender isEqualToString:@"F"])
            {
                isMother = YES;
            }
        }];
    }
    return self;
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    if(iPhone4S)
    {
        [UIView animateWithDuration:0.6 animations:^{
            //
            _scroller.frame = CGRectMake(0, -30, _scroller.frame.size.width, _scroller.frame.size.height);
        } completion:^(BOOL finished) {
            //
        }];
    }
    return YES;
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if([_babyTextField isFirstResponder])
    {
        [_babyTextField resignFirstResponder];
    }
    else if ([_babyNameTextField isFirstResponder])
    {
        [_babyNameTextField resignFirstResponder];
    }
    if(iPhone4S)
    {
        [UIView animateWithDuration:0.6 animations:^{
            //
            _scroller.frame = CGRectMake(0, 0, _scroller.frame.size.width, _scroller.frame.size.height);
        } completion:^(BOOL finished) {
            //
        }];
    }
    return YES;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self setNavTitleWithKaiti:@"体育⁺"];
    [self setLeftButtonTitle:nil image:[UIImage imageNamed:@"arrow.png"] target:self selector:@selector(actionBackToResider:)];

    if(isMother && !isFather)
    {
        //显示邀请爸爸
        self.mdIv.image = [UIImage imageNamed:@"yqbb.png"];
        [_scroller setContentSize:CGSizeMake(self.view.bounds.size.width, iPhone4S? self.view.bounds.size.height + 140:self.view.bounds.size.height+64)];
    }
    if(!isMother && isFather)
    {
        //显示邀请妈妈
        self.mdIv.image = [UIImage imageNamed:@"yqmm.png"];
        [_scroller setContentSize:CGSizeMake(self.view.bounds.size.width, iPhone4S? self.view.bounds.size.height + 140:self.view.bounds.size.height+64)];
    }
    if(isFather && isMother)
    {
        //不显示
        self.bottonIv.hidden = YES;
        self.mdIv.hidden = YES;
        self.qqBut.hidden = YES;
        self.wxBut.hidden = YES;
        self.dxBut.hidden = YES;
    }
    _scroller.scrollEnabled =YES;
    
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(insteadTouch)];
    [_scroller addGestureRecognizer:tap];
}

-(void)insteadTouch
{
    if([_babyTextField isFirstResponder])
    {
        [_babyTextField resignFirstResponder];
    }
    else if ([_babyNameTextField isFirstResponder])
    {
        [_babyNameTextField resignFirstResponder];
    }
    if(iPhone4S)
    {
        [UIView animateWithDuration:0.6 animations:^{
            //
            _scroller.frame = CGRectMake(0, 0, _scroller.frame.size.width, _scroller.frame.size.height);
        } completion:^(BOOL finished) {
            //
        }];
    }
}

-(IBAction)actionBabyGo:(id)sender
{
    //事件统计 添加新成员确定按钮
    [MobClick event:FamilyMember_InviteCommit];
    
    if (self.babyNameTextField.text.length == 0) {
        [self displayErrorHUDWithText:@"请输入孩子姓名"];
        return;
    }
    if (self.babyTextField.text.length == 0) {
        [self displayErrorHUDWithText:@"邀请码不能为空"];
        return;
    }
    [self requestForMakeSureToInvitation];
}

-(NSString *)clearSpace:(NSString *)str
{
    NSString *strUrl = [str stringByReplacingOccurrencesOfString:@" " withString:@""];
    return strUrl;
}

-(void)requestForSureToAdd
{
    NSString *userID = [[NSUserDefaults standardUserDefaults] objectForKey:USERID];
    [self showLoadingHUD];
    HttpInvokeItem *dataItem = [[HttpInvokeItem alloc] init];
    if ([self respondsToSelector:@selector(invitationBabySuccess:)] && [self respondsToSelector:@selector(invitationBabyFailure:)])
    {
        [dataItem TargetSuper:self Success:@selector(invitationBabySuccess:) Failure:@selector(invitationBabyFailure:)];
    }
    dataItem.dataEncodingType = MKNKPostDataEncodingTypeJSON;
    NSString *path = [NSString stringWithFormat:@"%@?userID=%@&invitationCode=%@", Request_AddFamilyMember,userID,[self clearSpace:self.babyTextField.text]];
    
    [[HttpInvokeEngine shareHttpInvoke] InvokeHttpMethod:path withParams:nil addFile:nil withMethod:@"GET" InvokeItem:dataItem];
}

- (void)invitationBabySuccess:(id)response
{
    [self hideHUD];
    NSLog(@"%@",[response objectForKey:@"Data"]);
    if ([[response objectForKey:@"Result"] intValue] == 1)
    {
        [self displayErrorHUDWithText:[response objectForKey:@"Message"]];
        [[NSUserDefaults standardUserDefaults] setObject:@"YES" forKey:AddNewBabySuccess];
        [[NSUserDefaults standardUserDefaults] synchronize];
        [self actionBackToResider:nil];
    }
    else
    {
        if([[response objectForKey:@"Message"] length] > 1)
        {
            [self displayErrorHUDWithText:[response objectForKey:@"Message"]];
        }
    }
}

- (void)invitationBabyFailure:(id)response
{
    [self hideHUD];
    [self displayErrorHUDWithText:@"请稍后再试"];
}

-(void)requestForMakeSureToInvitation
{
    if([self.babyTextField isFirstResponder])
    {
        [self.babyTextField resignFirstResponder];
    }
    NSString *userID = [[NSUserDefaults standardUserDefaults] objectForKey:USERID];
    [self showLoadingHUD];
    HttpInvokeItem *dataItem = [[HttpInvokeItem alloc] init];
    if ([self respondsToSelector:@selector(sureInvitationSuccess:)] && [self respondsToSelector:@selector(sureInvitationFailure:)])
    {
        [dataItem TargetSuper:self Success:@selector(sureInvitationSuccess:) Failure:@selector(sureInvitationFailure:)];
    }
    dataItem.dataEncodingType = MKNKPostDataEncodingTypeJSON;
    NSString *path = [NSString stringWithFormat:@"%@?userID=%@&invitationCode=%@&studentName=%@", Request_GetFamilyMemberByIC,userID,[self clearSpace:self.babyTextField.text],[self clearSpace:self.babyNameTextField.text]];
    path = [path stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    [[HttpInvokeEngine shareHttpInvoke] InvokeHttpMethod:path withParams:nil addFile:nil withMethod:@"GET" InvokeItem:dataItem];
}

- (void)sureInvitationSuccess:(id)response
{
    [self hideHUD];
    NSLog(@"%@",[response objectForKey:@"Data"]);
    if ([[response objectForKey:@"Result"] intValue] == 1)
    {
        NSString *str = [response objectForKey:@"Data"];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:str delegate:self cancelButtonTitle:@"取消邀请" otherButtonTitles:@"确认添加", nil];
        [alert show];
    }
    else
    {
        if([[response objectForKey:@"Message"] length] > 1)
        {
            [self displayErrorHUDWithText:[response objectForKey:@"Message"]];
        }
    }
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex == 1)
    {
        //确定绑定
        [self requestForSureToAdd];
    }
}

- (void)sureInvitationFailure:(id)response
{
    [self hideHUD];
    [self displayErrorHUDWithText:@"请稍后再试"];
}

-(IBAction)actionShare:(UIButton *)sender
{
    NSString *invitCode = [[NSUserDefaults standardUserDefaults] objectForKey:InvitationCode];
    AppDelegate* appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    switch (sender.tag) {
        case 1:
        {
            //qq
            [appDelegate actionShareWithInviteCode:invitCode type:@"QQ"];
        }
            break;
        case 2:
        {
            //wx
            [appDelegate actionShareWithInviteCode:invitCode type:@"WX"];
        }
            break;
        case 3:
        {
            //dx
            [appDelegate actionShareWithInviteCode:invitCode type:@"DX"];
        }
            break;
            
        default:
            break;
    }

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
