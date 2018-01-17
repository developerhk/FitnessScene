//
//  StarPeopleViewController.h
//  fitnessII
//
//  Created by Jack on 15/11/4.
//  Copyright © 2015年 samples.hankang. All rights reserved.
//

#import "RootViewController.h"
#import "StarHeaderCell.h"
#import "StarListCell.h"


@interface StarPeopleViewController : RootViewController<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, strong) NSString *childID;

@property (nonatomic, strong) IBOutlet UITableView *tableView;

@end
