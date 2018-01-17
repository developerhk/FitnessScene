//
//  YellowViewController.m
//  fitnessII
//
//  Created by Haley on 15/7/12.
//  Copyright (c) 2015年 samples.hankang. All rights reserved.
//

#import "YellowViewController.h"
#import "AWCollectionViewDialLayout.h"

@interface YellowViewController ()
{
    int currentIndex;

    NSMutableArray *icons;
    NSMutableArray *normalImages;
    NSMutableArray *selectedImages;

    AWCollectionViewDialLayout *dialLayout;

    NSInteger selIndex; //当前的tag，进来是0
    
    //
    int projectID;
    int comeinIndex;
    BOOL isYellow;
    
    NSString *_currentUserID;
    
    NSString *_currentScore;
    
    //做全局
    RankingView *_rView;   //
    RankingView *_rViewF;  //体重专用
    OverView *_aView;
    InstructView *_iView;
}

@end

static NSString *cellId = @"cellId";
static NSString *cellId2 = @"cellId2";

@implementation YellowViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
    }
    return self;
}


- (id)initWithTag:(int)tag userID:(NSString *)userID
{
    self = [super init];
    if (self) {
        // Custom initialization
        _currentUserID = userID;
        comeinIndex = tag-3;
        projectID = [self getProjectIDWithTag:tag];
    }
    return self;
}

#pragma mark - HTTPRequest
-(void)requestForHisByUserID:(NSString *)userID projectID:(NSString *)pID
{
    [self showLoadingHUD];
    HttpInvokeItem *dataItem = [[HttpInvokeItem alloc] init];
    if ([self respondsToSelector:@selector(historySuccess:)] && [self respondsToSelector:@selector(historyFailure:)])
    {
        [dataItem TargetSuper:self Success:@selector(historySuccess:) Failure:@selector(historyFailure:)];
    }
    dataItem.dataEncodingType = MKNKPostDataEncodingTypeJSON;
    NSString *path = [NSString stringWithFormat:@"%@?userID=%@&programID=%@", Request_GetHisByProgramID,userID,pID];
    
    [[HttpInvokeEngine shareHttpInvoke] InvokeHttpMethod:path withParams:nil addFile:nil withMethod:@"GET" InvokeItem:dataItem];
}

- (void)historySuccess:(id)response
{
    [self hideHUD];
    NSLog(@"%@",[response objectForKey:@"Data"]);
    if ([[response objectForKey:@"Result"] intValue] == 1)
    {
        _rView.dataArray = [response objectForKey:@"Data"];
        if(projectID == 1)
        {
            //BMI
            _rView.timeLabel.hidden = YES;
            _rView.titleLabel.hidden = NO;
            _rView.lineImageV.hidden = YES;
            _rView.titleLabel.text = @"BMI(体质指数)";
            if([_rView.dataArray count] > 0)
            {
                //有数据
                _rView.bestLabel.hidden = YES;
            }
            else
            {
                _rView.bestLabel.hidden = NO;
                _rView.bestLabel.text = @"无";
            }
            [_rView.tableV reloadData];
        }
        //身高 体重
        else if(projectID == 99)
        {
            _rViewF.timeLabel.hidden = YES;
            _rViewF.titleLabel.hidden = NO;
            _rViewF.lineImageV.hidden = YES;
            _rViewF.bestLabel.hidden = NO;
            _rViewF.titleLabel.text = @"体重";
            
            _rViewF.dataArray = [response objectForKey:@"Data"];
            if([_rViewF.dataArray count] > 0)
            {
                //有数据
                _rViewF.bestLabel.hidden = YES;
            }
            else
            {
                _rViewF.bestLabel.hidden = NO;
                _rViewF.bestLabel.text = @"无";
            }
            [_rViewF.tableV reloadData];
            return;
        }
        else if(projectID == 98)
        {
            _rView.timeLabel.hidden = YES;
            _rView.titleLabel.hidden = NO;
            _rView.lineImageV.hidden = YES;
            _rView.bestLabel.hidden = NO;
            _rView.titleLabel.text = @"身高";
            _rView.dataArray = [response objectForKey:@"Data"];
            if([_rView.dataArray count] > 0)
            {
                //有数据
                _rView.bestLabel.hidden = YES;
            }
            else
            {
                _rView.bestLabel.hidden = NO;
                _rView.bestLabel.text = @"无";
            }
            [_rView.tableV reloadData];
            return;
        }
        else
        {
            _rView.timeLabel.hidden = NO;
            _rView.titleLabel.hidden = NO;
            _rView.lineImageV.hidden = NO;
            _rView.bestLabel.hidden = NO;
            _rView.titleLabel.text = @"个人最佳纪录";
            if([[response objectForKey:@"TopScoreTime"] length] < 1)
            {
                //没有时间 则肯定没有锻炼过
                _rView.timeLabel.text = [NSString stringWithFormat:@"(%@)", @"无"];
                
                _rView.bestLabel.text = @"无";
            }
            else
            {
                _rView.timeLabel.text = [NSString stringWithFormat:@"(%@)", [response objectForKey:@"TopScoreTime"]];
                
                _rView.bestLabel.text = [response objectForKey:@"TopScore"];
            }
            [_rView.tableV reloadData];
        }

        if([_rView.dataArray count] > 0)
        {
            _currentScore = [self findNumFromStr:[[_rView.dataArray objectAtIndex:0] objectForKey:@"Score"]];
        }
        else
        {
            _currentScore = @"0";
        }
    }
    else
    {
        if([[response objectForKey:@"Message"] length] > 1)
        {
            [self displayErrorHUDWithText:[response objectForKey:@"Message"]];
        }
    }
}
#pragma mark - 在str中找数字
-(NSString *)findNumFromStr:(NSString *)str
{
    NSMutableString *numberString = [[NSMutableString alloc] init];
    NSString *tempStr;
    NSScanner *scanner = [NSScanner scannerWithString:str];
    NSCharacterSet *numbers = [NSCharacterSet characterSetWithCharactersInString:@"0123456789."];
    
    while (![scanner isAtEnd]) {
        // Throw away characters before the first number.
        [scanner scanUpToCharactersFromSet:numbers intoString:NULL];
        
        // Collect numbers.
        [scanner scanCharactersFromSet:numbers intoString:&tempStr];
        [numberString appendString:tempStr];
        tempStr = @"";
    }
    
    return numberString;
}

- (void)historyFailure:(id)response
{
    [self hideHUD];
    [self displayErrorHUDWithText:@"请稍后再试"];
}
//*********************//
-(void)requestForRankOfStudentID:(NSString *)userID projectID:(NSString *)pID
{
    [self showLoadingHUD];
    HttpInvokeItem *dataItem = [[HttpInvokeItem alloc] init];
    if ([self respondsToSelector:@selector(rankOfStudentSuccess:)] && [self respondsToSelector:@selector(rankOfStudentFailure:)])
    {
        [dataItem TargetSuper:self Success:@selector(rankOfStudentSuccess:) Failure:@selector(rankOfStudentFailure:)];
    }
    dataItem.dataEncodingType = MKNKPostDataEncodingTypeJSON;
    NSString *path = [NSString stringWithFormat:@"%@?userID=%@&programID=%@", Request_GetRankOfStudent,userID,pID];
    
    [[HttpInvokeEngine shareHttpInvoke] InvokeHttpMethod:path withParams:nil addFile:nil withMethod:@"GET" InvokeItem:dataItem];
}

- (void)rankOfStudentSuccess:(id)response
{
    [self hideHUD];
    NSLog(@"%@",[response objectForKey:@"Data"]);
    if ([[response objectForKey:@"Result"] intValue] == 1)
    {
        if(projectID == 1)
        {
            _aView.guoBIV.image = [UIImage imageNamed:@"biaozhun2.png"];
            NSDictionary *dd = [response objectForKey:@"Degree"];
            [_aView showMessageWithDegree:dd currentScore:_currentScore isBMI:YES];

        }
        else
        {
            _aView.guoBIV.image = [UIImage imageNamed:@"biaozhun1.png"];
            NSDictionary *dd = [response objectForKey:@"Degree"];
            [_aView showMessageWithDegree:dd currentScore:_currentScore isBMI:NO];

        }

        [_aView showMessageWithRank:[response objectForKey:@"Rank"]];
    }
    else
    {
        _aView.colorType.hidden = YES;
        [_aView showMessageWithRank:[response objectForKey:@"Rank"]];
        if([[response objectForKey:@"Message"] length] > 1)
        {
            [self displayErrorHUDWithText:[response objectForKey:@"Message"]];
        }
    }
}

- (void)rankOfStudentFailure:(id)response
{
    [self hideHUD];
    [self displayErrorHUDWithText:@"请稍后再试"];
}
//*********************//
-(void)requestForUploadScore:(NSString *)userID projectID:(NSString *)pID score:(NSString *)score duration:(NSString *)dur
{
    [self showLoadingHUD];
    HttpInvokeItem *dataItem = [[HttpInvokeItem alloc] init];
    if ([self respondsToSelector:@selector(uploadScoreSuccess:)] && [self respondsToSelector:@selector(uploadScoreFailure:)])
    {
        [dataItem TargetSuper:self Success:@selector(uploadScoreSuccess:) Failure:@selector(uploadScoreFailure:)];
    }
    dataItem.dataEncodingType = MKNKPostDataEncodingTypeJSON;
    NSString *path = [NSString stringWithFormat:@"%@?userID=%@&programID=%@&score=%@&duration=%@&type=%@", Request_AddActivityInfoOfMobile,userID,pID,score,dur,@"T"];
    
    [[HttpInvokeEngine shareHttpInvoke] InvokeHttpMethod:path withParams:nil addFile:nil withMethod:@"GET" InvokeItem:dataItem];
}

- (void)uploadScoreSuccess:(id)response
{
    [self hideHUD];
    NSLog(@"%@",[response objectForKey:@"Data"]);
    if ([[response objectForKey:@"Result"] intValue] == 1)
    {
        [self displayErrorHUDWithText:[response objectForKey:@"Message"]];
    }
    else
    {
        if([[response objectForKey:@"Message"] length] > 1)
        {
            [self displayErrorHUDWithText:[response objectForKey:@"Message"]];
        }
    }
}

- (void)uploadScoreFailure:(id)response
{
    [self hideHUD];
    [self displayErrorHUDWithText:@"请稍后再试"];
}

#pragma mark - HTTPRequest
-(int)getProjectIDWithTag:(int)tag
{
    switch (tag) {
        case 4:
        {
            isYellow = YES;
            return 98;
        }
            break;
        case 5:
        {
            isYellow = YES;
            return 1;
        }
            break;
        case 6:
        {
            isYellow = YES;
            return 3;
        }
            break;
        case 7:
        {
            isYellow = YES;
            return 2;
        }
            break;
        case 8:
        {
            isYellow = YES;
            return 5;
        }
            break;
        case 9:
        {
            isYellow = YES;
            return 4;
        }
            break;
        case 10:
        {
            isYellow = YES;
            return 8;
        }
            break;
        case 11:
        {
            return 103;
        }
            break;
        case 12:
        {
            return 101;
        }
            break;
        case 13:
        {
            return 102;
        }
            break;
        case 14:
        {
            return 100;
        }
            break;
            
        default:
            break;
    }
    return 0;
}

- (IBAction)actionBack:(id)sender {
    self.navigationController.navigationBarHidden = NO;
    UIImage *image = [[UIImage imageNamed:@"navigationBar_background-7.png"] stretchableImageWithLeftCapWidth:1 topCapHeight:0];
    [self.navigationController.navigationBar setBackgroundImage:image forBarMetrics:UIBarMetricsDefault];
    [self.navigationController popViewControllerAnimated:YES];
}

//解决在使用AutoLayout UIScrollView不能滚动
- (void)viewDidLayoutSubviews
{
    if(iPhone4S)
    {
        self.rootScroler.contentSize = CGSizeMake(self.rootScroler.frame.size.width, _rootScroler.frame.size.height +35);
    }
}

-(void)layoutForHeightAndWeight
{
    for (UIView *vv in _overView.subviews) {
        if([vv isKindOfClass:[RankingView class]])
        {
            [vv removeFromSuperview];
        }
        if([vv isKindOfClass:[OverView class]])
        {
            [vv removeFromSuperview];
        }
    }
    
    NSArray *nnibContents = [[NSBundle mainBundle] loadNibNamed:@"RankV" owner:nil options:nil];
    _rView = (RankingView *)[nnibContents objectAtIndex:0];
    _rView.frame = CGRectMake(0, 0, _rView.frame.size.width, _rView.frame.size.height);
    [_overView addSubview:_rView];
    
    NSArray *nibContents = [[NSBundle mainBundle] loadNibNamed:@"RankV" owner:nil options:nil];
    _rViewF = (RankingView *)[nibContents objectAtIndex:0];
    _rViewF.frame = CGRectMake(_overView.frame.size.width, 0, _rViewF.frame.size.width, _rViewF.frame.size.height);
    [_overView addSubview:_rViewF];
    
}

-(void)layoutForOther
{
    for (UIView *vv in _overView.subviews) {
        if([vv isKindOfClass:[RankingView class]])
        {
            [vv removeFromSuperview];
        }
        if([vv isKindOfClass:[OverView class]])
        {
            [vv removeFromSuperview];
        }
    }
    
    NSArray *nnibContents = [[NSBundle mainBundle] loadNibNamed:@"RankV" owner:nil options:nil];
    _rView = (RankingView *)[nnibContents objectAtIndex:0];
    _rView.frame = CGRectMake(0, 0, _rView.frame.size.width, _rView.frame.size.height);
    [_overView addSubview:_rView];
    
    NSArray *nibContents = [[NSBundle mainBundle] loadNibNamed:@"OverV" owner:nil options:nil];
    _aView = (OverView *)[nibContents objectAtIndex:0];
    _aView.frame = CGRectMake(_overView.frame.size.width, 0, _aView.frame.size.width, _aView.frame.size.height);
    [_overView addSubview:_aView];
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationController.navigationBarHidden = YES;

    [_overView setContentSize:CGSizeMake(isYellow?_overView.frame.size.width*2:_overView.frame.size.width*3, _overView.frame.size.height)];
    
    currentIndex = 1;
    
//    NSArray *nnibContents = [[NSBundle mainBundle] loadNibNamed:@"RankV" owner:nil options:nil];
//    _rView = (RankingView *)[nnibContents objectAtIndex:0];
//    _rView.frame = CGRectMake(0, 0, _rView.frame.size.width, _rView.frame.size.height);
//    [_overView addSubview:_rView];
//    
//    NSArray *nibContents = [[NSBundle mainBundle] loadNibNamed:@"OverV" owner:nil options:nil];
//    _aView = (OverView *)[nibContents objectAtIndex:0];
//    _aView.frame = CGRectMake(_overView.frame.size.width, 0, _aView.frame.size.width, _aView.frame.size.height);
//    [_overView addSubview:_aView];
    
    selIndex = 0;

    [_collectionView registerNib:[UINib nibWithNibName:@"dialCell" bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:cellId];
    
    CGFloat radius =0;
    CGFloat angularSpacing =0;
    CGFloat xOffset =0;
    CGFloat cell_width = 65;
    CGFloat cell_height = 65;
    
    dialLayout = [[AWCollectionViewDialLayout alloc] initWithRadius:radius andAngularSpacing:angularSpacing andCellSize:CGSizeMake(cell_width, cell_height) andAlignment:WHEELALIGNMENTCENTER andItemHeight:cell_height andXOffset:xOffset];

    [_collectionView setCollectionViewLayout:dialLayout];
    
    _collectionView.transform = CGAffineTransformMakeRotation(-M_PI_2);
    
    icons = [[NSMutableArray alloc]init];
    normalImages = [[NSMutableArray alloc]init];
    selectedImages = [[NSMutableArray alloc]init];
    for (int i = 1; i < 8; i++) {
        NSString *normalImageName = [NSString stringWithFormat:@"normalIcon_%d",i];
        NSString *selImageName = [NSString stringWithFormat:@"selIcon_%d",i];
        
        UIImage *normalImage = [UIImage imageNamed:normalImageName];
        UIImage *selImage = [UIImage imageNamed:selImageName];
        
        if (!normalImage) {
            normalImage = [[UIImage alloc]init];
        }
        if (!selImage) {
            selImage = [[UIImage alloc]init];
        }
        
        [normalImages addObject:normalImage];
        [selectedImages addObject:selImage];
    }
    [self switchExample];
    
    [self performSelector:@selector(scrolToIndex) withObject:nil afterDelay:0.2];
}

-(void)scrolToIndex
{
    NSInteger index = [self scrollToStopPosition];
    int indx  = [[NSString stringWithFormat:@"%ld",(long)index] intValue];
    if(indx == 0)
    {
        //第一项不会触发 scorller的delegate  从而不会请求
        [self changeAttributeForZone:indx];
        [self didStopAtIndex:index];
    }
    [_collectionView scrollRectToVisible:CGRectMake(0, 65*(comeinIndex - 1), _collectionView.frame.size.width, _collectionView.frame.size.height) animated:YES];

}

-(void)actionLandR:(int)sender
{
    switch (sender) {
        case 1:
        {
            _goBut.hidden = YES;
            _goBut.userInteractionEnabled = NO;
            if(!isYellow)
            {
                _circleImage.image = [UIImage imageNamed:@"circle-blueNo.png"];

            }
            else
            {
                _circleImage.image = [UIImage imageNamed:@"circleNil.png"];
            }
        }
            break;
        case 2:
        {
            _goBut.hidden = YES;
            _goBut.userInteractionEnabled = NO;
            if(!isYellow)
            {
                _circleImage.image = [UIImage imageNamed:@"circle-blueNo.png"];

            }
            else
            {
                _circleImage.image = [UIImage imageNamed:@"circleNil.png"];
            }
        }
            break;
        case 3:
        {
            if(!isYellow)
            {
                _circleImage.image = [UIImage imageNamed:@"circle-blue.png"];
                [_iView showMessageWithTag:[self scrollToStopPosition]-6];
                _goBut.hidden = NO;
                _goBut.userInteractionEnabled = YES;
            }
        }
            break;
            
        default:
            break;
    }
}

#pragma mark - BlackGroundViewDelegate
-(void)closeBlackGroundView:(BlackGroundView *)view score:(NSString *)score duration:(NSString *)dur
{
    //关闭屏幕常亮
    [[UIApplication sharedApplication] setIdleTimerDisabled:NO];
    
    [UIView animateWithDuration:0.3 animations:^{
        //
        [view removeFromSuperview];
        [[UIApplication sharedApplication] setStatusBarOrientation:UIInterfaceOrientationPortrait];
        [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationSlide];
        view.transform = CGAffineTransformMakeRotation(0);

    } completion:^(BOOL finished) {
        //
        //逻辑 － 1:发请求提交数据 2
        NSString *pID = [NSString stringWithFormat:@"%d",projectID];
        [self requestForUploadScore:_currentUserID projectID:pID score:score duration:dur];
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*************************************************/
-(void)changeAttributeForZone:(int)index
{
    _goBut.hidden = YES;
    _goBut.userInteractionEnabled = NO;
    //逻辑 － 每次球之间的切换  先请求历史记录
    projectID = [self getProjectIDWithTag:index+4];
    NSString *pID = [NSString stringWithFormat:@"%d",projectID];
    if(projectID == 98)
    {
        [self layoutForHeightAndWeight];
        [_rViewF changeColor:@"Y"];
        [self requestForHisByUserID:_currentUserID projectID:pID];
    }
    else
    {
        [self layoutForOther];
        [self requestForHisByUserID:_currentUserID projectID:pID];
    }

    currentIndex = 1;
    
    isYellow = YES;
    _circleImage.image = [UIImage imageNamed:@"circleNil.png"];
    _arrIv.image = [UIImage imageNamed:@"sanjiao.png"];
    [_rView changeColor:@"Y"];
    [_aView changeColor:@"Y"];
    
    _pageControl.numberOfPages = 2;
    _pageControl.currentPageIndicatorTintColor = UIColorFromRGB(0x39a874);
    [_pageControl setCurrentPage:currentIndex-1];

    [_overView setContentSize:CGSizeMake(isYellow?_overView.frame.size.width*2:_overView.frame.size.width*3, _overView.frame.size.height)];
    //从历史开始

    [_overView scrollRectToVisible:CGRectMake(0, 0, _overView.frame.size.width, _overView.frame.size.height) animated:YES];
}

-(void)switchExample{
    [dialLayout setWheelType:WHEELALIGNMENTLEFT];

    [dialLayout setDialRadius:175];
    
    [dialLayout setAngularSpacing:18];
    
    [dialLayout setXOffset:90];
    
    [_collectionView reloadData];
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return normalImages.count;
}

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}


-(UICollectionViewCell *)collectionView:(UICollectionView *)cv cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    UICollectionViewCell *cell;
    if(cell==nil)
    {
        cell = [cv dequeueReusableCellWithReuseIdentifier:cellId forIndexPath:indexPath];
    }

    UIImageView *imgView = (UIImageView*)[cell viewWithTag:100];
    imgView.backgroundColor = [UIColor clearColor];
    imgView.layer.masksToBounds = YES;
    imgView.transform = CGAffineTransformMakeRotation(M_PI_2);
    imgView.image = normalImages[indexPath.item];
    
    if (![icons containsObject:imgView]) {
        [icons addObject:imgView];
        
        if (indexPath.item == 0) {
            imgView.image = selectedImages[0];
        }
    }
    
    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView didEndDisplayingCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"didEndDisplayingCell:%i", (int)indexPath.item);
}

#pragma mark ------------------关键方法
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
//    [self changeAttributeForZone:indexPath.row];  //此处注掉是因为当点击转盘某项时  与scrollViewDidEndScrollingAnimation 重复请求
    [collectionView scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionCenteredVertically animated:YES];
    [self setImagesAfterScrollOrSelect:indexPath];
    [self didStopAtIndex:indexPath.item];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if(scrollView.tag == 10000)
    {
        return;
    }
    else
    {
        NSInteger index = [self scrollToStopPosition];
        [self changeAttributeForZone:index];
        [self didStopAtIndex:index];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if(scrollView.tag == 10000)
    {
        //发请求
        NSString *pID = [NSString stringWithFormat:@"%d",projectID];
        if(scrollView.contentOffset.x == 0)
        {
            currentIndex = 1;
            [self actionLandR:currentIndex];

            //埋点统计 7项个人记录
            [MobClick event:NationalSports_ShowHistory attributes:@{@"Prj" : [NSString stringWithFormat:@"%d",projectID]}];
            
            if(projectID == 99)
            {
                [self requestForHisByUserID:_currentUserID projectID:@"98"];
                projectID = 98;
            }
            else
            {
                [self requestForRankOfStudentID:_currentUserID projectID:pID];
            }
        }
        else if(scrollView.contentOffset.x == scrollView.frame.size.width)
        {
            currentIndex = 2;
            [self actionLandR:currentIndex];
         
            //埋点统计 7项个人排名
            [MobClick event:NationalSports_ShowRank attributes:@{@"Prj" : [NSString stringWithFormat:@"%d",projectID]}];
            
            if(projectID == 98)
            {
                [self requestForHisByUserID:_currentUserID projectID:@"99"];
                projectID = 99;
            }
            else
            {
                [self requestForRankOfStudentID:_currentUserID projectID:pID];
            }
        }
        else
        {
            currentIndex = 3;
            [self actionLandR:currentIndex];
        }
        [_pageControl setCurrentPage:currentIndex-1];
    }
    else
    {
        NSInteger index = [self scrollToStopPosition];
        [self changeAttributeForZone:index];
        [self didStopAtIndex:index];
    }
}

-(void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
    /****/
    if(scrollView.tag == 10000)
    {
        return;
    }
    else
    {
        NSInteger index = [self scrollToStopPosition];
        [self changeAttributeForZone:index];
        [self didStopAtIndex:index];
    }
    /****/
}

//
-(void)didStopAtIndex:(NSInteger )currentInd
{
    selIndex = currentInd;
}

-(NSInteger )scrollToStopPosition
{
    NSArray *visibleCells = [_collectionView visibleCells];
    
    NSArray *sortedCells = [visibleCells sortedArrayUsingComparator:^NSComparisonResult(UICollectionViewCell *obj1, UICollectionViewCell *obj2) {
        CGRect frame1 = [_collectionView convertRect:obj1.frame toView:self.view];
        CGRect frame2 = [_collectionView convertRect:obj2.frame toView:self.view];
        
        CGFloat distanceToCenter1 = fabs(frame1.origin.x + frame1.size.height / 2 - self.view.frame.size.width / 2);
        CGFloat distanceToCenter2 = fabs(frame2.origin.x + frame2.size.height / 2 - self.view.frame.size.width / 2);
        if (distanceToCenter1 > distanceToCenter2) {
            return NSOrderedDescending;
        }
        else{
            return NSOrderedAscending;
        }
    }];
    
    UICollectionViewCell *selectedCell = sortedCells[0];
    
    [_collectionView scrollToItemAtIndexPath:[_collectionView indexPathForCell:selectedCell] atScrollPosition:UICollectionViewScrollPositionCenteredVertically animated:NO];
    
    
    NSIndexPath *indexPath = [_collectionView indexPathForCell:selectedCell];
    
    //设置图片
    [self setImagesAfterScrollOrSelect:indexPath];
    
    return indexPath.item;
}

-(void)setImagesAfterScrollOrSelect:(NSIndexPath *)selIndexPath;
{
    NSArray *visibleCells = [_collectionView visibleCells];
    [visibleCells enumerateObjectsUsingBlock:^(UICollectionViewCell *obj, NSUInteger idx, BOOL *stop) {
        NSIndexPath *indexPath = [_collectionView indexPathForCell:obj];
        UIImageView *imageView = (UIImageView *)[obj viewWithTag:100];
        UIImage *image = normalImages[indexPath.item];
        imageView.image = image;
    }];
    
    UICollectionViewCell *cell = [_collectionView cellForItemAtIndexPath:selIndexPath];
    UIImageView *imageView = (UIImageView *)[cell viewWithTag:100];
    imageView.image = selectedImages[selIndexPath.item];
    
}

#pragma mark - UICollectionViewDelegate methods
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(54, 54);
}


- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(0 , 0, 0, 0);
}

/*************************************************/
@end
