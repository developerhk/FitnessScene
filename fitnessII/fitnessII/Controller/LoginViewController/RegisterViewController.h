//
//  RegisterViewController.h
//  fitnessII
//
//  Created by Haley on 15/7/7.
//  Copyright (c) 2015年 samples.hankang. All rights reserved.
//

#import "RootViewController.h"

@interface RegisterViewController : RootViewController<UITextFieldDelegate>

@property (nonatomic, strong) IBOutlet UIView *backGdView;
@property (nonatomic, strong) IBOutlet UITextField *checkCode;
@property (nonatomic, strong) IBOutlet UITextField *password;
@property (nonatomic, strong) IBOutlet UIButton *completeBut;

- (id)initWithSexCode:(int)sex mobile:(NSString *)mobile realName:(NSString *)realName;

@end
