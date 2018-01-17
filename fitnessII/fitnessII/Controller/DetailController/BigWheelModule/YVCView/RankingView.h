//
//  RankingView.h
//  fitnessII
//
//  Created by Haley on 15/7/12.
//  Copyright (c) 2015年 samples.hankang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RankingView : UIView<UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, strong) NSString *colorT;

@property (nonatomic, strong) IBOutlet UITableView *tableV;

@property (nonatomic, strong) IBOutlet UIView *headView;
@property (nonatomic, strong) IBOutlet UILabel *titleLabel;
@property (nonatomic, strong) IBOutlet UILabel *timeLabel;
@property (nonatomic, strong) IBOutlet UIImageView *lineImageV;
@property (nonatomic, strong) IBOutlet UILabel *bestLabel;

@property (nonatomic, strong) NSMutableArray *dataArray;

-(void)changeColor:(NSString *)colorTag;

@end
