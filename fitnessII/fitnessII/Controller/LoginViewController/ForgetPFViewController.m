//
//  ForgetPFViewController.m
//  fitnessII
//
//  Created by Haley on 15/8/3.
//  Copyright (c) 2015年 samples.hankang. All rights reserved.
//

#import "ForgetPFViewController.h"
#import "ForgetPSViewController.h"
#import "FMUString.h"

@interface ForgetPFViewController ()
{
    NSString *_mobleStr;
}

@end

@implementation ForgetPFViewController

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
    self.navigationController.navigationBarHidden = NO;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self setNavTitleWithKaiti:@"验证手机号"];
    [self setLeftButtonTitle:nil image:[UIImage imageNamed:@"arrow.png"] target:self selector:@selector(actionBack:)];
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    if([_phoneField isFirstResponder])
    {
        [_phoneField resignFirstResponder];
    }
}

-(IBAction)actionForgetPasswordS:(UIButton *)sender
{

    if (self.phoneField.text.length == 0) {
        [self displayErrorHUDWithText:@"手机号码不能为空"];
        return;
    }
    if (![FMUString isMobileNumber:self.phoneField.text]) {
        [self displayErrorHUDWithText:@"手机号码格式不正确"];
        return;
    }
    if([_phoneField isFirstResponder])
    {
        [_phoneField resignFirstResponder];
    }
    _mobleStr = _phoneField.text;
    [self showLoadingHUD];
    
    HttpInvokeItem *dataItem = [[HttpInvokeItem alloc] init];
    if ([self respondsToSelector:@selector(verCoderequestSuccess:)] && [self respondsToSelector:@selector(verCoderequestFailure:)])
    {
        [dataItem TargetSuper:self Success:@selector(verCoderequestSuccess:) Failure:@selector(verCoderequestFailure:)];
    }
    dataItem.dataEncodingType = MKNKPostDataEncodingTypeJSON;
    NSString *path = [NSString stringWithFormat:@"%@?mobile=%@&checkMobileExist=%@", Request_FetchVerifyCode,self.phoneField.text,@"F"];
    [[HttpInvokeEngine shareHttpInvoke] InvokeHttpMethod:path withParams:nil addFile:nil withMethod:@"GET" InvokeItem:dataItem];

}

- (void)verCoderequestSuccess:(id)response
{
    [self hideHUD];
    NSLog(@"%@",[response objectForKey:@"Data"]);
    if ([[response objectForKey:@"Result"] intValue] == 1)
    {
        [self displayErrorHUDWithText:[response objectForKey:@"Message"]];
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
    ForgetPSViewController *controller = [[ForgetPSViewController alloc] initWithPhoneNumber:_mobleStr];
    [self.navigationController pushViewController:controller animated:YES];
}

- (void)verCoderequestFailure:(id)response
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
