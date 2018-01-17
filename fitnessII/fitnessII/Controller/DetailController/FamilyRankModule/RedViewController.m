//
//  RedViewController.m
//  fitnessII
//
//  Created by Haley on 15/8/10.
//  Copyright (c) 2015年 samples.hankang. All rights reserved.
//

#import "RedViewController.h"
#import "FamilyRankCell.h"
#import "FamilyRankModel.h"
#import "FRankModel.h"
#import "BlueViewController.h"

@interface RedViewController ()<UINavigationControllerDelegate,UIGestureRecognizerDelegate,UITableViewDataSource,UITableViewDelegate>
{
    NSString *_userIder;
    FRankModel *_model;
    
    CGPoint beginPoint;
}
@property (nonatomic, strong) UIPercentDrivenInteractiveTransition *interactivePushTransition;
@property (nonatomic, strong) UIPanGestureRecognizer *panRecognizer;
@end

@implementation RedViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(id)initWithUserID:(NSString *)userID
{
    self = [super init];
    if (self) {
        // Custom initialization
        _userIder = userID;
    }
    return self;
}

-(void)viewWillAppear:(BOOL)animated
{
    self.navigationController.navigationBarHidden = NO;
    [self setNavTitleWithKaiti:@"家庭排名"];
    [self setLeftButtonTitle:nil image:[UIImage imageNamed:@"arrow.png"] target:self selector:@selector(actionBack:)];
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.

    [self requestForFamilyRank];
    
    UIPanGestureRecognizer *ges = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePanRecognizer:)];
    ges.delegate = self;
    [self.bottonLV addGestureRecognizer:ges];
}

-(void)requestForFamilyRank
{
    [self showLoadingHUD];
    HttpInvokeItem *dataItem = [[HttpInvokeItem alloc] init];
    if ([self respondsToSelector:@selector(getFamilyRankSuccess:)] && [self respondsToSelector:@selector(getFamilyRankFailure:)])
    {
        [dataItem TargetSuper:self Success:@selector(getFamilyRankSuccess:) Failure:@selector(getFamilyRankFailure:)];
    }
    dataItem.dataEncodingType = MKNKPostDataEncodingTypeJSON;
    NSString *path = [NSString stringWithFormat:@"%@?userID=%@",Request_GetRankOfFamilyScore ,_userIder];
    
    [[HttpInvokeEngine shareHttpInvoke] InvokeHttpMethod:path withParams:nil addFile:nil withMethod:@"GET" InvokeItem:dataItem];
}

- (void)getFamilyRankSuccess:(id)response
{
    [self hideHUD];
    NSLog(@"%@",[response objectForKey:@"Data"]);
    if ([[response objectForKey:@"Result"] intValue] == 1)
    {
        _model = [FRankModel SZWithInfo:[response objectForKey:@"Data"]];
        self.nodataIV.hidden = YES;
        _tabelView.hidden =  NO;
        self.goldIV.hidden = NO;
        if([_model.dataArray count] == 0)
        {
            self.nodataIV.hidden = NO;
            _tabelView.hidden = YES;
            self.goldIV.hidden =YES;
        
        }
        else if(iPhone4S && [_model.dataArray count] > 2)
        {
            [_scroller setContentSize:CGSizeMake(self.view.bounds.size.width, 518)];
            _bottonLV.frame = CGRectMake(_bottonLV.frame.origin.x, 452, _bottonLV.frame.size.width, _bottonLV.frame.size.height);
        }
        //无论怎样 到这边出了结果  要隐藏过渡页
        self.screenIV.hidden = YES;
        
        [_tabelView reloadData];
    }
    else
    {
        if([[response objectForKey:@"Message"] length] > 1)
        {
            [self displayErrorHUDWithText:[response objectForKey:@"Message"]];
        }
    }
}

- (void)getFamilyRankFailure:(id)response
{
    [self hideHUD];
    [self displayErrorHUDWithText:@"请稍后再试"];
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_model.dataArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"identifier";
    FamilyRankCell *cell = (FamilyRankCell *)[tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[NSBundle mainBundle] loadNibNamed:@"FamilyRankCell" owner:self options:nil][0];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;

    FamilyRankModel *mm = [_model.dataArray objectAtIndex:indexPath.row];
    if(indexPath.row == 0)
    {
        cell.rankLabel.text = [NSString stringWithFormat:@"第 %@ 名",mm.position];
    }
    else
    {
        cell.rankLabel.text = mm.position;

    }
    [cell showMessageWithModel:mm];
    if(mm.isSelf)
    {
        self.scrolNum.text = mm.position;
    }
    return cell;
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 42;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)handlePanRecognizer:(UIPanGestureRecognizer*)recognizer {
    
    //事件统计 家庭排名 滑动提升排名
    [MobClick event:FamilyRank_SlideUp];
    
    static CGFloat startLocationY = 0;
    CGPoint location = [recognizer locationInView:self.view];
    CGFloat progress = (location.y - startLocationY) / [UIScreen mainScreen].bounds.size.width;
    progress = -progress;
    
    progress = MIN(1.0, MAX(0.0, progress));
    
    if (recognizer.state == UIGestureRecognizerStateBegan) {
        NSLog(@"begin - location : %@",NSStringFromCGPoint(location));
        beginPoint = location;
    }
    else if (recognizer.state == UIGestureRecognizerStateChanged) {
        _scroller.frame = CGRectMake(0,-( beginPoint.y - location.y), _scroller.frame.size.width, _scroller.frame.size.height);
    }
    else if (recognizer.state == UIGestureRecognizerStateEnded || recognizer.state == UIGestureRecognizerStateCancelled) {
    NSLog(@"end - location : %@",NSStringFromCGPoint(location));
        if(beginPoint.y - location.y > self.view.bounds.size.height/3)
        {
            //移除本View
            [UIView animateWithDuration:0.3 animations:^{
                //
                _scroller.frame = CGRectMake(0,-_scroller.frame.size.height, _scroller.frame.size.width, _scroller.frame.size.height);
            } completion:^(BOOL finished) {
                //
                //事件统计 家庭排名 进入锻炼转盘页面
                [MobClick event:FamilyRank_SlideSuccess];
                
                NSString *loginUserID = [[NSUserDefaults standardUserDefaults] objectForKey:USERID];
                BlueViewController *cc = [[BlueViewController alloc] initWithTag:11 userID:loginUserID isStudent:NO];
                cc.isFromRedController = YES;
                [cc setBtrBlock:^(void){
                    [UIView animateWithDuration:0.1 animations:^{
                        //
                        _scroller.frame = CGRectMake(0,0, _scroller.frame.size.width, _scroller.frame.size.height);
                    } completion:^(BOOL finished) {
                        //
                        [self requestForFamilyRank];
                    }];
                }];
                [self presentViewController:cc animated:YES completion:^{
                    //
                }];
            }];
        }
        else
        {
            //回原状
            [UIView animateWithDuration:0.3 animations:^{
                //
                _scroller.frame = CGRectMake(0,0, _scroller.frame.size.width, _scroller.frame.size.height);
            } completion:^(BOOL finished) {
                //
            }];

        }
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
