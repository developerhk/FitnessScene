//
//  StarHeaderCell.h
//  fitnessII
//
//  Created by Jack on 15/11/4.
//  Copyright © 2015年 samples.hankang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "StarZoneModel.h"

typedef void (^StarHeaderBlock) (void);

@interface StarHeaderCell : UITableViewCell

@property (nonatomic, copy) StarHeaderBlock headerBlock;

@property (nonatomic, strong) IBOutlet UILabel *topicName;

@property (nonatomic, retain) IBOutlet UIImageView *headerIV;

@property (nonatomic, retain) IBOutlet UILabel *detailLabel;

@property (nonatomic, retain) IBOutlet UIButton *detailBut;

-(void)showMeassageWithModel:(StarZoneModel*)model;

@end
