//
//  ForgetPSViewController.h
//  fitnessII
//
//  Created by Haley on 15/8/3.
//  Copyright (c) 2015年 samples.hankang. All rights reserved.
//

#import "RootViewController.h"

@interface ForgetPSViewController : RootViewController<UITextFieldDelegate>

@property (nonatomic, strong) IBOutlet UITextField *checkField;
@property (nonatomic, strong) IBOutlet UITextField *nPassField;
- (id)initWithPhoneNumber:(NSString *)phone;
@end
