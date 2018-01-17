//
//  LoginBackViewController.m
//  fitnessII
//
//  Created by Haley on 15/8/3.
//  Copyright (c) 2015年 samples.hankang. All rights reserved.
//

#import "LoginBackViewController.h"
#import "ForgetPFViewController.h"
#import "FMUString.h"
#import "MainViewController.h"
#import "ReadProtocalViewController.h"

@interface LoginBackViewController ()

@end

@implementation LoginBackViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)viewDidDisappear:(BOOL)animated
{
    _isLoginFromMain = NO;
    _isLoginFromBegin = NO;
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
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self resignEverything];
}

-(void)viewDidAppear:(BOOL)animated
{
    if(_isLoginFromBegin)
    {
        NSString *moble = [[NSUserDefaults standardUserDefaults] objectForKey:MobleNumber];
        NSString *password = [[NSUserDefaults standardUserDefaults] objectForKey:MoblePassword];
        if(moble.length > 0)
        {
            _moblieText.text = moble;
            _passwordText.text = password;
            [self actionLogin:nil];
        }
    }
    else
    {
        _moblieText.text = @"";
        _passwordText.text = @"";
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
}


-(IBAction)actionGou:(id)sender
{
    self.gouBut.selected = !self.gouBut.selected;
    self.moblieLoginBut.enabled = self.gouBut.selected;
}

-(IBAction)actionReadProtocol:(id)sender
{
    ReadProtocalViewController *controller = [[ReadProtocalViewController alloc] init];
    [self.navigationController pushViewController:controller animated:YES];
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


-(IBAction)actionLogin:(UIButton*)sender
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
        
        if(_isLoginFromMain)
        {
            [self actionBack:nil];
            return;
        }
        else
        {
            _isLoginFromMain = NO;
            MainViewController *controller = [[MainViewController alloc] initWithUserID:[response objectForKey:@"UserID"] fromMobileLogin:YES];
            [self.navigationController pushViewController:controller animated:YES];
        }
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

-(IBAction)actionForgetPassword:(UIButton *)sender
{
    //事件统计 重置密码按钮
    [MobClick event:Login_ResetPassword];
    
    ForgetPFViewController *controller = [[ForgetPFViewController alloc] init];
    [self.navigationController pushViewController:controller animated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
