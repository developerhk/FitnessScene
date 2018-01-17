//
//  InstructView.h
//  fitnessII
//
//  Created by Haley on 15/7/14.
//  Copyright (c) 2015年 samples.hankang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface InstructView : UIView

@property (nonatomic, strong) IBOutlet UIImageView *pic;
@property (nonatomic, strong) IBOutlet UILabel *detailLabel;
-(void)showMessageWithTag:(int)tag;

@end
