//
//  RealNameViewController.h
//  fitnessII
//
//  Created by Haley on 15/11/25.
//  Copyright (c) 2015年 samples.hankang. All rights reserved.
//

#import "RootViewController.h"

@interface RealNameViewController : RootViewController

@property (nonatomic, strong) IBOutlet UITextField *realName;
@property (nonatomic, strong) IBOutlet UITextField *mobile;

- (id)initWithSexCode:(int)sex;

@end
