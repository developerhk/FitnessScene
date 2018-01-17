//
//  ActionRecipeViewController.m
//  fitnessII
//
//  Created by Haley on 15/9/14.
//  Copyright (c) 2015年 samples.hankang. All rights reserved.
//

#import "ActionRecipeViewController.h"
#import "RecipeFileManager.h"
#import "ContiuneViewController.h"
#import "SportIntroduceViewController.h"
#import "FMUString.h"
#import "CircularProgressView.h"

@interface ActionRecipeViewController ()<ContiuneDelegate,SportIntroduceDelegate>
{
    RecipeModel *_recipe;
    RecipeItem  *_recipeItem;
    
    int currentGroup;       //纪录当前第几组
    int currentSecond;      //纪录一组中第几次  读音
    BOOL isBeginTime;       //是否读完321的标记
    
    NSTimer *_recipeLast;   //整个运动时长
    int mtimeNumber;
    int ftimeNumber;
    
    NSString *_beginTime;
    
    int beginVoiceIndex;   //每节开始必放的音效index标记
    
    BOOL isLocationBeginVoice;   //当需要暂停时 当前音效处在什么位置 begin还是计数
    
    BOOL isTimerPro;      //标记是否是读秒项目
    NSTimer *_timePro;    //整个运动时长
    
    NSMutableArray *_doubleDimensionsArray;   //二维数组 大数组中的小数组
    int groupIndex;         //记录一套动作中的第几组
}

@property (nonatomic, strong) CircularProgressView *circleView;
@end

@implementation ActionRecipeViewController

-(id)initWithRecipeData:(RecipeModel *)dataModel
{
    if(iPhone4S)
    {
        self = [super initWithNibName:@"ActionR4SViewController" bundle:[NSBundle mainBundle]];
    }
    else
    {
        self = [super initWithNibName:@"ActionRecipeViewController" bundle:[NSBundle mainBundle]];
    }
    if (self) {
        // Custom initialization
        _recipe = dataModel;
        [self createDoubleDimensionsArrayWithModel:_recipe];
    }
    return self;
}

#pragma mark - 制作二维数组
-(void)createDoubleDimensionsArrayWithModel:(RecipeModel*)model
{
    _doubleDimensionsArray = [[NSMutableArray alloc] initWithCapacity:0];
    [model.dataArray enumerateObjectsUsingBlock:^(RecipeItem *obj, NSUInteger idx, BOOL *stop) {
        //
        NSMutableArray *ar = [[NSMutableArray alloc] initWithCapacity:0];
        for (int i = 0; i < [obj.groupNum intValue]; i++) {
            [ar addObject:obj];
        }
        [_doubleDimensionsArray addObject:ar];
    }];
}

#pragma mark - 读取辅助资源
-(NSString *)readAssistSourceWithName:(NSString *)name
{
    NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"VidePlist" ofType:@"plist"];
    NSDictionary *dictionary = [[NSDictionary alloc] initWithContentsOfFile:plistPath];
    NSDictionary *d = [dictionary objectForKey:@"AssistVideoSource"];
    NSString *sourceName = [d objectForKey:name];
    return sourceName;
}

#pragma mark - 读取数字资源
-(NSString *)readNumberSourceWithName:(NSString *)name
{
    NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"VidePlist" ofType:@"plist"];
    NSDictionary *dictionary = [[NSDictionary alloc] initWithContentsOfFile:plistPath];
    NSDictionary *d = [dictionary objectForKey:@"NumberVideoSource"];
    NSString *sourceName = [d objectForKey:name];
    return sourceName;
}

#pragma mark - 推出本业 返回上一级
-(IBAction)actionBack:(id)sender
{
    //事件统计 视频播放页 点点击返回键
    [MobClick event:SportsGuide_GoBack];
    
    [[UIApplication sharedApplication] setIdleTimerDisabled:NO];

    [[NSNotificationCenter defaultCenter] removeObserver:self name:MPMoviePlayerPlaybackDidFinishNotification object:nil];
    
    [_hkPlayer stop];
    _hkPlayer.delegate = nil;
    _hkPlayer = nil;
    
    [_mpController stop];
    _mpController = nil;
    
    [_recipeLast invalidate];
    _recipeLast = nil;
    
    [_timePro invalidate];
    _timePro = nil;
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [[UIApplication sharedApplication] setIdleTimerDisabled:YES];

    beginVoiceIndex = 1;
    _beginTime = [FMUString timeSinceDate:[NSDate date] format:@"yyyy-MM-dd HH:mm:ss"];
    
    currentGroup = 1;
    currentSecond = 0;
    
    //全局计时器 - 整个运动过程耗时多少时间
    ftimeNumber = 0;
    mtimeNumber = 0;
    [self performSelector:@selector(actionTimeLast) withObject:nil afterDelay:1.0];
    
    [[UIApplication sharedApplication] setStatusBarOrientation:UIInterfaceOrientationLandscapeRight];
    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationSlide];
    self.view.transform = CGAffineTransformMakeRotation(M_PI/2);
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(moviePlayOver:) name:MPMoviePlayerPlaybackDidFinishNotification object:nil];
    
    _progressBar.progress = 0.00f;
    _progressBar.barBorderWidth = 0.0f;
    _progressBar.barInnerPadding = 0.0f;
    _progressBar.barBackgroundColor = [UIColor colorWithRed:255.0/255.0 green:255.0/255.0 blue:255.0/255.0 alpha:0.5];
    _progressBar.barFillColor = UIColorFromRGB(0x20a18c);
    _progressBar.isCircular = NO;
    
    //圆弧进度条
    self.circleView = [[CircularProgressView alloc] initWithFrame:CGRectMake(19.5, 233.5, 65, 65)
                                                        backColor:[UIColor whiteColor]
                                                    progressColor:UIColorFromRGB(0x20a18c)
                                                        lineWidth:3
                                                        audioPath:nil];
    //set CircularProgressView delegate
    [self.view addSubview:self.circleView];
    [self.circleView revert];
    
    [self uploadViewDetailWithModel:[_recipe.dataArray objectAtIndex:0]];
    
    [self performSelector:@selector(loadMovieControl) withObject:nil afterDelay:0.1];
    
    _timePro = [NSTimer scheduledTimerWithTimeInterval:1.1 target:self selector:@selector(actionGetCount) userInfo:nil repeats:YES];
    [_timePro setFireDate:[NSDate distantFuture]];
}

#pragma mark - 小组播放
-(void)playFormWithIndex:(int)index
{
    if(_hkPlayer)
    {
        _hkPlayer.delegate = nil;
        _hkPlayer = nil;
    }
    NSString *videoName = [self readAssistSourceWithName:[NSString stringWithFormat:@"%d_Dgroup",index]];
    beginVoiceIndex = 8;
    NSURL *url=[[NSBundle mainBundle] URLForResource:videoName withExtension:nil];
    _hkPlayer=[[AVAudioPlayer alloc]initWithContentsOfURL:url error:nil];
    _hkPlayer.delegate = self;
    if (![_hkPlayer isPlaying]) {
        [_hkPlayer play];

    }
}

#pragma mark - group播放  每个group开始的音效
-(void)playGroupWithGroupIndex:(int)index
{
    if(_hkPlayer)
    {
        _hkPlayer.delegate = nil;
        _hkPlayer = nil;
    }
    NSString *videoName = nil;
    if(index == 1)
    {
        //第一个动作
        videoName = [self readAssistSourceWithName:@"first_action"];
    }
    else if(index == [_recipe.dataArray count])
    {
        //最后一个动作
        videoName = [self readAssistSourceWithName:@"last_action"];
    }
    else
    {
        //下一个动作
        videoName = [self readAssistSourceWithName:@"next_action"];
    }
    NSURL *url=[[NSBundle mainBundle] URLForResource:videoName withExtension:nil];
    _hkPlayer=[[AVAudioPlayer alloc]initWithContentsOfURL:url error:nil];
    _hkPlayer.delegate = self;
    if (![_hkPlayer isPlaying]) {
        [_hkPlayer play];
        beginVoiceIndex = beginVoiceIndex + 1;
    }
}

#pragma mark - 右下角计时器 记整个一套处方的时长 down
-(void)actionShowTime
{
    mtimeNumber = mtimeNumber + 1;
    if(mtimeNumber == 60)
    {
        ftimeNumber = ftimeNumber + 1;
        mtimeNumber = 0;
    }
    [self performSelectorOnMainThread:@selector(uploadTime:) withObject:nil waitUntilDone:YES];
}

-(void)uploadTime:(NSTimer *)timer
{
    if(mtimeNumber<10)
    {
        if(ftimeNumber < 10)
        {
            self.timeLabel.text = [NSString stringWithFormat:@"0%d:0%d",ftimeNumber,mtimeNumber];
        }
        else
        {
            self.timeLabel.text = [NSString stringWithFormat:@"%d:0%d",ftimeNumber,mtimeNumber];
        }
    }
    else
    {
        if(ftimeNumber < 10)
        {
            self.timeLabel.text = [NSString stringWithFormat:@"0%d:%d",ftimeNumber,mtimeNumber];
        }
        else
        {
            self.timeLabel.text = [NSString stringWithFormat:@"%d:%d",ftimeNumber,mtimeNumber];
        }
    }
}

-(void)actionTimeLast
{
    _recipeLast = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(actionShowTime) userInfo:nil repeats:YES];
}

#pragma mark - 界面初始布局 down
-(void)uploadViewDetailWithModel:(RecipeItem *)model
{

    if(currentGroup == 1)
    {
        //第一个
        self.leftBut.hidden = YES;
        self.rightBut.hidden = NO;
    }
    else if (currentGroup == [_recipe.dataArray count])
    {
        //最后一个
        self.leftBut.hidden = NO;
        self.rightBut.hidden = YES;
    }
    else
    {
        //中间
        self.leftBut.hidden = NO;
        self.rightBut.hidden = NO;
    }
    
    if([_recipe.dataArray count] == 1)
    {
        self.leftBut.hidden = YES;
        self.rightBut.hidden = YES;
    }
    
    self.currentNumber.text = [NSString stringWithFormat:@"%d",currentSecond];
    int all = [model.repeatTimes intValue];
    [self.circleView uploadProgress:currentSecond/all];
    self.allNumber.text = [NSString stringWithFormat:@"/%@",model.repeatTimes];
    self.titleLable.text = [NSString stringWithFormat:@"%d  %@",currentGroup,model.actionName];
}

-(int)beforeCountWithGroup:(int)current index:(int)index
{
    __block int allCount = 0;
    [_recipe.dataArray enumerateObjectsUsingBlock:^(RecipeItem *obj, NSUInteger idx, BOOL *stop) {
        //
        if(current == 1 && current == idx+1 && index == 1)
        {
            *stop = YES;
        }
        else if(current == 1 && current == idx+1 && index > 1)
        {
            allCount = [obj.repeatTimes intValue]*(index-1);
            *stop = YES;
        }
        else if(current > 1)
        {
            if(current == idx + 1)
            {
                allCount = allCount + [obj.repeatTimes intValue]*(index-1);
                *stop = YES;
            }
            else
            {
                allCount = allCount + [obj.repeatTimes intValue]*[obj.groupNum intValue];
            }
        }
        else
        {
            *stop = YES;
        }
    }];

    return allCount;
}

-(int)allCount
{
    __block int allCount = 0;
    [_recipe.dataArray enumerateObjectsUsingBlock:^(RecipeItem *obj, NSUInteger idx, BOOL *stop) {
        //
        allCount = allCount + [obj.repeatTimes intValue]*[obj.groupNum intValue];
    }];
    return allCount;
}

-(float)getBottonProgressWithModel:(RecipeModel *)model
{
    float before =[self beforeCountWithGroup:currentGroup index:groupIndex] + [self.currentNumber.text floatValue];
    float all = [self allCount];
    float progs = before/all;
    return progs;
}

#pragma mark - 视频开始播放 同时音频准备
-(void)loadMovieControl
{
    _recipeItem = [_recipe.dataArray objectAtIndex:currentGroup-1];
    
    //记录第一套中 有几组
    groupIndex = 1;
    
    NSString *path = [NSString stringWithFormat:@"%@/%@",[[RecipeFileManager sharedInstance] rootPath],_recipeItem.videoName];
    _mpController = [[MPMoviePlayerController alloc] initWithContentURL:[[NSURL alloc] initFileURLWithPath:path]];
    _mpController.view.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    _mpController.scalingMode = MPMovieScalingModeAspectFit;
    _mpController.controlStyle = MPMovieControlStyleNone;
    _mpController.backgroundView.backgroundColor = [UIColor blackColor];
    _mpController.view.frame = CGRectMake(0, 0, self.view.frame.size.height, self.view.frame.size.width);
    if ([_mpController respondsToSelector:@selector(prepareToPlay)]) {
        [_mpController prepareToPlay];
    }
    _mpController.shouldAutoplay = NO;
    [self.view addSubview:_mpController.view];
    [self.view sendSubviewToBack:_mpController.view];
    [_mpController play];
    
    beginVoiceIndex = 1;
    [self playGroupWithGroupIndex:currentGroup];
}

-(void)actionGetCount
{
    isLocationBeginVoice = NO;
    
    currentSecond = currentSecond + 1;
    
    int numm = MIN(currentSecond, [_recipeItem.repeatTimes intValue]);
    self.currentNumber.text = [NSString stringWithFormat:@"%d",numm];
    
    CGFloat cc = [_recipeItem.repeatTimes floatValue];
    CGFloat aa = currentSecond;
    CGFloat pro = aa/cc;
    NSString *progress = [NSString stringWithFormat:@"%.2f",pro];
    [self performSelectorOnMainThread:@selector(uploadPG:) withObject:progress waitUntilDone:YES];
    
    _progressBar.progress = [self getBottonProgressWithModel:_recipe];
    if(currentSecond == [_recipeItem.repeatTimes intValue]+1 - 7)
    {
        [self playBeginVoice:@"zai_jian_chi_5miao54321end.mp3"];
        beginVoiceIndex = 100;
    }
    
    if(currentSecond == [_recipeItem.repeatTimes intValue])
    {
        currentSecond = 0;
        isBeginTime = NO;
        
        if(currentGroup == [_recipe.dataArray count] && groupIndex == [_recipeItem.groupNum intValue])
        {
            //整个流程结束
            _leftBut.hidden = YES;  //担心跳转瞬间点了上一步
            [self performSelector:@selector(requestForComplete) withObject:nil afterDelay:0.5];
            return;
        }
        [self actionSleepTime];
    }
}

-(void)moviePlayOver:(NSNotification *)notification
{
    [_mpController play];
    
    if(isTimerPro)
    {
        return;
    }
    else
    {
        if(isBeginTime)
        {
            isLocationBeginVoice = NO;
            currentSecond = currentSecond + 1;
            beginVoiceIndex = -100;
            if(currentSecond == [_recipeItem.repeatTimes intValue]+1)
            {
                
            }
            else
            {
                [self playBeginVoice:[NSString stringWithFormat:@"%d.mp3",currentSecond]];
                self.currentNumber.text = [NSString stringWithFormat:@"%d",currentSecond];
                
                CGFloat cc = [_recipeItem.repeatTimes floatValue];
                CGFloat aa = currentSecond;
                CGFloat pro = aa/cc;
                NSString *progress = [NSString stringWithFormat:@"%.2f",pro];
                [self performSelectorOnMainThread:@selector(uploadPG:) withObject:progress waitUntilDone:YES];
                
                _progressBar.progress = [self getBottonProgressWithModel:_recipe];
            }
        }
        else
        {
            isBeginTime = NO;
            return;
        }
    }

    //视频结束才有声音  则视频多放一次
    if(currentSecond == [_recipeItem.repeatTimes intValue]+1)
    {
        currentSecond = 0;
        isBeginTime = NO;

        if(currentGroup == [_recipe.dataArray count] && groupIndex == [_recipeItem.groupNum intValue])
        {
            //整个流程结束
            _leftBut.hidden = YES;  //担心跳转瞬间点了上一步
            [self performSelector:@selector(requestForComplete) withObject:nil afterDelay:0.5];
            return;
        }
        [self actionSleepTime];
    }
}

-(void)uploadPG:(NSString *)progress
{
    [self.circleView uploadProgress:[progress floatValue]];
}


#pragma mark - 每节开始的音效
- (void)playBeginVoice:(NSString *)fileName
{
    if(_hkPlayer)
    {
        _hkPlayer.delegate = nil;
        _hkPlayer = nil;
    }
    NSURL *url=[[NSBundle mainBundle] URLForResource:fileName withExtension:nil];
    _hkPlayer=[[AVAudioPlayer alloc]initWithContentsOfURL:url error:nil];
    _hkPlayer.delegate = self;
    if (![_hkPlayer isPlaying]) {
        [_hkPlayer play];
        beginVoiceIndex = beginVoiceIndex + 1;
    }
}

- (void)stopBeginVoice
{
    if (_hkPlayer && [_hkPlayer isPlaying]) {
        [_hkPlayer pause];
    }
}

- (void)contiuneBeginVoice
{
    if (_hkPlayer && [_hkPlayer isPlaying] == NO) {
        [_hkPlayer play];
    }
}

- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag
{
    // 此处isLocationBeginVoice 每个里面都写  是因为 当在运动报数的时候 此处会在置为YES 在暂停的时候出现不能播放的问题
    
    //1-8  开始音效 第一个动作 - 321go
    switch (beginVoiceIndex) {
        case 1:
        {
        
        }
            break;
        case 2:
        {
            //
            [self playBeginVoice:_recipeItem.audioName];
            isLocationBeginVoice = YES;
        }
            break;
        case 3:
        {
            [self playBeginVoice:[self readAssistSourceWithName:[NSString stringWithFormat:@"%@_group",_recipeItem.groupNum]]];
            isLocationBeginVoice = YES;
        }
            break;
        case 4:
        {
            //判断是否有组
            if([_recipeItem.groupNum intValue] > 1)
            {
                //有组
                [self playBeginVoice:@"mei_zu.mp3"];
                isLocationBeginVoice = YES;
            }
            else
            {
                //没有组
                //有组
                if([_recipeItem.repeatTimes intValue] == 2)
                {
                    [self playBeginVoice:@"liang.mp3"];

                }
                else
                {
                    [self playBeginVoice:[NSString stringWithFormat:@"%@.mp3",_recipeItem.repeatTimes]];
                }
                isLocationBeginVoice = YES;
            }
        }
            break;
        case 5:
        {
            //判断是否有组
            if([_recipeItem.groupNum intValue] > 1)
            {
                //有组
                if([_recipeItem.repeatTimes intValue] == 2)
                {
                    [self playBeginVoice:@"liang.mp3"];
                }
                else
                {
                    [self playBeginVoice:[NSString stringWithFormat:@"%@.mp3",_recipeItem.repeatTimes]];
                }
                
            }
            else
            {
                //没有组
                if([_recipeItem.actionType isEqualToString:@"T"])
                {
                    isTimerPro = YES;
                    [self playBeginVoice:@"miao.mp3"];
                }
                else
                {
                    isTimerPro = NO;
                    [self playBeginVoice:@"ci.mp3"];
                }
            }
            isLocationBeginVoice = YES;
        }
            break;
        case 6:
        {
            //判断是否有组
            if([_recipeItem.groupNum intValue] > 1)
            {
                //有组
                if([_recipeItem.actionType isEqualToString:@"T"])
                {
                    isTimerPro = YES;
                    [self playBeginVoice:@"miao.mp3"];
                }
                else
                {
                    isTimerPro = NO;
                    [self playBeginVoice:@"ci.mp3"];
                }
            }
            else
            {
                //没有组
                [self playBeginVoice:@"321go.mp3"];
                [self performSelector:@selector(updateBeginTag) withObject:nil afterDelay:3.2];
            }
            isLocationBeginVoice = YES;
        }
            break;
        case 7:
        {
            //判断是否有组
            if([_recipeItem.groupNum intValue] > 1)
            {
                //有组
                [self playBeginVoice:[self readAssistSourceWithName:[NSString stringWithFormat:@"%d_Dgroup",groupIndex]]];
            }
            isLocationBeginVoice = YES;
        }
        case 8:
        {
            //判断是否有组
            if([_recipeItem.groupNum intValue] > 1)
            {
                //有组
                [self playBeginVoice:@"321go.mp3"];
                [self performSelector:@selector(updateBeginTag) withObject:nil afterDelay:3.2];

            }
            isLocationBeginVoice = YES;
        }
            break;
        case 100:
        {
        
        }
            break;
        default:
            break;
    }
}

-(void)updateBeginTag
{
    if(isTimerPro)
    {
        [_timePro setFireDate:[NSDate distantPast]];
    }
    else
    {
        isBeginTime = YES;
    }
    isLocationBeginVoice = NO;
}

#pragma mark - 快进 快退
-(IBAction)actionLeft:(UIButton *)sender
{
    //事件统计 视频播放页 点击上一组动作按钮
    [MobClick event:SportsGuide_PreAction];
    
    _leftBut.userInteractionEnabled = NO;
    _rightBut.userInteractionEnabled = NO;
    isBeginTime = NO;
    currentSecond = 0;
    currentGroup = currentGroup - 1;
    [self performSelector:@selector(actionNextForGroup) withObject:nil afterDelay:0.6];
}

-(IBAction)actionRight:(UIButton *)sender
{
    //事件统计 视频播放页 点击下一组动作按钮
    [MobClick event:SportsGuide_NextAction];
    
    _leftBut.userInteractionEnabled = NO;
    _rightBut.userInteractionEnabled = NO;
    isBeginTime = NO;
    currentSecond = 0;
    currentGroup = currentGroup + 1;
    [self performSelector:@selector(actionNextForGroup) withObject:nil afterDelay:0.6];
}

#pragma mark - 一组结束 休息“30”秒
-(void)actionSleepTime
{
    [self allStop];
    
    ContiuneViewController *controller = [[ContiuneViewController alloc] initWithHKSignType:HK_Sleep timeCount:_recipeItem.waitTime];
    controller.delegate = self;
    [self.navigationController pushViewController:controller animated:YES];
}

-(void)sleepBackForRestartFire
{
    [self allBegin];
    [self actionNext];
}

#pragma mark - 点击运动详情跳转
-(IBAction)actionDetail:(UIButton *)sender
{
    [self allStop];
    
    SportIntroduceViewController *controller = [[SportIntroduceViewController alloc] initWithRecipeModel:[_recipe.dataArray objectAtIndex:currentGroup-1]];
    controller.delegate = self;
    [self.navigationController pushViewController:controller animated:YES];
}

-(void)introduceBackToActionRecipe
{
    [self allBegin];
}

#pragma mark - 点击暂停跳转
-(IBAction)actionStop:(UIButton *)sender
{
    //事件统计 视频播放页 点击暂停按钮
    [MobClick event:SportsGuide_Pause];
    
    [self allStop];
    ContiuneViewController *controller = [[ContiuneViewController alloc] initWithHKSignType:HK_Contiune timeCount:@"NO"];
    controller.delegate = self;
    [self.navigationController pushViewController:controller animated:YES];
}

-(void)contiuneBackForRestartFire
{
    //事件统计 视频播放页 点击跳过按钮
    [MobClick event:SportsGuide_PassRest];
    
    if(isTimerPro)
    {
        [_timePro setFireDate:[NSDate distantPast]];
    }
    [self allBegin];
}

#pragma mark - 每个项目开始时的准备 包括新视频 新音频
-(void)actionNextForGroup
{
    isBeginTime = NO;
    if(isTimerPro)
    {
        [_timePro setFireDate:[NSDate distantFuture]];
    }
    
    groupIndex = 1;

    _recipeItem = [_recipe.dataArray objectAtIndex:currentGroup-1];
    
    NSString *path = [NSString stringWithFormat:@"%@/%@",[[RecipeFileManager sharedInstance] rootPath],_recipeItem.videoName];
    
    _mpController.contentURL = [[NSURL alloc] initFileURLWithPath:path];
    [_mpController play];
    
    [self uploadViewDetailWithModel:_recipeItem];

    beginVoiceIndex = 1;
    [self playGroupWithGroupIndex:currentGroup];
    
    _leftBut.userInteractionEnabled = YES;
    _rightBut.userInteractionEnabled = YES;
    
    _progressBar.progress = [self getBottonProgressWithModel:_recipe];
}

-(void)actionNext
{
    //在下一次动作开始的时候  导致前置音频没放完  报数就开始了
    isBeginTime = NO;
    
    if(isTimerPro)
    {
        [_timePro setFireDate:[NSDate distantFuture]];
    }
    if(groupIndex < [_recipeItem.groupNum intValue])  //此处按逻辑应该是 <= 但是在进行此判断之前  已经开始了一次
    {
        //小组中没播完
        groupIndex = groupIndex + 1;
        NSString *path = [NSString stringWithFormat:@"%@/%@",[[RecipeFileManager sharedInstance] rootPath],_recipeItem.videoName];
        
        _mpController.contentURL = [[NSURL alloc] initFileURLWithPath:path];
        [_mpController play];
        
        [self uploadViewDetailWithModel:_recipeItem];
        beginVoiceIndex = 1;
        [self playFormWithIndex:groupIndex];
        
        _leftBut.userInteractionEnabled = YES;
        _rightBut.userInteractionEnabled = YES;
        
        _progressBar.progress = [self getBottonProgressWithModel:_recipe];
    }
    else
    {
        //切换大组
        currentGroup = currentGroup + 1;
        [self actionNextForGroup];
    }
}

#pragma mark - 整个流程结束 请求获得的积分 成功后进入时间轴
-(void)requestForComplete
{
    [self allStop];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:MPMoviePlayerPlaybackDidFinishNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:MPMovieMediaTypesAvailableNotification object:nil];

    [_recipeLast invalidate];
    _recipeLast = nil;
    
    [_timePro invalidate];
    _timePro = nil;
    
    [self performSelector:@selector(actionAllOver) withObject:nil afterDelay:0.1];
}

-(void)actionAllOver
{
    //事件统计 视频播放页 进入完成训练页面
    [MobClick event:SportsGuide_EnterFinish];
    
    NSString *endTime= [FMUString timeSinceDate:[NSDate date] format:@"yyyy-MM-dd HH:mm:ss"];
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] initWithCapacity:0];
    [dic setObject:_recipe.rdModel.userID forKey:@"USERID"];
    [dic setObject:_beginTime forKey:@"BEGIN"];
    [dic setObject:endTime forKey:@"END"];
    NSString *loginUserID = [[NSUserDefaults standardUserDefaults] objectForKey:USERID];
    [dic setObject:loginUserID forKey:@"LoginUser"];
    
    ContiuneViewController *controller = [[ContiuneViewController alloc] initWithHKSignType:HK_Complete timeCount:@"NO"];
    controller.dataDic = dic;
    [self.navigationController pushViewController:controller animated:YES];
}

-(void)allStop
{
    //读秒暂停
    isBeginTime = NO;
    [self stopBeginVoice];
    //视频暂停
    [_mpController stop];
    //倒计时暂停
    [_recipeLast setFireDate:[NSDate distantFuture]];
    if(isTimerPro)
    {
        [_timePro setFireDate:[NSDate distantFuture]];
    }
}

-(void)allBegin
{
    [_mpController play];
    [_recipeLast setFireDate:[NSDate distantPast]];
    
    if(isLocationBeginVoice)
    {
        //只有在前奏阶段 才继续播放
        isBeginTime = NO;
        [self contiuneBeginVoice];
    }
    else
    {
        isBeginTime = YES;
    }

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
