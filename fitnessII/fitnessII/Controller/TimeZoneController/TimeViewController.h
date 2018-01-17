//
//  TimeViewController.h
//  fitnessII
//
//  Created by Haley on 15/7/6.
//  Copyright (c) 2015年 samples.hankang. All rights reserved.
//

#import "RootViewController.h"
#import "PullTableView.h"

@protocol TimeDelegate <NSObject>

-(void)changeTimeSign;

@end

@interface TimeViewController : RootViewController<UITableViewDataSource,UITableViewDelegate,PullTableViewDataSource,PullTableViewDelegate>

@property (nonatomic, assign) id<TimeDelegate> delegate;
@property (nonatomic, strong) IBOutlet PullTableView *tableView;

@end
