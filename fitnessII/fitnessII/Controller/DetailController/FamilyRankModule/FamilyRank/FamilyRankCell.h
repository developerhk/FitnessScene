//
//  FamilyRankCell.h
//  fitnessII
//
//  Created by Haley on 15/11/20.
//  Copyright (c) 2015年 samples.hankang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FamilyRankModel.h"

@interface FamilyRankCell : UITableViewCell

@property (nonatomic, strong) IBOutlet UILabel *rankLabel;
@property (nonatomic, strong) IBOutlet UILabel *nameLabel;
@property (nonatomic, strong) IBOutlet UILabel *scoreLabel;

-(void)showMessageWithModel:(FamilyRankModel *)model;
@end
