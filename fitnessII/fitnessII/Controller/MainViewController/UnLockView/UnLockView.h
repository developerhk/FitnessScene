//
//  UnLockView.h
//  fitnessII
//
//  Created by Haley on 15/11/23.
//  Copyright (c) 2015年 samples.hankang. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^DisMissBlock) (void);
typedef void (^GoBlock) (void);

@interface UnLockView : UIView
@property (nonatomic, copy) DisMissBlock dmBlock;
@property (nonatomic, copy) GoBlock gBlock;

@property (nonatomic, strong) IBOutlet UIButton *backBut;

@property (nonatomic, strong) IBOutlet UILabel *taskLabel;

@property (nonatomic, strong) IBOutlet UIImageView *actionIV;

@property (nonatomic, strong) IBOutlet UILabel *detailLabel;

@property (nonatomic, strong) IBOutlet UIButton *goBut;

-(void)showMessageWithDic:(NSDictionary *)dic;

@end
