//
//  CounselViewController.h
//  fitnessII
//
//  Created by Haley on 15/12/9.
//  Copyright (c) 2015年 samples.hankang. All rights reserved.
//

#import "RootViewController.h"
#import "StarListCell.h"

@interface CounselViewController : RootViewController<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, strong) IBOutlet UITableView *tableView;

-(id)initWithUserID:(NSString *)userID;

@end
