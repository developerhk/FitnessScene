//
//  IdentityViewController.h
//  fitnessII
//
//  Created by Haley on 15/7/7.
//  Copyright (c) 2015年 samples.hankang. All rights reserved.
//

#import "RootViewController.h"
#import "CheckNumModel.h"

@interface IdentityViewController : RootViewController

@property (nonatomic, strong) IBOutlet UIButton *dadBut;
@property (nonatomic, strong) IBOutlet UILabel *dadLabel;

@property (nonatomic, strong) IBOutlet UIButton *momBut;
@property (nonatomic, strong) IBOutlet UILabel *momLabel;

- (id)initWithCheckNumModel:(CheckNumModel *)model;

@end
