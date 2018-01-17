//
//  LoginViewController.m
//  fitnessII
//
//  Created by Haley on 15/7/7.
//  Copyright (c) 2015年 samples.hankang. All rights reserved.
//

#import "LoginViewController.h"
#import "IdentityViewController.h"
#import "CheckNumModel.h"
#import "ForgetPFViewController.h"
#import "IdentityViewController.h"
#import "FMUString.h"
#import "MainViewController.h"
#import "ReadProtocalViewController.h"

@interface LoginViewController ()

@end

@implementation LoginViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
    }
    return self;
}

-(void)viewWillAppear:(BOOL)animated
{
    self.navigationController.navigationBarHidden = YES;
}

-(void)resignEverything
{
    if([_moblieText isFirstResponder])
    {
        [_moblieText resignFirstResponder];
        [UIView animateWithDuration:0.3 animations:^{
            _backGView.frame = CGRectMake(0, 0, _backGView.frame.size.width, _backGView.frame.size.height);
        } completion:^(BOOL finished) {
            //
        }];
    }
    else if([_passwordText isFirstResponder])
    {
        [_passwordText resignFirstResponder];
        [UIView animateWithDuration:0.3 animations:^{
            _backGView.frame = CGRectMake(0, 0, _backGView.frame.size.width, _backGView.frame.size.height);
        } completion:^(BOOL finished) {
            //
        }];
    }
    else if([_checkField isFirstResponder])
    {
        [_checkField resignFirstResponder];
        [UIView animateWithDuration:0.3 animations:^{
            _backGView.frame = CGRectMake(0, 0, _backGView.frame.size.width, _backGView.frame.size.height);
        } completion:^(BOOL finished) {
            //
        }];
    }
    else if([_childText isFirstResponder])
    {
        [_childText resignFirstResponder];
        [UIView animateWithDuration:0.3 animations:^{
            _backGView.frame = CGRectMake(0, 0, _backGView.frame.size.width, _backGView.frame.size.height);
        } completion:^(BOOL finished) {
            //
        }];
    }

}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self resignEverything];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    _inviteBut.selected = YES;
    
}

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    if(iPhone4S)
    {
        [UIView animateWithDuration:0.3 animations:^{
            _backGView.frame = CGRectMake(0, -120, _backGView.frame.size.width, _backGView.frame.size.height);
        
        } completion:^(BOOL finished) {
            //
        }];
    }
    else
    {
        [UIView animateWithDuration:0.3 animations:^{
            _backGView.frame = CGRectMake(0, -60, _backGView.frame.size.width, _backGView.frame.size.height);
            
        } completion:^(BOOL finished) {
            //
        }];
    }

    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [UIView animateWithDuration:0.3 animations:^{
        _backGView.frame = CGRectMake(0, 0, _backGView.frame.size.width, _backGView.frame.size.height);
        
    } completion:^(BOOL finished) {
        //
        [textField resignFirstResponder];
    }];
    return YES;
}

-(IBAction)actionSwitch:(UIButton *)sender
{
    switch (sender.tag) {
        case 1:
        {
            //手机号
            [self chooseLeft];
        }
            break;
        case 2:
        {
            //邀请码
            [self chooseRight];
        }
            break;
            
        default:
            break;
    }
}

-(void)chooseLeft
{
    _moblieBut.selected = YES;
    _inviteBut.selected = NO;
    [UIView animateWithDuration:0.5 animations:^{
        //
        _yellowLine.frame = CGRectMake(61, _yellowLine.frame.origin.y, _yellowLine.frame.size.width, _yellowLine.frame.size.height);
        
        _moblieView.frame = CGRectMake(20, _moblieView.frame.origin.y, _moblieView.frame.size.width, _moblieView.frame.size.height);
        _inviteView.frame = CGRectMake(500, _moblieView.frame.origin.y, _moblieView.frame.size.width, _moblieView.frame.size.height);
        
    } completion:^(BOOL finished) {
        //
    }];
}
-(void)chooseRight
{
    _moblieBut.selected = NO;
    _inviteBut.selected = YES;
    [UIView animateWithDuration:0.5 animations:^{
        //
        _yellowLine.frame = CGRectMake(192, _yellowLine.frame.origin.y, _yellowLine.frame.size.width, _yellowLine.frame.size.height);
        
        _inviteView.frame = CGRectMake(20, _moblieView.frame.origin.y, _moblieView.frame.size.width, _moblieView.frame.size.height);
        _moblieView.frame = CGRectMake(-500, _moblieView.frame.origin.y, _moblieView.frame.size.width, _moblieView.frame.size.height);
        
    } completion:^(BOOL finished) {
        //
    }];
}

-(IBAction)actionForgetPassword:(UIButton *)sender
{
    //事件统计 重置密码按钮
    [MobClick event:Login_ResetPassword];
    
    ForgetPFViewController *controller = [[ForgetPFViewController alloc] init];
    [self.navigationController pushViewController:controller animated:YES];
}

-(IBAction)actionGouForMoble:(id)sender
{
    self.gouBut.selected = !self.gouBut.selected;
    self.moblieLoginBut.enabled = self.gouBut.selected;
}
-(IBAction)actionGouForCheck:(id)sender
{
    self.gouCBut.selected = !self.gouCBut.selected;
    self.checkBut.enabled = self.gouCBut.selected;
}

-(IBAction)actionReadProtocol:(id)sender
{
    ReadProtocalViewController *controller = [[ReadProtocalViewController alloc] init];
    [self.navigationController pushViewController:controller animated:YES];
}

#pragma mark - request
-(IBAction)actionCheckLogin:(id)sender
{
    //事件统计 邀请码登录
    [MobClick event:Register_GoOn];
    
    [self resignEverything];
    if (self.childText.text.length == 0) {
        [self displayErrorHUDWithText:@"请输入孩子姓名"];
        return;
    }
    if (self.checkField.text.length == 0) {
        [self displayErrorHUDWithText:@"请输入邀请码"];
        return;
    }
    
    [self showLoadingHUD];
    HttpInvokeItem *dataItem = [[HttpInvokeItem alloc] init];
    if ([self respondsToSelector:@selector(checkCodeSuccess:)] && [self respondsToSelector:@selector(checkCodeFailure:)])
    {
        [dataItem TargetSuper:self Success:@selector(checkCodeSuccess:) Failure:@selector(checkCodeFailure:)];
    }
    dataItem.dataEncodingType = MKNKPostDataEncodingTypeJSON;
    NSString *path = [NSString stringWithFormat:@"%@?invitationCode=%@&studentName=%@", Request_VerifyInivationCode,self.checkField.text,self.childText.text];
    path = [path stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];

    [[HttpInvokeEngine shareHttpInvoke] InvokeHttpMethod:path withParams:nil addFile:nil withMethod:@"GET" InvokeItem:dataItem];
}

- (void)checkCodeSuccess:(id)response
{
    [self hideHUD];
    NSLog(@"%@",[response objectForKey:@"Data"]);
    if ([[response objectForKey:@"Result"] intValue] == 1)
    {
        [[NSUserDefaults standardUserDefaults] setObject:self.checkField.text forKey:InvitationCode];
        [[NSUserDefaults standardUserDefaults] synchronize];
        CheckNumModel *model = [CheckNumModel CNWithInfo:[response objectForKey:@"Data"]];
        IdentityViewController *identityController = [[IdentityViewController alloc] initWithCheckNumModel:model];
        [self.navigationController pushViewController:identityController animated:YES];
    }
    else
    {
        if([[response objectForKey:@"Message"] length] > 1)
        {
            [self displayErrorHUDWithText:[response objectForKey:@"Message"]];
        }
    }
}

- (void)checkCodeFailure:(id)response
{
    [self hideHUD];
    [self displayErrorHUDWithText:@"请稍后再试"];
}

-(IBAction)actionMoblieLogin:(id)sender
{
    //事件统计 手机号码登录
    [MobClick event:Login_Commit];
    
    [self resignEverything];
    if (self.moblieText.text.length == 0) {
        [self displayErrorHUDWithText:@"手机号码不能为空"];
        return;
    }
    if (![FMUString isMobileNumber:self.moblieText.text]) {
        [self displayErrorHUDWithText:@"手机号码格式不正确"];
        return;
    }
    if(self.passwordText.text.length == 0)
    {
        [self displayErrorHUDWithText:@"请填写密码"];
        return;
    }

    [self showLoadingHUD];
    HttpInvokeItem *dataItem = [[HttpInvokeItem alloc] init];
    if ([self respondsToSelector:@selector(moblieLoginSuccess:)] && [self respondsToSelector:@selector(moblieLoginFailure:)])
    {
        [dataItem TargetSuper:self Success:@selector(moblieLoginSuccess:) Failure:@selector(moblieLoginFailure:)];
    }
    dataItem.dataEncodingType = MKNKPostDataEncodingTypeJSON;
    NSString *path = [NSString stringWithFormat:@"%@?mobile=%@&password=%@", Request_LoginByMobile,self.moblieText.text,self.passwordText.text];
    
    [[HttpInvokeEngine shareHttpInvoke] InvokeHttpMethod:path withParams:nil addFile:nil withMethod:@"GET" InvokeItem:dataItem];
}

- (void)moblieLoginSuccess:(id)response
{
    [self hideHUD];
    NSLog(@"%@",[response objectForKey:@"Data"]);
    if ([[response objectForKey:@"Result"] intValue] == 1)
    {
        [[NSUserDefaults standardUserDefaults] setObject:[response objectForKey:@"UserID"] forKey:USERID];
        [[NSUserDefaults standardUserDefaults] setObject:[response objectForKey:@"FamilyID"] forKey:InvitationCode];
        [[NSUserDefaults standardUserDefaults] setObject:[response objectForKey:@"Mobile"] forKey:MobleNumber];
        [[NSUserDefaults standardUserDefaults] setObject:[response objectForKey:@"Password"] forKey:MoblePassword];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        LoginModel *loginModel = [LoginModel LMWithInfo:(NSDictionary *)response];
        [self getFMBModelWithLModle:loginModel];
        
        MainViewController *controller = [[MainViewController alloc] initWithUserID:[response objectForKey:@"UserID"] fromMobileLogin:YES];
        [self.navigationController pushViewController:controller animated:YES];
    }
    else
    {
        if([[response objectForKey:@"Message"] length] > 1)
        {
            [self displayErrorHUDWithText:[response objectForKey:@"Message"]];
        }
    }
}

- (void)moblieLoginFailure:(id)response
{
    [self hideHUD];
    [self displayErrorHUDWithText:@"请稍后再试"];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
