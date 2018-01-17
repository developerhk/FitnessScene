//
//  ContiuneViewController.h
//  fitnessII
//
//  Created by Haley on 15/9/15.
//  Copyright (c) 2015年 samples.hankang. All rights reserved.
//

#import "RootViewController.h"

typedef enum{
    HK_Contiune = 0,     //继续
    HK_Sleep    = 1,     //休息30秒
    HK_Complete = 2      //完成训练
}HKSignType;

@protocol ContiuneDelegate <NSObject>

-(void)sleepBackForRestartFire;

-(void)contiuneBackForRestartFire;

@end

@interface ContiuneViewController : RootViewController
@property (nonatomic, assign) id<ContiuneDelegate> delegate;
@property (nonatomic, assign) HKSignType signType;
@property (nonatomic, retain) NSMutableDictionary *dataDic;

//公用
@property (nonatomic, strong) IBOutlet UILabel *signLabel;
//继续训练
@property (nonatomic, strong) IBOutlet UIButton *contiuneBut;

//休息30
@property (nonatomic, strong) IBOutlet UILabel *timeLabel;

//完成训练
@property (nonatomic, strong) IBOutlet UILabel *rewardsLabel;
@property (nonatomic, strong) IBOutlet UIButton *nextBut;

-(id)initWithHKSignType:(HKSignType)type timeCount:(NSString *)count;

@end
