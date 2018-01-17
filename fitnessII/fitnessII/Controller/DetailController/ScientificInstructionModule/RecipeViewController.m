//
//  RecipeViewController.m
//  fitnessII
//
//  Created by Haley on 15/9/1.
//  Copyright (c) 2015年 samples.hankang. All rights reserved.
//

#import "RecipeViewController.h"
#import "RecipeFileManager.h"
#import "RPicView.h"
#import "RTimeView.h"
#import "SportBeforeViewController.h"
#import "ActionRecipeViewController.h"
#import "ZipArchive.h"
#import "UIImageView+WebCache.h"
#import "Reachability.h"

@interface RecipeViewController ()
{
    RecipeModel *_recipe;
    HttpInvokeItem *_dataIt; //下载专用
}
@property (nonatomic, retain) NSString *downLoadUrl;
@end

@implementation RecipeViewController

-(id)initWithRecipeData:(RecipeModel *)dataModel
{
    self = [super init];
    if (self) {
        // Custom initialization
        _recipe = dataModel;
    }
    return self;
}

- (BOOL)isEnableWIFI {
    return ([[Reachability reachabilityForLocalWiFi] currentReachabilityStatus] != NotReachable);
}

-(IBAction)actionBack:(id)sender
{
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationSlide];
    
    //屏幕常亮
    [[UIApplication sharedApplication] setIdleTimerDisabled:NO];
    if(_downLoadUrl)
    {
        [HttpInvokeEngine cancelOperationsContainingURLString:_downLoadUrl];
    }
    [[NSNotificationCenter defaultCenter] removeObserver:self name:NotificationDownloadDidReceiveData object:nil];
    [_dataIt TargetSuper:nil Success:nil Failure:nil];
    _dataIt = nil;
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)viewDidLayoutSubviews
{
    if(iPhone4S)
    {
        self.actionBut.frame = CGRectMake(self.actionBut.frame.origin.x, 460-42,self.actionBut.frame.size.width,self.actionBut.frame.size.height);
        self.downLoadprogressBar.frame = CGRectMake(self.downLoadprogressBar.frame.origin.x, 460-30,self.downLoadprogressBar.frame.size.width,self.downLoadprogressBar.frame.size.height);
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationController.navigationBarHidden = YES;
    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationSlide];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(uploadRecipeVideo:) name:NotificationDownloadDidReceiveData object:nil];
    
    self.currentDay.text = [NSString stringWithFormat:@"%@",_recipe.rdModel.currentDay];
    self.allDay.text = [NSString stringWithFormat:@"/%@天",_recipe.rdModel.days];
    self.allTime.text = [NSString stringWithFormat:@"%@",_recipe.rdModel.playDuration];
    self.allAction.text = [NSString stringWithFormat:@"%@",_recipe.rdModel.units];
    
    CGFloat cc = [_recipe.rdModel.currentDay floatValue];
    CGFloat aa = [_recipe.rdModel.days floatValue];
    _progressBar.progress = cc/aa;
    _progressBar.barBorderWidth = 0.0f;
    _progressBar.barInnerPadding = 0.0f;
    _progressBar.barBackgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"recipe_timeLine"]];
    _progressBar.barFillColor = UIColorFromRGB(0x39a875);
    _progressBar.isCircular = YES;
    for (int i = 1; i < aa; i ++) {
        
        UIImageView *cut = [[UIImageView alloc] initWithFrame:CGRectMake( i*(_progressBar.frame.size.width/aa),0, 2, 6)];
        cut.backgroundColor = UIColorFromRGB(0xa2cca2);
        [_progressBar addSubview:cut];
    }
    
    [_actionBut setTitle:[NSString stringWithFormat:@"开始第%@天训练     Go!",_recipe.rdModel.currentDay] forState:UIControlStateNormal];
    [_actionBut setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
    
    [_scroller setContentSize:CGSizeMake(169*[_recipe.dataArray count] - 26, _scroller.bounds.size.height)];
    
    [_recipe.dataArray enumerateObjectsUsingBlock:^(RecipeItem *obj, NSUInteger idx, BOOL *stop) {
        
        NSArray *nibContents = [[NSBundle mainBundle] loadNibNamed:@"RPView" owner:nil options:nil];
        RPicView *rView = (RPicView *)[nibContents objectAtIndex:0];
        [rView setRPicViewBlock:^(void){
            [self showSportIntroduce:idx];
        }];
        if([[RecipeFileManager sharedInstance] isExistFileWithFileName:obj.thumbName])
        {
            rView.backImageView.image = [UIImage imageWithContentsOfFile:[[RecipeFileManager sharedInstance] filePathWithName:obj.thumbName]];
        }
        else
        {
            [rView.backImageView sd_setImageWithURL:[NSURL URLWithString:obj.thumbUrl]];
        }
        rView.titleName.text = [NSString stringWithFormat:@"%@",obj.actionName];
        //"N"-次,“T”是秒
        if([obj.actionType isEqualToString:@"N"])
        {
            rView.numberLabel.text = [NSString stringWithFormat:@"%@ x %@%@",obj.groupNum,obj.repeatTimes,@"次"];
        }
        else
        {
            rView.numberLabel.text = [NSString stringWithFormat:@"%@ x %@%@",obj.groupNum,obj.repeatTimes,@"秒"];
        }
        if(idx == 0)
        {
            rView.frame = CGRectMake(0, 0, rView.bounds.size.width, rView.bounds.size.height);
        }
        else
        {
            rView.frame = CGRectMake((rView.bounds.size.width + 22 + 2 + 2) * idx, 0, rView.bounds.size.width, rView.bounds.size.height);
        }
        [_scroller addSubview:rView];
        
        if(idx == [_recipe.dataArray count] -1)
        {
            //最后一个不用加
        }
        else
        {
            NSArray *nibContent = [[NSBundle mainBundle] loadNibNamed:@"RTView" owner:nil options:nil];
            RTimeView *rtView = (RTimeView *)[nibContent objectAtIndex:0];
            rtView.frame = CGRectMake(CGRectGetMaxX(rView.frame)+2, 0, rtView.bounds.size.width, rtView.bounds.size.height);
            rtView.numberLabel.text = [NSString stringWithFormat:@"%@秒",obj.waitTime];
            [_scroller addSubview:rtView];
        }
    }];
    
    _downLoadprogressBar.progress = 0.0;
    _downLoadprogressBar.barBorderWidth = 0.0f;
    _downLoadprogressBar.barInnerPadding = 0.0f;
    _downLoadprogressBar.barBackgroundColor = UIColorFromRGB(0xfefefe);
    _downLoadprogressBar.barFillColor = UIColorFromRGB(0x348b34);
    _downLoadprogressBar.hidden = YES;
    _downLoadprogressBar.isCircular = YES;
}

-(void)showSportIntroduce:(NSInteger)index
{
    SportBeforeViewController *controller = [[SportBeforeViewController alloc] initWithRecipeModel:[_recipe.dataArray objectAtIndex:index]];
    [self presentViewController:controller animated:YES completion:^{
        //
    }];
}

-(IBAction)actionNext:(UIButton *)sender
{
    //事件统计 体质评价页面 点击下载按钮
    [MobClick event:SportsGuide_DownLoadGuide];
    
    [self showLoadingHUD];
    HttpInvokeItem *dataItem = [[HttpInvokeItem alloc] init];
    if ([self respondsToSelector:@selector(getRecipeVideoSuccess:)] && [self respondsToSelector:@selector(getRecipeVideoFailure:)])
    {
        [dataItem TargetSuper:self Success:@selector(getRecipeVideoSuccess:) Failure:@selector(getRecipeVideoFailure:)];
    }
    dataItem.dataEncodingType = MKNKPostDataEncodingTypeJSON;
    NSString *path = [NSString stringWithFormat:@"%@",Request_GetResouceInfo];
    
    [[HttpInvokeEngine shareHttpInvoke] InvokeHttpMethod:path withParams:nil addFile:nil withMethod:@"GET" InvokeItem:dataItem];
}

- (void)getRecipeVideoSuccess:(id)response
{
    [self hideHUD];
    if ([[response objectForKey:@"Result"] intValue] == 1)
    {
        NSString *videoSize = [response objectForKey:@"OrgSize"];
        NSString *videoVersion = [response objectForKey:@"Version"];
        NSString *videoUnzipSize = [response objectForKey:@"UnzipSize"];
        _downLoadUrl = [response objectForKey:@"URL"];
        
        NSString *recipeV = [[NSUserDefaults standardUserDefaults] objectForKey:RecipeVersion];
        
        if(recipeV
           && [recipeV isEqualToString:videoVersion]
           && [[[RecipeFileManager sharedInstance] allRecipeSize] floatValue] > 0.001       //要有内容
           && ![[RecipeFileManager sharedInstance] isExistFileWithFileName:@"recipe.zip"])  //内容不是未压缩资源
        {
            //不用下载
            //事件统计 点击开始第一天运动按钮
            [MobClick event:SportsGuide_StartSportGuide];
            
            _downLoadprogressBar.hidden = YES;
            ActionRecipeViewController *controller = [[ActionRecipeViewController alloc] initWithRecipeData:_recipe];
            [self.navigationController pushViewController:controller animated:YES];
        }
        else
        {
            //先检查本地存贮够不够
            if([[RecipeFileManager sharedInstance] canDownloadFile:videoUnzipSize] == NO)
            {
                [[RecipeFileManager sharedInstance] showDiskWarning];
            }
            else
            {
                //执行下载
                [[NSUserDefaults standardUserDefaults] setObject:videoVersion forKey:RecipeVersion];
                [[NSUserDefaults standardUserDefaults] synchronize];
            
                //wifi - 直接下载   其他的给提示
                if([[Reachability reachabilityForInternetConnection] isReachableViaWiFi])
                {
                    _actionBut.selected = YES;
                    _actionBut.userInteractionEnabled = NO;
                    [_actionBut setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, -20, 0)];
                    //屏幕常亮
                    [[UIApplication sharedApplication] setIdleTimerDisabled:YES];
                    [self requestForDownloadWithUrl:_downLoadUrl];
                }
                else
                {
                    //非wifi状态
                    long long int size = [videoSize longLongValue];
                    NSString *message = [NSString stringWithFormat:@"运动指导视频%lldM,目前为3G/4G环境，建议wifi环境下载",size/1024];
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提醒" message:message delegate:self cancelButtonTitle:@"稍后再下" otherButtonTitles:@"继续下载", nil];
                    alert.tag = 10000;
                    [alert show];
                }
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

- (void)getRecipeVideoFailure:(id)response
{
    [self hideHUD];
    [self displayErrorHUDWithText:@"请稍后再试"];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(alertView.tag == 10000)
    {
        if(buttonIndex == 1)
        {
            _actionBut.selected = YES;
            _actionBut.userInteractionEnabled = NO;
            [_actionBut setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, -20, 0)];
            //屏幕常亮
            [[UIApplication sharedApplication] setIdleTimerDisabled:YES];
            [self requestForDownloadWithUrl:_downLoadUrl];
        }
    }
    else
    {
        if(buttonIndex == 1)
        {
            [self unZip];
        }
    }
}

-(void)requestForDownloadWithUrl:(NSString *)url
{
    _downLoadprogressBar.hidden = NO;
    _dataIt = [[HttpInvokeItem alloc] init];
    if ([self respondsToSelector:@selector(downLoadRecipeSuccess:)] && [self respondsToSelector:@selector(downLoadRecipeFailure:)])
    {
        [_dataIt TargetSuper:self Success:@selector(downLoadRecipeSuccess:) Failure:@selector(downLoadRecipeFailure:)];
    }
    _dataIt.dataEncodingType = MKNKPostDataEncodingTypeJSON;
    
    NSString *fileName = [NSString stringWithFormat:@"%@/%@",[[RecipeFileManager sharedInstance] rootPath],@"recipe.zip"];
    NSLog(@"%@",fileName);
    [[HttpInvokeEngine shareHttpInvoke] InvokeHttpMethod:url withMethod:@"GET" InvokeItem:_dataIt downloadFatAssFileFrom:nil toFile:fileName];
}

- (void)downLoadRecipeSuccess:(id)response
{
    [self hideHUD];
    //下载完成进行解压
    [self unZip];
}

- (void)downLoadRecipeFailure:(id)response
{
    [self hideHUD];
    [self displayErrorHUDWithText:@"下载失败,请稍后再试"];
    _actionBut.selected = NO;
    _actionBut.userInteractionEnabled = YES;
    [_actionBut setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
    
    _downLoadprogressBar.progress = 0.0;
    _downLoadprogressBar.hidden = YES;
}

-(void)unZip
{
    NSString *fileName = [NSString stringWithFormat:@"%@/%@",[[RecipeFileManager sharedInstance] rootPath],@"recipe.zip"];
    
    ZipArchive *zip = [[ZipArchive alloc] init];
    NSString* zipFile = fileName;
    NSString* unZipTo = [[RecipeFileManager sharedInstance] rootPath];
    if( [zip UnzipOpenFile:zipFile] ){
        BOOL result = [zip UnzipFileTo:unZipTo overWrite:YES];
        if(result){
            //删除zip文件
            [[RecipeFileManager sharedInstance] removeFileWithName:@"recipe.zip"];
            _actionBut.selected = NO;
            _actionBut.userInteractionEnabled = YES;
            [_actionBut setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
            _downLoadprogressBar.progress = 0.0;
            _downLoadprogressBar.hidden = YES;
            ActionRecipeViewController *controller = [[ActionRecipeViewController alloc] initWithRecipeData:_recipe];
            [self.navigationController pushViewController:controller animated:YES];
        }
        else
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"解压失败" message:@"是否重新解压？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"解压", nil];
            [alert show];
        }
        [zip UnzipCloseFile];
    }
}

-(void)uploadRecipeVideo:(NSNotification *)notification {
    NSDictionary *dic = [notification userInfo];
    NSString *numStr = [dic objectForKey:@"progress"];
    
    [self performSelectorOnMainThread:@selector(uploadForVideoProgress:) withObject:numStr waitUntilDone:YES];
}

-(void)uploadForVideoProgress:(NSString *)num
{
    NSLog(@"%@",num);
    _downLoadprogressBar.progress = [num doubleValue];
    if (_downLoadprogressBar.progress == 1.0f) {
        _downLoadprogressBar.progress = 0.0;
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
