//
//  RegisterViewController.m
//  fitnessII
//
//  Created by Haley on 15/7/7.
//  Copyright (c) 2015年 samples.hankang. All rights reserved.
//

#import "RegisterViewController.h"
#import "MainViewController.h"
#import "FMUString.h"
#import "SFHFKeychainUtils.h"

@interface RegisterViewController ()
{
    int sexCode;
    NSString *_mobile;
    NSString *_realName;
}

@end

@implementation RegisterViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (id)initWithSexCode:(int)sex mobile:(NSString *)mobile realName:(NSString *)realName
{
    self = [super init];
    if (self) {
        // Custom initialization
        sexCode = sex;
        _mobile = mobile;
        _realName = realName;
    }
    return self;
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    if ([_checkCode isFirstResponder])
    {
        [_checkCode resignFirstResponder];
    }
    else if ([_password isFirstResponder])
    {
        [_password resignFirstResponder];
    }
    else
    {
        return;
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self setNavTitleWithKaiti:@"完善资料"];
    [self setLeftButtonTitle:nil image:[UIImage imageNamed:@"arrow.png"] target:self selector:@selector(actionBack:)];
}

#pragma mark - UITextFieldDelegate
-(IBAction)actionComplete:(id)sender
{
    //事件统计 用户信息填写页面
    [MobClick event:RegProfile_Commit];
    
    if(self.checkCode.text.length == 0)
    {
        [self displayErrorHUDWithText:@"请填写验证码"];
        return;
    }
    if(self.checkCode.text.length > 6)
    {
        [self displayErrorHUDWithText:@"验证码不能超过6位"];
        return;
    }
    if(self.password.text.length == 0)
    {
        [self displayErrorHUDWithText:@"请填写密码"];
        return;
    }
    if(self.password.text.length > 10)
    {
        [self displayErrorHUDWithText:@"密码太长"];
        return;
    }
    if(![FMUString digitACharacterAuth:self.password.text min:1 max:10])
    {
        [self displayErrorHUDWithText:@"请输入1-10位字母或数字"];
        return;
    }

    [self requestComplete];
}

-(void)requestComplete
{
    [self showLoadingHUD];
    
    HttpInvokeItem *dataItem = [[HttpInvokeItem alloc] init];
    if ([self respondsToSelector:@selector(completeSuccess:)] && [self respondsToSelector:@selector(completeFailure:)])
    {
        [dataItem TargetSuper:self Success:@selector(completeSuccess:) Failure:@selector(completeFailure:)];
    }
    dataItem.dataEncodingType = MKNKPostDataEncodingTypeJSON;
    
    NSString *invitCode = [[NSUserDefaults standardUserDefaults] objectForKey:InvitationCode];
    NSString *path = [NSString stringWithFormat:@"%@?invitationCode=%@&relationCode=%d&mobile=%@&password=%@&smsVerifyCode=%@&realName=%@", Request_CreateUserAndRelation,invitCode,sexCode,_mobile,_password.text,self.checkCode.text,_realName];
    path = [path stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [[HttpInvokeEngine shareHttpInvoke] InvokeHttpMethod:path withParams:nil addFile:nil withMethod:@"GET" InvokeItem:dataItem];
}

- (void)completeSuccess:(id)response
{
    [self hideHUD];
    NSLog(@"%@",[response objectForKey:@"Data"]);
    if ([[response objectForKey:@"Result"] intValue] == 1)
    {
        [[NSUserDefaults standardUserDefaults] setObject:[[response objectForKey:@"Data"] objectForKey:@"UserID"] forKey:USERID];
        [[NSUserDefaults standardUserDefaults] setObject:_mobile forKey:MobleNumber];
        [[NSUserDefaults standardUserDefaults] setObject:self.password.text forKey:MoblePassword];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        LoginModel *loginModel = [LoginModel LMWithInfo:(NSDictionary *)response]; //这一步只是生成model
        loginModel.userID =[[response objectForKey:@"Data"] objectForKey:@"UserID"];
        loginModel.gender = [[response objectForKey:@"Data"] objectForKey:@"UserGender"];
        loginModel.nickName = [[response objectForKey:@"Data"] objectForKey:@"NickName"];
        [self getFMBModelWithLModle:loginModel];
        
        MainViewController *controller = [[MainViewController alloc] initWithUserID:[[response objectForKey:@"Data"] objectForKey:@"UserID"] fromMobileLogin:NO];
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

- (void)completeFailure:(id)response
{
    [self hideHUD];
    [self displayErrorHUDWithText:@"请稍后再试"];
}

-(void)judgeUserIDFromKeychainWithUserID:(NSString *)userID
{
    NSString *userid = [SFHFKeychainUtils getPasswordForUsername:USERNAME andServiceName:ServiceName error:nil];
    if(userid == nil || userid.length == 0)
    {
        [SFHFKeychainUtils storeUsername:USERNAME andPassword:userID forServiceName:ServiceName updateExisting:YES error:nil];
    }
    else
    {
     
    }
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
