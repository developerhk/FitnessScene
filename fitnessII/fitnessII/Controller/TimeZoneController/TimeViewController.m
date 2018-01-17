//
//  TimeViewController.m
//  fitnessII
//
//  Created by Haley on 15/7/6.
//  Copyright (c) 2015年 samples.hankang. All rights reserved.
//

#import "TimeViewController.h"
#import "TimeCustomCell.h"
#import "TimeShaftModel.h"
#import "TimeZoneModel.h"
#import "SDImageCache.h"
#import "FileManager.h"
#import <MediaPlayer/MediaPlayer.h>
#import "MainViewController.h"

@interface TimeViewController ()<TimeCustomCellDelegate>
{
    TimeZoneModel *_dataModel;
    int pageNumber;
    NSMutableArray *_dataArray;
    
    PWMainView *_currentPWMainView;
    NSString   *_currentVideoName;
    HttpInvokeItem *_httpItem;
    
    NSString *_currentDownLoadUrl;
}

@end

@implementation TimeViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)timeZoneSuccess:(id)response
{
    [self hideHUD];
    [_tableView doneLoadingTableViewData];
    [_tableView doneLoadingMoreTableViewData];
    NSLog(@"%@",[response objectForKey:@"Data"]);
    if ([[response objectForKey:@"Result"] intValue] == 1)
    {
        NSArray *arr = [response objectForKey:@"Data"];
        if(arr)
        {
            _tableView.needPullToLoadMore = YES;
            _dataModel = [TimeZoneModel TZWithInfo:arr];
            if(pageNumber == 1)
            {
                [_dataArray removeAllObjects];
                if([_dataModel.dataArray count]<10)
                {
                    _tableView.needPullToLoadMore = NO;
                }
            }
            [_dataArray addObjectsFromArray:_dataModel.dataArray];
            
            [_tableView reloadData];
        }
    }
}

- (void)timeZoneFailure:(id)response
{
    [self hideHUD];
    [_tableView doneLoadingTableViewData];
    [_tableView doneLoadingMoreTableViewData];
    [self displayErrorHUDWithText:@"请稍后再试"];
}

-(void)actionBack:(id)sender
{
    //逻辑  先取消  再删除
    if(_currentDownLoadUrl)
    {
        [HttpInvokeEngine cancelOperationsContainingURLString:_currentDownLoadUrl];
        NSString *name = [self getVideoNameFormVideoURL:_currentDownLoadUrl];
        if([[FileManager sharedInstance] isExistFileWithFileName:name])
        {
            //删除
            [[FileManager sharedInstance] removeFileWithName:name];
        }
    }
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:NotificationDownloadDidReceiveData object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationDidEnterBackgroundNotification object:nil];

    [_httpItem TargetSuper:nil Success:nil Failure:nil];
    _httpItem = nil;
    
    [[SDImageCache sharedImageCache] cleanDisk];
    [[SDImageCache sharedImageCache] clearMemory];
    
    if(self.delegate && [self.delegate respondsToSelector:@selector(changeTimeSign)])
    {
        [self.delegate changeTimeSign];
    }
    
    __block UIViewController *controller = nil;
    [self.navigationController.viewControllers enumerateObjectsUsingBlock:^(UIViewController *obj, NSUInteger idx, BOOL *stop) {
        //
        if([obj isKindOfClass:[MainViewController class]])
        {
            controller = (MainViewController *)obj;
            *stop = YES;
        }
    }];
    [self.navigationController popToViewController:controller animated:YES];
}

-(void)tableViewTypeChange
{
    [_tableView doneLoadingTableViewData];
    [_tableView doneLoadingMoreTableViewData];
}

-(void)appEnterbackground
{
    if(_currentPWMainView)
    {
        _currentPWMainView.progressView.hidden = YES;
        for (UIView *vv in _currentPWMainView.subviews) {
            if ([vv isKindOfClass:[UIImageView class]])
            {
                UIImageView *im = (UIImageView *)vv;
                im.hidden = NO;
            }
            if([vv isKindOfClass:[UIButton class]])
            {
                UIButton *but = (UIButton *)vv;
                but.hidden = NO;
            }
        }
    }

    if(_currentDownLoadUrl)
    {
        NSString *name = [self getVideoNameFormVideoURL:_currentDownLoadUrl];
        if([[FileManager sharedInstance] isExistFileWithFileName:name])
        {
            //删除
            [[FileManager sharedInstance] removeFileWithName:name];
            _currentDownLoadUrl = nil;
        }
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(tableViewTypeChange) name:@"RemoveAllHudsNotification" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appEnterbackground) name:UIApplicationDidEnterBackgroundNotification object:nil];
    
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationSlide];
    self.navigationController.navigationBarHidden = NO;
    
    [self setNavTitleWithKaiti:@"运动时光"];
    [self setLeftButtonTitle:nil image:[UIImage imageNamed:@"arrow.png"] target:self selector:@selector(actionBack:)];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(uploadVideo:) name:NotificationDownloadDidReceiveData object:nil];
    
    _currentDownLoadUrl = nil;
    
    _dataArray = [[NSMutableArray alloc] initWithCapacity:0];
    pageNumber = 1;
    
    _tableView.needPullToLoadMore = YES;
    _tableView.needPullToRefresh = YES;
    _tableView.pullDataSource = self;
    _tableView.pullDelegate = self;
    
    [self requestForTimeZone];
    
}

-(void)requestForTimeZone
{
    NSString *userID = [[NSUserDefaults standardUserDefaults] objectForKey:USERID];
    [self showLoadingHUD];
    HttpInvokeItem *dataItem = [[HttpInvokeItem alloc] init];
    if ([self respondsToSelector:@selector(timeZoneSuccess:)] && [self respondsToSelector:@selector(timeZoneFailure:)])
    {
        [dataItem TargetSuper:self Success:@selector(timeZoneSuccess:) Failure:@selector(timeZoneFailure:)];
    }
    dataItem.dataEncodingType = MKNKPostDataEncodingTypeJSON;
    NSString *path = [NSString stringWithFormat:@"%@?userID=%@&nextCnt=%d", Request_GetTimeChannel,userID,pageNumber];
    
    [[HttpInvokeEngine shareHttpInvoke] InvokeHttpMethod:path withParams:nil addFile:nil withMethod:@"GET" InvokeItem:dataItem];
}

- (void)tableViewStartLoadingNewData:(PullTableView *)tableView
{
    //事件统计 运动时光加载更多
    [MobClick event:SportsTime_More];
    
    pageNumber = 1;
    [self requestForTimeZone];
}

- (void)tableViewLoadingMoreData:(PullTableView *)tableView
{
    //事件统计 运动时光下拉刷新
    [MobClick event:SportsTime_PullDownRefresh];
    
    pageNumber = pageNumber +1;
    [self requestForTimeZone];
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_dataArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"identifier";
    TimeCustomCell *cell = (TimeCustomCell *)[tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[NSBundle mainBundle] loadNibNamed:@"TimeCustomCell" owner:self options:nil][0];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.delegate = self;
    TimeShaftModel *model = [_dataArray objectAtIndex:indexPath.row];
    [cell showMsgWithModel:model];
    
    return cell;
}

-(NSString *)getVideoNameFormVideoURL:(NSString *)url
{
    NSString *str = [url substringFromIndex:10];
    NSArray *ar = [str componentsSeparatedByString:@"/"];
    NSString *name = [ar lastObject];
    return name;
}

- (void) movieFinishedCallback:(NSNotification*) aNotification {
    MPMoviePlayerController *player = [aNotification object];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:MPMoviePlayerPlaybackDidFinishNotification object:player];
    [player stop];
}

-(void)videoPlayWithURL:(NSString *)videoPath
{
    //这个地方被坑了好久 本地视频和网络视频 URL获取方式是不一样的
    NSURL*videoPathURL=[[NSURL alloc] initFileURLWithPath:videoPath];
    
    MPMoviePlayerViewController *moviePlayer  =[[MPMoviePlayerViewController alloc] initWithContentURL:videoPathURL];
    [moviePlayer.moviePlayer setControlStyle:MPMovieControlStyleFullscreen];
    
    [moviePlayer.view setBackgroundColor:[UIColor clearColor]];
    
    [moviePlayer.view setFrame:self.view.bounds];
    if ([moviePlayer.moviePlayer respondsToSelector:@selector(prepareToPlay)]) {
        [moviePlayer.moviePlayer prepareToPlay];
    }
    [moviePlayer.moviePlayer play];
    [self presentMoviePlayerViewControllerAnimated:moviePlayer];
}

-(BOOL)timeCell:(TimeCustomCell *)cell withVideoURL:(NSString *)videoURL videoSize:(NSString *)size videoTag:(NSInteger)tag
{
    _currentVideoName = [self getVideoNameFormVideoURL:videoURL];
    if([[FileManager sharedInstance] isExistFileWithFileName:_currentVideoName])
    {
        //存在
        NSLog(@"播放");
        [self videoPlayWithURL:[[FileManager sharedInstance] videoPathWithName:_currentVideoName]];
    }
    else
    {
        //NO  - 不存在
        //先检查本地存贮够不够
        if([[FileManager sharedInstance] canDownloadFile:size] == NO)
        {
            [[FileManager sharedInstance] showDiskWarning];
            return NO;
        }
        for (UIView *vv in cell.videoView.subviews) {
            if([vv isKindOfClass:[PWMainView class]] && vv.tag == tag)
            {
                _currentPWMainView = (PWMainView *)vv;
                _currentPWMainView.progressView.hidden = NO;
            }
        }
        for (UIView *vv in _currentPWMainView.subviews) {
            if ([vv isKindOfClass:[UIImageView class]] && vv.tag == tag)
            {
                UIImageView *im = (UIImageView *)vv;
                im.hidden = YES;
            }
            if([vv isKindOfClass:[UIButton class]] && vv.tag == tag)
            {
                UIButton *but = (UIButton *)vv;
                but.hidden = YES;
            }
        }
        
        //执行下载之前 纪录下载的url 便于取消
        _currentDownLoadUrl = videoURL;
        
        [self showLoadingHUD];
        if(_httpItem == nil)
        {
            _httpItem = [[HttpInvokeItem alloc] init];
        }
        if ([self respondsToSelector:@selector(downLoadVideoSuccess:)] && [self respondsToSelector:@selector(downLoadVideoFailure:)])
        {
            [_httpItem TargetSuper:self Success:@selector(downLoadVideoSuccess:) Failure:@selector(downLoadVideoFailure:)];
        }
        _httpItem.dataEncodingType = MKNKPostDataEncodingTypeJSON;
        
        NSString *fileName = [NSString stringWithFormat:@"%@/%@",[[FileManager sharedInstance] rootPath],_currentVideoName];
        [[HttpInvokeEngine shareHttpInvoke] InvokeHttpMethod:videoURL withMethod:@"GET" InvokeItem:_httpItem downloadFatAssFileFrom:nil toFile:fileName];
        
        return NO;
    }
    return YES;
}

-(void)uploadVideo:(NSNotification *)notification {
    NSDictionary *dic = [notification userInfo];
    NSString *numStr = [dic objectForKey:@"progress"];
    [self performSelectorOnMainThread:@selector(uploadForVideoProgress:) withObject:numStr waitUntilDone:YES];
}

-(void)uploadForVideoProgress:(NSString *)num
{
    [_currentPWMainView.progressView setProgress:[num doubleValue]];
    NSLog(@"%f",[num doubleValue]);
}

- (void)downLoadVideoSuccess:(id)response
{
    [self hideHUD];

    //下载成功后清除记录的URL  以防止退出时删掉下载文件
    _currentDownLoadUrl = nil;
    
    _currentPWMainView.progressView.hidden = YES;
    for (UIView *vv in _currentPWMainView.subviews) {
        if ([vv isKindOfClass:[UIImageView class]])
        {
            UIImageView *im = (UIImageView *)vv;
            im.hidden = NO;
        }
        if([vv isKindOfClass:[UIButton class]])
        {
            UIButton *but = (UIButton *)vv;
            but.hidden = NO;
        }
    }
    [self videoPlayWithURL:[[FileManager sharedInstance] videoPathWithName:_currentVideoName]];
    NSLog(@"播放");
}

- (void)downLoadVideoFailure:(id)response
{
    [self hideHUD];
    _currentPWMainView.progressView.hidden = YES;
    for (UIView *vv in _currentPWMainView.subviews) {
        if ([vv isKindOfClass:[UIImageView class]])
        {
            UIImageView *im = (UIImageView *)vv;
            im.hidden = NO;
        }
        if([vv isKindOfClass:[UIButton class]])
        {
            UIButton *but = (UIButton *)vv;
            but.hidden = NO;
        }
    }
    NSString *name = [self getVideoNameFormVideoURL:_currentDownLoadUrl];
    if([[FileManager sharedInstance] isExistFileWithFileName:name])
    {
        //删除
        [[FileManager sharedInstance] removeFileWithName:name];
    }
    [self displayErrorHUDWithText:@"下载失败,请稍后再试"];
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    TimeShaftModel *model = [_dataArray objectAtIndex:indexPath.row];
    return [TimeCustomCell getHeightByContent:model];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    NSLog(@"----------------------------------------------------");
    [[SDImageCache sharedImageCache] cleanDisk];
    [[SDImageCache sharedImageCache] clearMemory];
}

@end
