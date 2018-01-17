//
//  RecipeViewController.h
//  fitnessII
//
//  Created by Haley on 15/9/1.
//  Copyright (c) 2015年 samples.hankang. All rights reserved.
//

#import "RootViewController.h"
#import "RecipeModel.h"
#import "RecipeItem.h"
#import "RecipeDetailModel.h"
#import "TYMProgressBarView.h"

@interface RecipeViewController : RootViewController

@property (nonatomic, strong) IBOutlet TYMProgressBarView *progressBar;

@property (nonatomic, strong) IBOutlet TYMProgressBarView *downLoadprogressBar;

@property (nonatomic, strong) IBOutlet UILabel *currentDay;
@property (nonatomic, strong) IBOutlet UILabel *allDay;

@property (nonatomic, strong) IBOutlet UILabel *allTime;
@property (nonatomic, strong) IBOutlet UILabel *allAction;

@property (nonatomic, strong) IBOutlet UIScrollView *scroller;

@property (nonatomic, strong) IBOutlet UIButton *actionBut;

-(id)initWithRecipeData:(RecipeModel *)dataModel;

@end
