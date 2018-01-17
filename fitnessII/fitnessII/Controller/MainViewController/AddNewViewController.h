//
//  AddNewViewController.h
//  fitnessII
//
//  Created by Haley on 15/8/6.
//  Copyright (c) 2015年 samples.hankang. All rights reserved.
//

#import "RootViewController.h"
#import "FamilyModel.h"

@interface AddNewViewController : RootViewController<UITextFieldDelegate,UIScrollViewDelegate>

@property (nonatomic, strong) IBOutlet UIScrollView *scroller;

@property (nonatomic, strong) IBOutlet UITextField *babyNameTextField;
@property (nonatomic, strong) IBOutlet UITextField *babyTextField;
@property (nonatomic, strong) IBOutlet UIButton *babyGo;

@property (nonatomic, strong) IBOutlet UIImageView *bottonIv;
@property (nonatomic, strong) IBOutlet UIImageView *mdIv;
@property (nonatomic, strong) IBOutlet UIButton *qqBut;
@property (nonatomic, strong) IBOutlet UIButton *wxBut;
@property (nonatomic, strong) IBOutlet UIButton *dxBut;

- (id)initWithFamilyModel:(FamilyModel *)model;

@end
