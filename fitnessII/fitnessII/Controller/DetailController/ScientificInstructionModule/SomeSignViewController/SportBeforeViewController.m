//
//  SportBeforeViewController.m
//  fitnessII
//
//  Created by Haley on 15/9/17.
//  Copyright (c) 2015年 samples.hankang. All rights reserved.
//

#import "SportBeforeViewController.h"
#import "RecipeFileManager.h"
#import "UIImageView+WebCache.h"
#import <MediaPlayer/MediaPlayer.h>

@interface SportBeforeViewController ()
{
    RecipeItem *_dataModel;
    MPMoviePlayerController *_mpController;
}
@end

@implementation SportBeforeViewController

-(id)initWithRecipeModel:(RecipeItem *)dataModel
{
    self = [super init];
    if (self) {
        // Custom initialization
        _dataModel = dataModel;
    }
    return self;
}

-(void)appEnterForeground
{
    [self showActionModel];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appEnterForeground) name:UIApplicationWillEnterForegroundNotification object:nil];
    
    [self showActionModel];
    
    self.titleLab.text = [NSString stringWithFormat:@"%@",_dataModel.actionTitle];
    
    self.sportPart.text = [NSString stringWithFormat:@"%@",_dataModel.pertinence];
    
    self.detailLabel.text = [NSString stringWithFormat:@"%@",_dataModel.actionContent];
    
    self.starsIV.image = [UIImage imageNamed:[NSString stringWithFormat:@"sportBefore_%@stars",_dataModel.difficult]];
    
}

-(void)showActionModel
{
    if([[RecipeFileManager sharedInstance] isExistFileWithFileName:_dataModel.videoName])
    {
        NSString *path = [[RecipeFileManager sharedInstance] filePathWithName:_dataModel.videoName];
        NSURL *videoURL = [NSURL fileURLWithPath:path];
        
        _mpController = [[MPMoviePlayerController alloc] initWithContentURL:videoURL];
        _mpController.scalingMode = MPMovieScalingModeFill;
        _mpController.controlStyle = MPMovieControlStyleNone;
        _mpController.backgroundView.backgroundColor = [UIColor blackColor];
        _mpController.view.frame = CGRectMake(0, 0, self.picImageV.frame.size.width, self.picImageV.frame.size.height);
        
        if ([_mpController respondsToSelector:@selector(prepareToPlay)]) {
            [_mpController prepareToPlay];
        }
        
        _mpController.shouldAutoplay = YES;
        _mpController.repeatMode = MPMovieRepeatModeOne;
        [self.picImageV addSubview:_mpController.view];
        
    }
    else if([[RecipeFileManager sharedInstance] isExistFileWithFileName:_dataModel.picName])
    {
        self.picImageV.image = [UIImage imageWithContentsOfFile:[[RecipeFileManager sharedInstance] filePathWithName:_dataModel.picName]];
    }
    else
    {
        [self.picImageV sd_setImageWithURL:[NSURL URLWithString:_dataModel.thumbUrl]];
    }
}

-(void)viewDidLayoutSubviews
{
    CGFloat labelHeight = [self.detailLabel.text boundingRectWithSize:CGSizeMake(self.detailLabel.bounds.size.width, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:14]} context:nil].size.height;
    
    self.detailLabel.frame = CGRectMake(0, 0, self.detailLabel.frame.size.width, labelHeight);
    
    [self.detailScl setContentSize:CGSizeMake(self.detailLabel.bounds.size.width, labelHeight > self.detailScl.bounds.size.height ? labelHeight : self.detailScl.bounds.size.height)];
}

-(IBAction)actionBack:(id)sender
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationWillEnterForegroundNotification object:nil];

    if([[RecipeFileManager sharedInstance] isExistFileWithFileName:_dataModel.videoName] && _mpController)
    {
        [_mpController stop];
        [_mpController.view removeFromSuperview];
        _mpController = nil;
    }
    
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
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
