//
//  ActionRecipeViewController.h
//  fitnessII
//
//  Created by Haley on 15/9/14.
//  Copyright (c) 2015年 samples.hankang. All rights reserved.
//

#import "RootViewController.h"
#import <MediaPlayer/MediaPlayer.h>
#import "SoundBellEditor.h"
#import "TYMProgressBarView.h"
#import "RecipeModel.h"
#import <AVFoundation/AVFoundation.h>
#import "AudioToolbox/AudioToolbox.h"

@interface ActionRecipeViewController : RootViewController<AVAudioPlayerDelegate>
{
    MPMoviePlayerController *_mpController;
    AVAudioPlayer *_hkPlayer;
}

@property (nonatomic, strong) IBOutlet UIButton *leftBut;
@property (nonatomic, strong) IBOutlet UIButton *rightBut;

@property (nonatomic, strong) IBOutlet UIImageView *circleBGView;
@property (nonatomic, strong) IBOutlet UILabel *currentNumber;
@property (nonatomic, strong) IBOutlet UILabel *allNumber;

@property (nonatomic, strong) IBOutlet UILabel *titleLable;
@property (nonatomic, strong) IBOutlet UIButton *detailBut;

@property (nonatomic, strong) IBOutlet UIButton *stopBut;
@property (nonatomic, strong) IBOutlet UILabel *timeLabel;

@property (nonatomic, strong) IBOutlet TYMProgressBarView *progressBar;

-(id)initWithRecipeData:(RecipeModel *)dataModel;

@end
