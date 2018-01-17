//
//  GreenViewController.m
//  fitnessII
//
//  Created by Haley on 15/7/12.
//  Copyright (c) 2015年 samples.hankang. All rights reserved.
//

#import "GreenViewController.h"
#import "RecipeViewController.h"
#import "RecipeModel.h"

@interface GreenViewController ()<UIAlertViewDelegate>
{
    NSString *_useID;
    RecipeModel *_dataModel;
}

@end

@implementation GreenViewController

-(id)initWithUserID:(NSString *)userID
{
    self = [super init];
    if (self) {
        // Custom initialization
        _useID = userID;
    }
    return self;
}

-(void)actionBack:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)viewWillAppear:(BOOL)animated
{
    self.navigationController.navigationBarHidden = NO;
    [[UIApplication sharedApplication] setIdleTimerDisabled:NO];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    _dataModel = nil;
    [self setLeftButtonTitle:nil image:[UIImage imageNamed:@"arrow.png"] target:self selector:@selector(actionBack:)];
    [self setNavTitleWithKaiti:@"健康指导"];

    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://%@/GetIndex?userID=%@",HostName,_useID]]]];
    self.webView.scrollView.showsVerticalScrollIndicator = NO;
    
}

-(IBAction)actionDownloadRecipe:(UIButton *)sender
{
    //事件统计 体质评价页面 点击科学运动指导按钮
    [MobClick event:SportsGuide_GetGuide];
    
    [self showLoadingHUD];
    HttpInvokeItem *dataItem = [[HttpInvokeItem alloc] init];
    if ([self respondsToSelector:@selector(getRecipeMegSuccess:)] && [self respondsToSelector:@selector(getRecipeMegFailure:)])
    {
        [dataItem TargetSuper:self Success:@selector(getRecipeMegSuccess:) Failure:@selector(getRecipeMegFailure:)];
    }
    dataItem.dataEncodingType = MKNKPostDataEncodingTypeJSON;
    NSString *path = [NSString stringWithFormat:@"%@?userID=%@",Request_GetExerciseGuide,_useID];
    
    [[HttpInvokeEngine shareHttpInvoke] InvokeHttpMethod:path withParams:nil addFile:nil withMethod:@"GET" InvokeItem:dataItem];
}

- (void)getRecipeMegSuccess:(id)response
{
    [self hideHUD];
    if ([[response objectForKey:@"Result"] intValue] == 1)
    {
        _dataModel = [RecipeModel RIWithInfo:response];
        
        RecipeViewController *controller = [[RecipeViewController alloc] initWithRecipeData:_dataModel];
        [self.navigationController pushViewController:controller animated:YES];
    }
    else
    {
        if([[response objectForKey:@"Message"] length] > 1)
        {
            [self displayErrorHUDWithText:[response objectForKey:@"Message"]];
        }
    }
}

- (void)getRecipeMegFailure:(id)response
{
    [self hideHUD];
    [self displayErrorHUDWithText:@"请稍后再试"];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
