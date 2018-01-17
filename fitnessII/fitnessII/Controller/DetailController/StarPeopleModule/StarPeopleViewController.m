//
//  StarPeopleViewController.m
//  fitnessII
//
//  Created by Jack on 15/11/4.
//  Copyright © 2015年 samples.hankang. All rights reserved.
//

#import "StarPeopleViewController.h"
#import "StarModel.h"
#import "StarZoneModel.h"
#import "StarZoneManager.h"
#import <MediaPlayer/MediaPlayer.h>
#import "StarView.h"
#import "BlackGroundView.h"
#import "UnLockView.h"
#import "Reachability.h"
#import "FMUString.h"

@interface StarPeopleViewController ()<StarListDelegate,BlackGroundViewDelegate,UIAlertViewDelegate>
{
    StarZoneModel *_dataModel;
    NSString   *_currentVideoName;
    NSString   *_currentDownLoadUrl;
    
    StarMainView *_currentStarView;
    StarListCell *_listCell;
    
    HttpInvokeItem *_httpItem;

    //解锁专用
    NSString *_currentLockNumber;  //记住此时的解锁动作数
    NSString *_currentProgramID;   //记住当前的运动ID
    NSString *_unlockType;         //记住解了什么锁
    NSString *_episode;            //第几集


    int index;
}

@end

@implementation StarPeopleViewController

-(void)actionBack:(id)sender
{
    //逻辑  先取消  再删除
    if(_currentDownLoadUrl)
    {
        [self hideHUD];
        [HttpInvokeEngine cancelOperationsContainingURLString:_currentDownLoadUrl];
        NSString *name = [self getVideoNameFormVideoURL:_currentDownLoadUrl];
        if([[StarZoneManager sharedInstance] isExistFileWithFileName:name])
        {
            //删除
            [[StarZoneManager sharedInstance] removeFileWithName:name];
        }
    }
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:NotificationDownloadDidReceiveData object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationDidEnterBackgroundNotification object:nil];
    [_httpItem TargetSuper:nil Success:nil Failure:nil];
    _httpItem = nil;

    [self.navigationController popViewControllerAnimated:YES];
}

-(void)appEnterbackground
{
    //逻辑  先取消  再删除
    if(_currentDownLoadUrl)
    {
        [self hideHUD];
        [HttpInvokeEngine cancelOperationsContainingURLString:_currentDownLoadUrl];
        NSString *name = [self getVideoNameFormVideoURL:_currentDownLoadUrl];
        if([[StarZoneManager sharedInstance] isExistFileWithFileName:name])
        {
            //删除
            [[StarZoneManager sharedInstance] removeFileWithName:name];
            _currentDownLoadUrl = nil;
        }
        _currentStarView.progressView.hidden = YES;
        _listCell.stateBut.hidden = NO;
        _listCell.stateBut.selected = YES;
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(uploadStarVideo:) name:NotificationDownloadDidReceiveData object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appEnterbackground) name:UIApplicationDidEnterBackgroundNotification object:nil];
    
    [self setLeftButtonTitle:nil image:[UIImage imageNamed:@"arrow.png"] target:self selector:@selector(actionBack:)];
    [self setNavTitleWithKaiti:@"名家讲坛"];
 
    index = -1;
    [self requestForStarZone];
}

-(void)requestForStarZone
{
    NSString *userID = [[NSUserDefaults standardUserDefaults] objectForKey:USERID];
    [self showLoadingHUD];
    HttpInvokeItem *dataItem = [[HttpInvokeItem alloc] init];
    if ([self respondsToSelector:@selector(starZoneSuccess:)] && [self respondsToSelector:@selector(starZoneFailure:)])
    {
        [dataItem TargetSuper:self Success:@selector(starZoneSuccess:) Failure:@selector(starZoneFailure:)];
    }
    dataItem.dataEncodingType = MKNKPostDataEncodingTypeJSON;
    NSString *path = [NSString stringWithFormat:@"%@?userID=%@", Request_GetForumVideoInfo,userID];
    
    [[HttpInvokeEngine shareHttpInvoke] InvokeHttpMethod:path withParams:nil addFile:nil withMethod:@"GET" InvokeItem:dataItem];
}

- (void)starZoneSuccess:(id)response
{
    [self hideHUD];
    NSLog(@"%@",[response objectForKey:@"Data"]);
    if ([[response objectForKey:@"Result"] intValue] == 1)
    {
        NSDictionary *dic = (NSDictionary *)response;
        if(dic)
        {
            _dataModel = nil;
            _dataModel = [StarZoneModel SZWithInfo:dic];
            [_tableView reloadData];
            
            //自动弹出下载框
            if(index != -1)
            {
                [self performSelector:@selector(autoLoading) withObject:nil afterDelay:0.1];
            }
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

-(void)autoLoading
{
    //此处+1 是因为第一个cell是头
    StarListCell *cell = (StarListCell *)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForItem:index+1 inSection:0]];
    [self starCell:cell withtag:index isLock:NO];
}

- (void)starZoneFailure:(id)response
{
    [self hideHUD];
    [self displayErrorHUDWithText:@"请稍后再试"];
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_dataModel.dataArray count] + 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row == 0)
    {
        static NSString *identifier = @"identifier_0";
        StarHeaderCell *cell = (StarHeaderCell *)[tableView dequeueReusableCellWithIdentifier:identifier];
        if (cell == nil) {
            cell = [[NSBundle mainBundle] loadNibNamed:@"StarHeaderCell" owner:self options:nil][0];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;

        [cell showMeassageWithModel:_dataModel];
        [cell setHeaderBlock:^(void){
            //孙教授简介
            StarView *view = (StarView *)[[NSBundle mainBundle] loadNibNamed:@"SView" owner:self options:nil][0];
            [[[UIApplication sharedApplication] keyWindow] addSubview:view];
        }];
        
        return cell;
    }			
    else
    {
        static NSString *identifier = @"identifier";
        StarListCell *cell = (StarListCell *)[tableView dequeueReusableCellWithIdentifier:identifier];
        if (cell == nil) {
            cell = [[NSBundle mainBundle] loadNibNamed:@"StarListCell" owner:self options:nil][0];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.delegate =self;
        StarModel *model = [_dataModel.dataArray objectAtIndex:indexPath.row-1];
        [cell showMessageWithModel:model];
        
        cell.stateBut.tag = indexPath.row-1;
        return cell;
    }

    return nil;
}

-(NSString *)getVideoNameFormVideoURL:(NSString *)url
{
    NSArray *ar = [url componentsSeparatedByString:@"/"];
    NSString *name = [ar lastObject];
    return name;
}

-(void)videoPlayWithURL:(NSString *)videoPath
{
    //这个地方被坑了好久 本地视频和网络视频 URL获取方式是不一样的
    NSURL*videoPathURL=[[NSURL alloc] initFileURLWithPath:videoPath];
    
    MPMoviePlayerViewController *moviePlayer  =[[MPMoviePlayerViewController alloc] initWithContentURL:videoPathURL];
    [moviePlayer.moviePlayer setControlStyle:MPMovieControlStyleFullscreen];
    
    [moviePlayer.view setBackgroundColor:[UIColor clearColor]];
    //横屏
    [moviePlayer.view setFrame:self.view.bounds];
    moviePlayer.moviePlayer.scalingMode = MPMovieScalingModeAspectFill;
    moviePlayer.view.transform =CGAffineTransformMakeRotation((M_PI / 2.0));
    [[UIApplication sharedApplication] setStatusBarOrientation:UIInterfaceOrientationLandscapeRight animated:YES];
    //
    if ([moviePlayer.moviePlayer respondsToSelector:@selector(prepareToPlay)]) {
        [moviePlayer.moviePlayer prepareToPlay];
    }
    [moviePlayer.moviePlayer play];
    [self presentMoviePlayerViewControllerAnimated:moviePlayer];
}

#pragma mark - task unlock
-(void)requestForTask
{
    NSString *userID = [[NSUserDefaults standardUserDefaults] objectForKey:USERID];

    [self showLoadingHUD];
    HttpInvokeItem *dataItem = [[HttpInvokeItem alloc] init];
    if ([self respondsToSelector:@selector(getTaskSuccess:)] && [self respondsToSelector:@selector(getTaskFailure:)])
    {
        [dataItem TargetSuper:self Success:@selector(getTaskSuccess:) Failure:@selector(getTaskFailure:)];
    }
    dataItem.dataEncodingType = MKNKPostDataEncodingTypeJSON;
    NSString *path = [NSString stringWithFormat:@"%@?userID=%@", Request_GetUserUnlockProgramInfo,userID];
    
    [[HttpInvokeEngine shareHttpInvoke] InvokeHttpMethod:path withParams:nil addFile:nil withMethod:@"GET" InvokeItem:dataItem];
}

#pragma mark - BlackGroundViewDelegate
-(void)closeBlackGroundView:(BlackGroundView *)view score:(NSString *)score duration:(NSString *)dur
{
    //关闭屏幕常亮
    [[UIApplication sharedApplication] setIdleTimerDisabled:NO];
    self.navigationController.navigationBarHidden = NO;
    [UIView animateWithDuration:0.3 animations:^{
        //
        [view removeFromSuperview];
        [[UIApplication sharedApplication] setStatusBarOrientation:UIInterfaceOrientationPortrait];
        [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationSlide];
        view.transform = CGAffineTransformMakeRotation(0);
        
    } completion:^(BOOL finished) {
        //
        //逻辑 － 1:发请求提交数据 2
        if([_currentLockNumber intValue] <= [score intValue])
        {
            //解锁成功
            NSString *loginUserID = [[NSUserDefaults standardUserDefaults] objectForKey:USERID];
            NSString *programID = _currentProgramID;
            
            [self requestForUploadScoreWithLoginUserID:loginUserID programID:programID score:score dur:dur type:@"T" unlockType:_unlockType childUserID:@""];
        }
        else
        {
            
        }
    }];
}

-(void)requestForUploadScoreWithLoginUserID:(NSString *)userID programID:(NSString *)programID score:(NSString *)score dur:(NSString *)duration type:(NSString *)type unlockType:(NSString *)unlockType childUserID:(NSString *)childID
{
    [self showLoadingHUD];
    HttpInvokeItem *dataItem = [[HttpInvokeItem alloc] init];
    if ([self respondsToSelector:@selector(uploadScoreSuccess:)] && [self respondsToSelector:@selector(uploadScoreFailure:)])
    {
        [dataItem TargetSuper:self Success:@selector(uploadScoreSuccess:) Failure:@selector(uploadScoreFailure:)];
    }
    dataItem.dataEncodingType = MKNKPostDataEncodingTypeJSON;
    
    //解锁上传 childUserId 不用上传
    NSString *path = [NSString stringWithFormat:@"%@?userID=%@&programID=%@&score=%@&duration=%@&type=%@&unlockType=%@&childUserID=%@&episode=%@", Request_AddActivityInfoOfMobile,userID,programID,score,duration,type,unlockType,@"",_episode];
    
    [[HttpInvokeEngine shareHttpInvoke] InvokeHttpMethod:path withParams:nil addFile:nil withMethod:@"GET" InvokeItem:dataItem];
}

- (void)uploadScoreSuccess:(id)response
{
    [self hideHUD];
    NSLog(@"%@",[response objectForKey:@"Data"]);
    if ([[response objectForKey:@"Result"] intValue] == 1)
    {
        [self displayErrorHUDWithText:[response objectForKey:@"Message"]];
        //
        [self performSelector:@selector(actionToNext) withObject:nil afterDelay:1.0];
    }
    else
    {
        if([[response objectForKey:@"Message"] length] > 1)
        {
            [self displayErrorHUDWithText:[response objectForKey:@"Message"]];
        }
    }
}
-(void)actionToNext
{
    [self requestForStarZone];
}

- (void)uploadScoreFailure:(id)response
{
    [self hideHUD];
    [self displayErrorHUDWithText:@"请稍后再试"];
}

-(void)actionPressGo:(NSString *)proID andActionNumber:(NSString *)num
{
    //屏幕常亮
    [[UIApplication sharedApplication] setIdleTimerDisabled:YES];
    self.navigationController.navigationBarHidden = YES;
    
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
    bView.delegate = self;
    bView.actionNumber = num;
    _currentLockNumber = num;
    bView.nameLabel.text = [self getProjectNameWithID:proID];
    [self.view addSubview:bView];
    [self performSelectorOnMainThread:@selector(actionFire:) withObject:bView waitUntilDone:YES];
    
    [[UIApplication sharedApplication] setStatusBarOrientation:UIInterfaceOrientationLandscapeRight];
    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationSlide];
    bView.transform = CGAffineTransformMakeRotation(M_PI/2);
    bView.frame = CGRectMake(0, 0,bView.frame.size.width,bView.frame.size.height);
}

-(void)actionFire:(BlackGroundView *)sender
{
    [sender timeFire];
}

-(NSString *)getProjectNameWithID:(NSString *)idd
{
    int tag = [idd intValue];
    switch (tag) {
        case 103:
        {
            return @"平板支撑";
        }
            break;
        case 101:
        {
            return @"卷腹";
        }
            break;
        case 102:
        {
            return @"俯卧撑";
        }
            break;
        case 100:
        {
            return @"深蹲";
        }
            break;
        default:
            break;
    }
    return @"";
}

- (void)getTaskSuccess:(id)response
{
    [self hideHUD];
    NSLog(@"%@",[response objectForKey:@"Data"]);
    if ([[response objectForKey:@"Result"] intValue] == 1)
    {
        __weak __block UnLockView *unlockView = (UnLockView *)[[NSBundle mainBundle] loadNibNamed:@"ULView" owner:self options:nil][0];
        unlockView.frame = self.view.window.frame;
        [unlockView showMessageWithDic:[response objectForKey:@"Data"]];
        
        _currentProgramID = [[response objectForKey:@"Data"] objectForKey:@"ProgramID"];
        
        [unlockView setDmBlock:^(void){
            [unlockView removeFromSuperview];
        }];
        [unlockView setGBlock:^(void){
            [unlockView removeFromSuperview];
            [self actionPressGo:[[response objectForKey:@"Data"] objectForKey:@"ProgramID"] andActionNumber:[[response objectForKey:@"Data"] objectForKey:@"RepeatTimes"]];
        }];
        
        [[[UIApplication sharedApplication] keyWindow] addSubview:unlockView];
    }
    else
    {
        if([[response objectForKey:@"Message"] length] > 1)
        {
            [self displayErrorHUDWithText:[response objectForKey:@"Message"]];
        }
    }
}

- (void)getTaskFailure:(id)response
{
    [self hideHUD];
    [self displayErrorHUDWithText:@"请稍后再试"];
}

-(void)starCell:(StarListCell *)cell withtag:(int)tag isLock:(BOOL)isLock
{
    index = -1;
    StarModel *model = [_dataModel.dataArray objectAtIndex:tag];
    
    //埋点统计 点击孙教授视频
    [MobClick event:ProfessorCourse_PlayVideo attributes:@{@"VID" : model.topicName}];
    
    if(isLock)
    {
        index = tag;
        _episode = model.episode;
        _unlockType = @"VideoLock";
        [self requestForTask];
        return;
    }
    _currentVideoName = [self getVideoNameFormVideoURL:model.videoUrl];
    if([[StarZoneManager sharedInstance] isExistFileWithFileName:_currentVideoName])
    {
        //存在
        NSLog(@"播放");
        [self videoPlayWithURL:[[StarZoneManager sharedInstance] videoPathWithName:_currentVideoName]];
    }
    else
    {
        //NO - 不存在
        //先检查本地存贮够不够
        if([[StarZoneManager sharedInstance] canDownloadFile:model.videoSize] == NO)
        {
            [[StarZoneManager sharedInstance] showDiskWarning];
            return;
        }
        _listCell = cell;
        
        //wifi - 直接下载   其他的给提示
        if([[Reachability reachabilityForInternetConnection] isReachableViaWiFi])
        {
            //屏幕常亮
            StarModel *model = [_dataModel.dataArray objectAtIndex:tag];
            
            for (UIView *vv in _listCell.mainView.subviews) {
                if([vv isKindOfClass:[StarMainView class]])
                {
                    _currentStarView = (StarMainView *)vv;
                    [_currentStarView.progressView setHidden:NO];
                }
            }
            _listCell.stateBut.hidden = YES;
            
            //执行下载之前 纪录下载的url 便于取消
            _currentDownLoadUrl = model.videoUrl;
            
            [self showLoadingHUD];
            if(_httpItem == nil)
            {
                _httpItem = [[HttpInvokeItem alloc] init];
            }
            if ([self respondsToSelector:@selector(downLoadStarVideoSuccess:)] && [self respondsToSelector:@selector(downLoadStarVideoFailure:)])
            {
                [_httpItem TargetSuper:self Success:@selector(downLoadStarVideoSuccess:) Failure:@selector(downLoadStarVideoFailure:)];
            }
            _httpItem.dataEncodingType = MKNKPostDataEncodingTypeJSON;
            
            NSString *fileName = [NSString stringWithFormat:@"%@/%@",[[StarZoneManager sharedInstance] rootPath],_currentVideoName];
            [[HttpInvokeEngine shareHttpInvoke] InvokeHttpMethod:model.videoUrl withMethod:@"GET" InvokeItem:_httpItem downloadFatAssFileFrom:nil toFile:fileName];
        }
        else
        {
            //非wifi状态
            long long int size = [model.videoSize longLongValue];
            NSString *message = [NSString stringWithFormat:@"本视频%lldM,目前为3G/4G环境，建议wifi环境下载",size/1024];
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提醒" message:message delegate:self cancelButtonTitle:@"稍后再下" otherButtonTitles:@"继续下载", nil];
            alert.tag = tag;
            [alert show];

        }


    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex == 0)
    {
        
    }
    else{
        StarModel *model = [_dataModel.dataArray objectAtIndex:alertView.tag];

        for (UIView *vv in _listCell.mainView.subviews) {
            if([vv isKindOfClass:[StarMainView class]])
            {
                _currentStarView = (StarMainView *)vv;
                [_currentStarView.progressView setHidden:NO];
            }
        }
        _listCell.stateBut.hidden = YES;
        
        //执行下载之前 纪录下载的url 便于取消
        _currentDownLoadUrl = model.videoUrl;
        
        [self showLoadingHUD];
        if(_httpItem == nil)
        {
            _httpItem = [[HttpInvokeItem alloc] init];
        }
        if ([self respondsToSelector:@selector(downLoadStarVideoSuccess:)] && [self respondsToSelector:@selector(downLoadStarVideoFailure:)])
        {
            [_httpItem TargetSuper:self Success:@selector(downLoadStarVideoSuccess:) Failure:@selector(downLoadStarVideoFailure:)];
        }
        _httpItem.dataEncodingType = MKNKPostDataEncodingTypeJSON;
        
        NSString *fileName = [NSString stringWithFormat:@"%@/%@",[[StarZoneManager sharedInstance] rootPath],_currentVideoName];
        [[HttpInvokeEngine shareHttpInvoke] InvokeHttpMethod:model.videoUrl withMethod:@"GET" InvokeItem:_httpItem downloadFatAssFileFrom:nil toFile:fileName];
    }
}

-(void)uploadStarVideo:(NSNotification *)notification {
    NSDictionary *dic = [notification userInfo];
    NSString *numStr = [dic objectForKey:@"progress"];
    [self performSelectorOnMainThread:@selector(uploadForVideoProgress:) withObject:numStr waitUntilDone:YES];
}

-(void)uploadForVideoProgress:(NSString *)num
{
    [_currentStarView.progressView setProgress:[num doubleValue]];
    NSLog(@"%f",[num doubleValue]);
}

- (void)downLoadStarVideoSuccess:(id)response
{
    [self hideHUD];
    _currentDownLoadUrl = nil;
    
    _currentStarView.progressView.hidden = YES;
    _listCell.stateBut.hidden = NO;
    _listCell.stateBut.selected = YES;
    
    [self videoPlayWithURL:[[StarZoneManager sharedInstance] videoPathWithName:_currentVideoName]];
    NSLog(@"播放");
}

- (void)downLoadStarVideoFailure:(id)response
{
    [self hideHUD];
    NSString *name = [self getVideoNameFormVideoURL:_currentDownLoadUrl];
    if([[StarZoneManager sharedInstance] isExistFileWithFileName:name])
    {
        //删除
        [[StarZoneManager sharedInstance] removeFileWithName:name];
    }
    _currentStarView.progressView.hidden = YES;
    _listCell.stateBut.hidden = NO;
    _listCell.stateBut.selected = YES;
    [self displayErrorHUDWithText:@"下载失败,请稍后再试"];
}


#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if(indexPath.row == 0)
    {
        return 230.0f + [FMUString heightForText:_dataModel.videoContent withTextWidth:self.view.bounds.size.width - 54  withFont:[UIFont systemFontOfSize:14]];
    }
    else
    {
        return 186.0f;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
