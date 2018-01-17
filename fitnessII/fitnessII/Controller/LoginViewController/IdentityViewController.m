//
//  IdentityViewController.m
//  fitnessII
//
//  Created by Haley on 15/7/7.
//  Copyright (c) 2015年 samples.hankang. All rights reserved.
//

#import "IdentityViewController.h"
#import "RealNameViewController.h"

@interface IdentityViewController ()
{
    CheckNumModel *_dataModel;
}

@end

@implementation IdentityViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization

    }
    return self;
}

- (id)initWithCheckNumModel:(CheckNumModel *)model
{
    self = [super init];
    if (self) {
        // Custom initialization
        _dataModel = model;

    }
    return self;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationController.navigationBarHidden = NO;
    [self setNavTitleWithImage:[UIImage imageNamed:@"tiyu+.png"]];
    [self setLeftButtonTitle:nil image:[UIImage imageNamed:@"arrow.png"] target:self selector:@selector(actionBack:)];

    self.dadLabel.text = [NSString stringWithFormat:@"%@的爸爸",_dataModel.studentName];
    self.momLabel.text = [NSString stringWithFormat:@"%@的妈妈",_dataModel.studentName];
    if(_dataModel.isChooseFather)
    {
        self.dadBut.enabled = NO;
        self.dadBut.userInteractionEnabled = NO;
        self.dadLabel.textColor = [UIColor grayColor];
    }
    if(_dataModel.isChooseMather)
    {
        self.momBut.enabled = NO;
        self.momBut.userInteractionEnabled = NO;
        self.momLabel.textColor = [UIColor grayColor];
    }
}

-(IBAction)actionCHooseSex:(UIButton *)sender
{
    int indx  = [[NSString stringWithFormat:@"%ld",(long)sender.tag] intValue];
    RealNameViewController *controller = [[RealNameViewController alloc] initWithSexCode:indx];
    [self.navigationController pushViewController:controller animated:YES];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
