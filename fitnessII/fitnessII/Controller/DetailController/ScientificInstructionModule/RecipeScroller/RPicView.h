//
//  RPicView.h
//  fitnessII
//
//  Created by Haley on 15/9/14.
//  Copyright (c) 2015年 samples.hankang. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^RPicViewBlock) (void);

@interface RPicView : UIView
@property (nonatomic, copy) RPicViewBlock rPicViewBlock;

@property (nonatomic, strong) IBOutlet UIImageView *backImageView;
@property (nonatomic, strong) IBOutlet UILabel *titleName;
@property (nonatomic, strong) IBOutlet UILabel *numberLabel;

@end
