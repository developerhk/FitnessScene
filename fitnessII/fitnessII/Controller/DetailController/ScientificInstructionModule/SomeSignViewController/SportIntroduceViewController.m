//
//  SportIntroduceViewController.m
//  fitnessII
//
//  Created by Haley on 15/9/15.
//  Copyright (c) 2015年 samples.hankang. All rights reserved.
//

#import "SportIntroduceViewController.h"
#import "RecipeFileManager.h"

@interface SportIntroduceViewController ()
{
    RecipeItem *_dataModel;
}

@end

@implementation SportIntroduceViewController

-(id)initWithRecipeModel:(RecipeItem *)dataModel
{
    if(iPhone4S)
    {
        self = [super initWithNibName:@"SportI4S" bundle:[NSBundle mainBundle]];
    }
    else
    {
        self = [super initWithNibName:@"SportIntroduceViewController" bundle:[NSBundle mainBundle]];
    }
    if (self) {
        // Custom initialization
        _dataModel = dataModel;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [[UIApplication sharedApplication] setStatusBarOrientation:UIInterfaceOrientationLandscapeRight];
    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationSlide];
    self.view.transform = CGAffineTransformMakeRotation(M_PI/2);
    
    self.picImageV.image = [UIImage imageWithContentsOfFile:[[RecipeFileManager sharedInstance] filePathWithName:_dataModel.picName]];
    self.titleLab.text = [NSString stringWithFormat:@"%@",_dataModel.actionTitle];
    
    self.detailLab.text = [NSString stringWithFormat:@"%@",_dataModel.actionContent];
}

-(void)viewDidLayoutSubviews
{
    if (iPhone4S) {
        CGSize ss = [_dataModel.actionContent sizeWithFont:[UIFont systemFontOfSize:14] constrainedToSize:CGSizeMake(175.0f, MAXFLOAT) lineBreakMode:LineBreakByWordWrapping];
        self.detailLab.frame = CGRectMake(self.detailLab.frame.origin.x, self.detailLab.frame.origin.y, self.detailLab.frame.size.width, ss.height);
    }
    else
    {
        CGSize ss = [_dataModel.actionContent sizeWithFont:[UIFont systemFontOfSize:14] constrainedToSize:CGSizeMake(187.0f, MAXFLOAT) lineBreakMode:LineBreakByWordWrapping];
        self.detailLab.frame = CGRectMake(self.detailLab.frame.origin.x, self.detailLab.frame.origin.y, self.detailLab.frame.size.width, ss.height);
    }
}

-(IBAction)actionBack:(id)sender
{
    if(self.delegate && [self.delegate respondsToSelector:@selector(introduceBackToActionRecipe)])
    {
        [self.delegate introduceBackToActionRecipe];
    }
    
    [self.navigationController popViewControllerAnimated:YES];
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
