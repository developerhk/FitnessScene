//
//  LoginBackViewController.h
//  fitnessII
//
//  Created by Haley on 15/8/3.
//  Copyright (c) 2015年 samples.hankang. All rights reserved.
//

#import "RootViewController.h"

@interface LoginBackViewController : RootViewController<UITextFieldDelegate>
@property (nonatomic, assign) BOOL isLoginFromMain;
@property (nonatomic, assign) BOOL isLoginFromBegin;

@property (nonatomic, strong) IBOutlet UIView *backGView;

//手机登录
@property (nonatomic, strong) IBOutlet UIView *moblieView;
@property (nonatomic, strong) IBOutlet UITextField *moblieText;
@property (nonatomic, strong) IBOutlet UITextField *passwordText;
@property (nonatomic, strong) IBOutlet UIButton *moblieLoginBut;
@property (nonatomic, strong) IBOutlet UIButton *forgetPassword;

@property (nonatomic, strong) IBOutlet UIButton *gouBut;
@property (nonatomic, strong) IBOutlet UIButton *xieyiBut;
@end
