//
//  BlueViewController.h
//  fitnessII
//
//  Created by Haley on 15/7/12.
//  Copyright (c) 2015年 samples.hankang. All rights reserved.
//

#import "RootViewController.h"
#import "OverView.h"
#import "RankingView.h"
#import "BlueSPView.h"
#import "InstructView.h"
#import "BlackGroundView.h"

typedef void (^BlueToRedBlock) (void);

@interface BlueViewController : RootViewController<UIScrollViewDelegate,UICollectionViewDataSource, UICollectionViewDelegate,BlackGroundViewDelegate>
@property (nonatomic, assign) BOOL isFromRedController;
@property (nonatomic, copy) BlueToRedBlock btrBlock;

@property (nonatomic, strong) IBOutlet UIScrollView *rootScroler;
@property (nonatomic, strong) IBOutlet UICollectionView *collectionView;

@property (nonatomic, strong) IBOutlet UIImageView *arrIv;
@property (nonatomic, strong) IBOutlet UIScrollView *overView;

@property (nonatomic, strong) IBOutlet UIButton *goBut;

@property (nonatomic, strong) IBOutlet UIImageView *circleImage;

@property (nonatomic, strong) IBOutlet UIPageControl *pageControl;

- (id)initWithTag:(int)tag userID:(NSString *)userID isStudent:(BOOL)isStud;

@end
