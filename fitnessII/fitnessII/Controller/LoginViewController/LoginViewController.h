//
//  LoginViewController.h
//  fitnessII
//
//  Created by Haley on 15/7/7.
//  Copyright (c) 2015年 samples.hankang. All rights reserved.
//

#import "RootViewController.h"

@interface LoginViewController : RootViewController<UITextFieldDelegate>

@property (nonatomic, strong) IBOutlet UIView *backGView;

@property (nonatomic, strong) IBOutlet UIButton *moblieBut;
@property (nonatomic, strong) IBOutlet UIButton *inviteBut;
@property (nonatomic, strong) IBOutlet UIImageView *yellowLine;

//手机登录
@property (nonatomic, strong) IBOutlet UIView *moblieView;
@property (nonatomic, strong) IBOutlet UITextField *moblieText;
@property (nonatomic, strong) IBOutlet UITextField *passwordText;
@property (nonatomic, strong) IBOutlet UIButton *moblieLoginBut;
@property (nonatomic, strong) IBOutlet UIButton *forgetPassword;

//邀请码登陆
@property (nonatomic, strong) IBOutlet UIView *inviteView;
@property (nonatomic, strong) IBOutlet UITextField *childText;
@property (nonatomic, strong) IBOutlet UITextField *checkField;
@property (nonatomic, strong) IBOutlet UIButton *checkBut;

@property (nonatomic, strong) IBOutlet UIButton *gouBut;
@property (nonatomic, strong) IBOutlet UIButton *gouCBut;
@property (nonatomic, strong) IBOutlet UIButton *xieyiBut;
@end
