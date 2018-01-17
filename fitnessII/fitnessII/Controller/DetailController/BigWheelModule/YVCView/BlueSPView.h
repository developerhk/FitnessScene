//
//  BlueSPView.h
//  fitnessII
//
//  Created by Haley on 15/8/11.
//  Copyright (c) 2015年 samples.hankang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BlueSPView : UIView
@property (nonatomic, strong) IBOutlet UILabel *rankS;
@property (nonatomic, strong) IBOutlet UILabel *myScoreS;
@property (nonatomic, strong) IBOutlet UILabel *bestScoreS;

@property (nonatomic, strong) IBOutlet UILabel *rankL;
@property (nonatomic, strong) IBOutlet UILabel *myScoreL;
@property (nonatomic, strong) IBOutlet UILabel *bestScoreL;

-(void)showMessageWithRank:(NSArray *)dataArr;
@end
