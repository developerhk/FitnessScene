//
//  BlackGroundView.h
//  fitnessII
//
//  Created by Haley on 15/7/14.
//  Copyright (c) 2015年 samples.hankang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DataLogger.h"

@class BlackGroundView;
@protocol BlackGroundViewDelegate <NSObject>

-(void)closeBlackGroundView:(BlackGroundView *)view score:(NSString *)score duration:(NSString *)dur;

@end

@interface BlackGroundView : UIView<XYZDelegate>
{
    DataLogger *_myDataLogger;
    BOOL iskk;
    BOOL isJJ;
    float begin;
    float end;
    
    CGPoint beginPoint;
    
    int countNum;
    
    NSTimer *_timeKit;
    
    
}
@property (nonatomic, retain) id observe;
@property (nonatomic, strong) NSString *actionNumber;
@property (nonatomic, strong) NSString *formWhere;

@property (nonatomic, assign) int timeNumber;
@property (nonatomic, assign) id <BlackGroundViewDelegate> delegate;

@property (nonatomic, strong) IBOutlet UIImageView *circleIV;
@property (nonatomic, strong) IBOutlet UILabel *timeLabel;
@property (nonatomic, strong) IBOutlet UILabel *nameLabel;

@property (nonatomic, strong) IBOutlet UIView *sliderView;
@property (nonatomic, strong) IBOutlet UIImageView *sliderBackIV;
@property (nonatomic, strong) IBOutlet UIImageView *sliderIV;

@property (nonatomic, strong) IBOutlet UIImageView *faceIV;

-(void)timeFire;

@end
