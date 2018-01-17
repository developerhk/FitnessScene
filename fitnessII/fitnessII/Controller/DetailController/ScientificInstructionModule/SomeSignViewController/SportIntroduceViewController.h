//
//  SportIntroduceViewController.h
//  fitnessII
//
//  Created by Haley on 15/9/15.
//  Copyright (c) 2015年 samples.hankang. All rights reserved.
//

#import "RootViewController.h"
#import "RecipeItem.h"


@protocol SportIntroduceDelegate <NSObject>

-(void)introduceBackToActionRecipe;

@end

@interface SportIntroduceViewController : RootViewController
@property (nonatomic, assign) id<SportIntroduceDelegate>delegate;

@property (nonatomic, strong) IBOutlet UIImageView *picImageV;
@property (nonatomic, strong) IBOutlet UILabel *titleLab;
@property (nonatomic, strong) IBOutlet UILabel *detailLab;

-(id)initWithRecipeModel:(RecipeItem *)dataModel;
@end
