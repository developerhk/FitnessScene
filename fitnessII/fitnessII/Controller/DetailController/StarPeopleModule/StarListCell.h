//
//  StarListCell.h
//  fitnessII
//
//  Created by Jack on 15/11/4.
//  Copyright © 2015年 samples.hankang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "StarModel.h"
#import "StarMainView.h"
#import "StarProgressView.h"

@class StarListCell;
@protocol StarListDelegate <NSObject>

-(void)starCell:(StarListCell *)cell withtag:(int)tag isLock:(BOOL)isLock;

@end

@interface StarListCell : UITableViewCell
@property (nonatomic, assign) id<StarListDelegate> delegate;

@property (nonatomic, strong) IBOutlet StarMainView *mainView;

@property (nonatomic, strong) IBOutlet UIImageView *videoImage;

@property (nonatomic, strong) IBOutlet UILabel *titleLabel;

@property (nonatomic, strong) IBOutlet UIButton *stateBut;

-(void)showMessageWithModel:(StarModel *)model;

@end
