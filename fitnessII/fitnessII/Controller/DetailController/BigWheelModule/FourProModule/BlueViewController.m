//
//  BlueViewController.m
//  fitnessII
//
//  Created by Haley on 15/7/12.
//  Copyright (c) 2015年 samples.hankang. All rights reserved.
//

#import "BlueViewController.h"
#import "AWCollectionViewDialLayout.h"

@interface BlueViewController ()
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
    
    NSString *_currentUserID;

    NSString *_currentScore;
    
    //做全局
    RankingView *_rView;
    BlueSPView  *_bView;
    InstructView *_iView;
    OverView *_aView;
    
    BOOL isStudent;
}

@end

static NSString *cellId = @"cellId";
static NSString *cellId2 = @"cellId2";

@implementation BlueViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
    }
    return self;
}

- (id)initWithTag:(int)tag userID:(NSString *)userID isStudent:(BOOL)isStud
{
    self = [super init];
    if (self) {
        // Custom initialization
        isStudent = isStud;
        _currentUserID = userID;
        comeinIndex = tag-10;
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
        _rView.dataArray = [response objectForKey:@"Data"];
        [_rView.tableV reloadData];
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
            [_aView changeColor:@"N"];
            [_aView showMessageWithDegree:dd currentScore:_currentScore isBMI:YES];
            
        }
        else
        {
            _aView.guoBIV.image = [UIImage imageNamed:@"biaozhun1.png"];
            NSDictionary *dd = [response objectForKey:@"Degree"];
            [_aView changeColor:@"N"];
            [_aView showMessageWithDegree:dd currentScore:_currentScore isBMI:NO];
            
        }
        
        [_aView showMessageWithRank:[response objectForKey:@"Rank"]];
        
    }
    else
    {
        _aView.colorType.hidden = YES;
        [_aView changeColor:@"N"];
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
-(void)requestForRankOfParentID:(NSString *)userID projectID:(NSString *)pID
{
    [self showLoadingHUD];
    HttpInvokeItem *dataItem = [[HttpInvokeItem alloc] init];
    if ([self respondsToSelector:@selector(rankOfParentSuccess:)] && [self respondsToSelector:@selector(rankOfParentFailure:)])
    {
        [dataItem TargetSuper:self Success:@selector(rankOfParentSuccess:) Failure:@selector(rankOfParentFailure:)];
    }
    dataItem.dataEncodingType = MKNKPostDataEncodingTypeJSON;
    NSString *path = [NSString stringWithFormat:@"%@?userID=%@&programID=%@", Request_GetRankOfParent,userID,pID];
    
    [[HttpInvokeEngine shareHttpInvoke] InvokeHttpMethod:path withParams:nil addFile:nil withMethod:@"GET" InvokeItem:dataItem];
}

- (void)rankOfParentSuccess:(id)response
{
    [self hideHUD];
    NSLog(@"%@",[response objectForKey:@"Rank"]);
    if ([[response objectForKey:@"Result"] intValue] == 1)
    {
        [_bView showMessageWithRank:[response objectForKey:@"Data"]];
    }
    else
    {
        [_bView showMessageWithRank:[response objectForKey:@"Data"]];
        if([[response objectForKey:@"Message"] length] > 1)
        {
            [self displayErrorHUDWithText:[response objectForKey:@"Message"]];
        }
    }
}

- (void)rankOfParentFailure:(id)response
{
    [self hideHUD];
    [self displayErrorHUDWithText:@"请稍后再试"];
}

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
    if(self.isFromRedController)
    {
        //事件统计 家庭排名 点击锻炼转盘页面返回键
        [MobClick event:CustomizeSports_GoBack];
        
        [self dismissViewControllerAnimated:YES completion:^{
            //
            if(self.btrBlock)
            {
                self.btrBlock();
            }
        }];
    }
    else
    {
        UIImage *image = [[UIImage imageNamed:@"navigationBar_background-7.png"] stretchableImageWithLeftCapWidth:1 topCapHeight:0];
        [self.navigationController.navigationBar setBackgroundImage:image forBarMetrics:UIBarMetricsDefault];
        [self.navigationController popViewControllerAnimated:YES];
    }
}

//解决在使用AutoLayout UIScrollView不能滚动
- (void)viewDidLayoutSubviews
{
    if(iPhone4S)
    {
        self.rootScroler.contentSize = CGSizeMake(self.rootScroler.frame.size.width, _rootScroler.frame.size.height +35);
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationController.navigationBarHidden = YES;
    
    [_overView setContentSize:CGSizeMake(_overView.frame.size.width*3, _overView.frame.size.height)];
    
    currentIndex = 1;
    
    NSArray *nnnibContents = [[NSBundle mainBundle] loadNibNamed:@"ITView" owner:nil options:nil];
    _iView = (InstructView *)[nnnibContents objectAtIndex:0];
    _iView.frame = CGRectMake(0, 0, _iView.frame.size.width, _iView.frame.size.height);
    [_overView addSubview:_iView];
    
    NSArray *nnibContents = [[NSBundle mainBundle] loadNibNamed:@"RankV" owner:nil options:nil];
    _rView = (RankingView *)[nnibContents objectAtIndex:0];
    _rView.frame = CGRectMake(_overView.frame.size.width, 0, _rView.frame.size.width, _rView.frame.size.height);
    [_rView changeColor:@"B"];
    [_overView addSubview:_rView];
    
    if(isStudent)
    {
        //小孩
        NSArray *nibContents = [[NSBundle mainBundle] loadNibNamed:@"OverV" owner:nil options:nil];
        _aView = (OverView *)[nibContents objectAtIndex:0];
        _aView.frame = CGRectMake(_overView.frame.size.width*2, 0, _aView.frame.size.width, _aView.frame.size.height);
        [_aView changeColor:@"N"];
        [_overView addSubview:_aView];
    }
    else
    {
        //父母
        NSArray *nibContents = [[NSBundle mainBundle] loadNibNamed:@"BspV" owner:nil options:nil];
        _bView = (BlueSPView *)[nibContents objectAtIndex:0];
        _bView.frame = CGRectMake(_overView.frame.size.width*2, 0, _bView.frame.size.width, _bView.frame.size.height);
        [_overView addSubview:_bView];
        
    }
    

    selIndex = 0;
    
    [_collectionView registerNib:[UINib nibWithNibName:@"dialCell" bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:cellId];
    
    CGFloat radius =0;
    CGFloat angularSpacing =0;
    CGFloat xOffset =0;
    CGFloat cell_width = 65;
    CGFloat cell_height = 65;
    
    dialLayout = [[AWCollectionViewDialLayout alloc] initWithRadius:radius andAngularSpacing:angularSpacing andCellSize:CGSizeMake(cell_width, cell_height) andAlignment:WHEELALIGNMENTCENTER andItemHeight:cell_height andXOffset:xOffset];
    
    [_collectionView setCollectionViewLayout:dialLayout];
    NSLog(@"！！！！%@",NSStringFromCGRect(_collectionView.frame));
    _collectionView.transform = CGAffineTransformMakeRotation(-M_PI_2);
    
    icons = [[NSMutableArray alloc]init];
    normalImages = [[NSMutableArray alloc]init];
    selectedImages = [[NSMutableArray alloc]init];
    for (int i = 8; i < 12; i++) {
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
    
    NSLog(@"！！！！%@",NSStringFromCGRect(_collectionView.frame));
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
    _goBut.hidden = YES;
    _goBut.userInteractionEnabled = NO;
    switch (sender) {
        case 1:
        {
            _circleImage.image = [UIImage imageNamed:@"circle-blue.png"];
            [_iView showMessageWithTag:[self scrollToStopPosition]+1];
            _goBut.hidden = NO;
            _goBut.userInteractionEnabled = YES;
        }
            break;
        case 2:
        {
            _circleImage.image = [UIImage imageNamed:@"circle-blueNo.png"];
        }
            break;
        case 3:
        {
            _circleImage.image = [UIImage imageNamed:@"circle-blueNo.png"];
        }
            break;
            
        default:
            break;
    }
}

-(IBAction)actionPressGo:(id)sender
{
    //屏幕常亮
    [[UIApplication sharedApplication] setIdleTimerDisabled:YES];
    
    NSArray *nibContents = nil;
    if(iPhone4S)
    {
        nibContents = [[NSBundle mainBundle] loadNibNamed:@"BG4SView" owner:nil options:nil];
    }
    else
    {
        nibContents = [[NSBundle mainBundle] loadNibNamed:@"BGView" owner:nil options:nil];
    }
    
    BlackGroundView *bView = (BlackGroundView *)[nibContents objectAtIndex:0];
    bView.formWhere = @"BlueViewController";
    bView.delegate = self;
    bView.nameLabel.text = [self projectNameWithIndex:[self scrollToStopPosition]+1];
    [self.view addSubview:bView];
    [self performSelectorOnMainThread:@selector(actionFire:) withObject:bView waitUntilDone:YES];

    [[UIApplication sharedApplication] setStatusBarOrientation:UIInterfaceOrientationLandscapeRight];
    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationSlide];
    bView.transform = CGAffineTransformMakeRotation(M_PI/2);
    bView.frame = CGRectMake(0, 0,bView.frame.size.width,bView.frame.size.height);
}

-(NSString *)projectNameWithIndex:(int)index
{
    NSString *proString = nil;
    NSString *returnString = nil;

    switch (index) {
        case 1:
        {
            proString = @"Plank";
            returnString = @"平板支撑";
        }
            break;
        case 2:
        {
            proString = @"Roll";
            returnString = @"卷腹";
        }
            break;
        case 3:
        {
            proString = @"SitUp";
            returnString = @"俯卧撑";
        }
            break;
        case 4:
        {
            proString = @"Squat";
            returnString = @"深蹲";
        }
            break;
            
        default:
            break;
    }
    if(isStudent)
    {
        //埋点统计 孩子点击Go按钮
        [MobClick event:CustomizeSports_GoOn attributes:@{@"Prj" : proString, @"Role" : @"Child"}];
    }
    else
    {
        //埋点统计 家长点击Go按钮
        [MobClick event:CustomizeSports_GoOn attributes:@{@"Prj" : proString, @"Role" : @"Parent"}];
    }
    return returnString = nil?@"":returnString;
}

-(void)actionFire:(BlackGroundView *)sender
{
    [sender timeFire];
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
    [self actionLandR:currentIndex];
    [_pageControl setCurrentPage:0];
    _goBut.hidden = NO;
    _goBut.userInteractionEnabled = YES;
    projectID = [self getProjectIDWithTag:index+11];
    
    _circleImage.image = [UIImage imageNamed:@"circle-blue.png"];
    _arrIv.image = [UIImage imageNamed:@"lssj.png"];
    [_rView changeColor:@"B"];
    
    [_overView scrollRectToVisible:CGRectMake(0, 0, _overView.frame.size.width, _overView.frame.size.height) animated:YES];
    currentIndex = 1;
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
    NSLog(@"%@",NSStringFromCGSize(collectionView.contentSize));
//    [self changeAttributeForZone:indexPath.row];
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
        int indx  = [[NSString stringWithFormat:@"%ld",(long)index] intValue];
        [self changeAttributeForZone:indx];
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
        }
        else if(scrollView.contentOffset.x == scrollView.frame.size.width)
        {
            if(isStudent)
            {
                //埋点统计 孩子查看个人记录
                [MobClick event:CustomizeSports_ShowHistory attributes:@{@"Prj" : pID, @"Role" : @"Child"}];

            }
            else
            {
                //埋点统计 家长查看个人记录
                [MobClick event:CustomizeSports_ShowHistory attributes:@{@"Prj" : pID, @"Role" : @"Parent"}];
            }
            
            currentIndex = 2;
            [self actionLandR:currentIndex];
            [self requestForHisByUserID:_currentUserID projectID:pID];
        }
        else
        {
            currentIndex = 3;
            [self actionLandR:currentIndex];
            //注意 此处要区分家长排名和学生排名
            if(isStudent)
            {
                [MobClick event:CustomizeSports_ShowRank attributes:@{@"Prj" : pID, @"Role" : @"Child"}];
                [self requestForRankOfStudentID:_currentUserID projectID:pID];
            }
            else
            {
                //埋点统计 家长查看个人排名
                [MobClick event:CustomizeSports_ShowRank attributes:@{@"Prj" : pID, @"Role" : @"Parent"}];
                
                [self requestForRankOfParentID:_currentUserID projectID:pID];
            }
        }
        [_pageControl setCurrentPage:currentIndex-1];
    }
    else
    {
        NSInteger index = [self scrollToStopPosition];
        int indx  = [[NSString stringWithFormat:@"%ld",(long)index] intValue];
        [self changeAttributeForZone:indx];
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
        int indx  = [[NSString stringWithFormat:@"%ld",(long)index] intValue];
        [self changeAttributeForZone:indx];
        [self didStopAtIndex:index];
    }
    /****/
}

//
-(void)didStopAtIndex:(NSInteger )currentInd
{
    int indx  = [[NSString stringWithFormat:@"%ld",(long)currentInd] intValue];
    selIndex = indx;
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
    return CGSizeMake(65, 65);
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(0 , 0, 0, 0);
}

/*************************************************/
@end
