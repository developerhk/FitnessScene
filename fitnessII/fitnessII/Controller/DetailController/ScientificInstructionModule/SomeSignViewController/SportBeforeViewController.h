//
//  SportBeforeViewController.h
//  fitnessII
//
//  Created by Haley on 15/9/17.
//  Copyright (c) 2015年 samples.hankang. All rights reserved.
//

#import "RootViewController.h"
#import "RecipeItem.h"

@interface SportBeforeViewController : RootViewController
@property (nonatomic, strong) IBOutlet UIImageView *picImageV;
@property (nonatomic, strong) IBOutlet UILabel *titleLab;

@property (nonatomic, strong) IBOutlet UILabel *detailLabel;
@property (nonatomic, strong) IBOutlet UIScrollView *detailScl;

@property (nonatomic, strong) IBOutlet UILabel *sportPart;
@property (nonatomic, strong) IBOutlet UIImageView *starsIV;

-(id)initWithRecipeModel:(RecipeItem *)dataModel;
@end
