//
//  ForgetPSViewController.m
//  fitnessII
//
//  Created by Haley on 15/8/3.
//  Copyright (c) 2015年 samples.hankang. All rights reserved.
//

#import "ForgetPSViewController.h"
#import "FMUString.h"

@interface ForgetPSViewController ()
{
    NSString *_phoneNumber;
}

@end

@implementation ForgetPSViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (id)initWithPhoneNumber:(NSString *)phone
{
    self = [super init];
    if (self) {
        // Custom initialization
        _phoneNumber = phone;
        
    }
    return self;
}

-(void)viewWillAppear:(BOOL)animated
{
    self.navigationController.navigationBarHidden = NO;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self setNavTitleWithKaiti:@"重置密码"];
    [self setLeftButtonTitle:nil image:[UIImage imageNamed:@"arrow.png"] target:self selector:@selector(actionBack:)];
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    if([_checkField isFirstResponder])
    {
        [_checkField resignFirstResponder];
    }
    else if ([_nPassField isFirstResponder])
    {
        [_nPassField resignFirstResponder];
    }
}

-(IBAction)actionLogin:(UIButton *)sender
{
    if([_checkField isFirstResponder])
    {
        [_checkField resignFirstResponder];
    }
    else if ([_nPassField isFirstResponder])
    {
        [_nPassField resignFirstResponder];
    }
    if(self.checkField.text.length == 0)
    {
        [self displayErrorHUDWithText:@"验证码不能为空"];
        return;
    }
    if(self.nPassField.text.length == 0)
    {
        [self displayErrorHUDWithText:@"密码不能为空"];
        return;
    }
    if(self.nPassField.text.length > 10)
    {
        [self displayErrorHUDWithText:@"密码太长"];
        return;
    }
    if(![FMUString digitACharacterAuth:self.nPassField.text min:1 max:10])
    {
        [self displayErrorHUDWithText:@"请输入1-10位字母或数字"];
        return;
    }
    [self showLoadingHUD];
    
    HttpInvokeItem *dataItem = [[HttpInvokeItem alloc] init];
    if ([self respondsToSelector:@selector(changePassSuccess:)] && [self respondsToSelector:@selector(changePassFailure:)])
    {
        [dataItem TargetSuper:self Success:@selector(changePassSuccess:) Failure:@selector(changePassFailure:)];
    }
    dataItem.dataEncodingType = MKNKPostDataEncodingTypeJSON;
    NSString *path = [NSString stringWithFormat:@"%@?mobile=%@&smsCode=%@&newPassword=%@", Request_ProcForgetPassword,_phoneNumber,self.checkField.text,self.nPassField.text];
    
    [[HttpInvokeEngine shareHttpInvoke] InvokeHttpMethod:path withParams:nil addFile:nil withMethod:@"GET" InvokeItem:dataItem];
    
}

- (void)changePassSuccess:(id)response
{
    [self hideHUD];
    NSLog(@"%@",[response objectForKey:@"Data"]);
    if ([[response objectForKey:@"Result"] intValue] == 1)
    {
        [self displayErrorHUDWithText:@"修改成功"];
        [self performSelector:@selector(actionGoNext) withObject:nil afterDelay:1];
    }
    else
    {
        if([[response objectForKey:@"Message"] length] > 1)
        {
            [self displayErrorHUDWithText:[response objectForKey:@"Message"]];
        }
    }
}

-(void)actionGoNext
{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)changePassFailure:(id)response
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
