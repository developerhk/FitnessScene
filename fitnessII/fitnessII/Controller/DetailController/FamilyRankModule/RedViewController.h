//
//  RedViewController.h
//  fitnessII
//
//  Created by Haley on 15/8/10.
//  Copyright (c) 2015年 samples.hankang. All rights reserved.
//

#import "RootViewController.h"
#import "BlueViewController.h"

@interface RedViewController : RootViewController

@property (nonatomic, strong) IBOutlet UIImageView *screenIV;

@property (nonatomic, strong) IBOutlet UIScrollView *scroller;
@property (nonatomic, strong) IBOutlet UITableView *tabelView;

@property (nonatomic, strong) IBOutlet UILabel *scrolNum;
@property (nonatomic, strong) IBOutlet UIImageView *bottonLV;

@property (nonatomic, strong) IBOutlet UIImageView *goldIV;
@property (nonatomic, strong) IBOutlet UIImageView *nodataIV;

-(id)initWithUserID:(NSString *)userID;

@end
