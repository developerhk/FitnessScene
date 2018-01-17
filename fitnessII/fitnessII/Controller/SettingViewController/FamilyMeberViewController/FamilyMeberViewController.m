//
//  FamilyMeberViewController.m
//  fitnessII
//
//  Created by Haley on 15/8/6.
//  Copyright (c) 2015年 samples.hankang. All rights reserved.
//

#import "FamilyMeberViewController.h"

@interface FamilyMeberViewController ()

@end

@implementation FamilyMeberViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self setNavTitleWithKaiti:@"家庭成员"];
    [self setLeftButtonTitle:nil image:[UIImage imageNamed:@"arrow.png"] target:self selector:@selector(actionBackToResider:)];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
