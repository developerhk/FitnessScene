//
//  CounselHeaderCell.h
//  fitnessII
//
//  Created by Haley on 16/4/8.
//  Copyright © 2016年 samples.hankang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CounselModel.h"

@interface CounselHeaderCell : UITableViewCell

@property (nonatomic, strong) IBOutlet UILabel *topicName;

@property (nonatomic, strong) IBOutlet UIImageView *headerIV;

@property (nonatomic, strong) IBOutlet UILabel *detailLabel;

-(void)showMeassageWithModel:(CounselModel*)model;

@end
