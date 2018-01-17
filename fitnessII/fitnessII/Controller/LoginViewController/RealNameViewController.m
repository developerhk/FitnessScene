//
//  RealNameViewController.m
//  fitnessII
//
//  Created by Haley on 15/11/25.
//  Copyright (c) 2015年 samples.hankang. All rights reserved.
//

#import "RealNameViewController.h"
#import "RegisterViewController.h"
#import "FMUString.h"

@interface RealNameViewController ()
{
    int sexCode;
}
@end

@implementation RealNameViewController

- (id)initWithSexCode:(int)sex
{
    self = [super init];
    if (self) {
        // Custom initialization
        sexCode = sex;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationController.navigationBarHidden = NO;
    [self setNavTitleWithKaiti:@"完善资料"];
    [self setLeftButtonTitle:nil image:[UIImage imageNamed:@"arrow.png"] target:self selector:@selector(actionBack:)];
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    if([_mobile isFirstResponder])
    {
        [_mobile resignFirstResponder];
    }
    else if ([_realName isFirstResponder])
    {
        [_realName resignFirstResponder];
    }
    else
    {
        return;
    }
}

-(IBAction)actionNext:(id)sender
{
    if([FMUString isEmptyString:self.realName.text])
    {
        [self displayErrorHUDWithText:@"请输入真实姓名"];
        return;
    }
    if([FMUString textLengthWithChineseAndEnglish:self.realName.text]  > 20)
    {
        [self displayErrorHUDWithText:@"姓名过长(最多10个汉字或20个字母)"];
        return;
    }
    if (self.mobile.text.length == 0) {
        [self displayErrorHUDWithText:@"手机号码不能为空"];
        return;
    }
    if (![FMUString isMobileNumber:self.mobile.text]) {
        [self displayErrorHUDWithText:@"手机号码格式不正确"];
        return;
    }
    
    if([_mobile isFirstResponder])
    {
        [_mobile resignFirstResponder];
    }
    if ([_realName isFirstResponder])
    {
        [_realName resignFirstResponder];
    }
    //请求
    [self showLoadingHUD];
    
    HttpInvokeItem *dataItem = [[HttpInvokeItem alloc] init];
    if ([self respondsToSelector:@selector(verCoderequestSuccess:)] && [self respondsToSelector:@selector(verCoderequestFailure:)])
    {
        [dataItem TargetSuper:self Success:@selector(verCoderequestSuccess:) Failure:@selector(verCoderequestFailure:)];
    }
    dataItem.dataEncodingType = MKNKPostDataEncodingTypeJSON;
    NSString *path = [NSString stringWithFormat:@"%@?mobile=%@&checkMobileExist=%@", Request_FetchVerifyCode,self.mobile.text,@"T"];
    
    [[HttpInvokeEngine shareHttpInvoke] InvokeHttpMethod:path withParams:nil addFile:nil withMethod:@"GET" InvokeItem:dataItem];
}

- (void)verCoderequestSuccess:(id)response
{
    [self hideHUD];
    NSLog(@"%@",[response objectForKey:@"Data"]);
    if ([[response objectForKey:@"Result"] intValue] == 1)
    {
        [self displayErrorHUDWithText:[response objectForKey:@"Message"]];
        [self performSelector:@selector(gotoNext) withObject:nil afterDelay:1];
    }
    else
    {
        if([[response objectForKey:@"Message"] length] > 1)
        {
            [self displayErrorHUDWithText:[response objectForKey:@"Message"]];
        }
    }
}

-(void)gotoNext
{
    RegisterViewController *controller = [[RegisterViewController alloc] initWithSexCode:sexCode mobile:_mobile.text realName:_realName.text];
    [self.navigationController pushViewController:controller animated:YES];
}

- (void)verCoderequestFailure:(id)response
{
    [self hideHUD];
    [self displayErrorHUDWithText:@"请稍后再试"];
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
