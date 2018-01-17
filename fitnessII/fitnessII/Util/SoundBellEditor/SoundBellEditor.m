//
//  SoundBellEditor.m
//  MaiXin
//
//  Created by rdc-hankang on 13-1-4.
//  Copyright (c) 2013年 sunjianwen. All rights reserved.
//

#import "SoundBellEditor.h"

static NSMutableDictionary *_musices;

static SoundBellEditor *instance = nil;

@implementation SoundBellEditor
@synthesize hkPlayer = _hkPlayer;

+ (SoundBellEditor *)sharedInstance {
    @synchronized(self){
        if(instance == nil){
            instance = [[SoundBellEditor alloc] init];
        }
    }
    return instance;
}

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
    }
}

- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag
{
    
}

- (void)stopBeginVoice
{

}



+ (NSMutableDictionary *)musices {
	@synchronized(self) {
		if (_musices == nil) {
            _musices = [NSMutableDictionary dictionary];
		}
	}
	return _musices;
}

/**
 *播放音乐文件
 */
+(BOOL)playMusic:(NSString *)filename
{
    if (!filename) return NO;//如果没有传入文件名，那么直接返回
        //1.取出对应的播放器
        AVAudioPlayer *player=[self musices][filename];
        //2.如果播放器没有创建，那么就进行初始化
    if (!player) {
        //2.1音频文件的URL
        NSURL *url=[[NSBundle mainBundle]URLForResource:filename withExtension:nil];
        if (!url) return NO;//如果url为空，那么直接返回
     
            //2.2创建播放器
            player=[[AVAudioPlayer alloc]initWithContentsOfURL:url error:nil];
            player.delegate = (id<AVAudioPlayerDelegate>)self;
            //2.3缓冲
            if (![player prepareToPlay]) return NO;//如果缓冲失败，那么就直接返回
     
            //2.4存入字典
            [self musices][filename]=player;
        }
   
        //3.播放
        if (![player isPlaying]) {
            //如果当前没处于播放状态，那么就播放
            return [player play];
            }
    
     return YES;//正在播放，那么就返回YES
}

/**
 *暂停播放
 */
+(void)pauseMusic:(NSString *)filename
{
    if (!filename) return;//如果没有传入文件名，那么就直接返回
    //1.取出对应的播放器
    AVAudioPlayer *player=[self musices][filename];
    //2.暂停
    [player pause];//如果palyer为空，那相当于[nil pause]，因此这里可以不用做处理
}

/**
 *停止音乐文件
 */
+(void)stopMusic:(NSString *)filename
{
    if (!filename) return;//如果没有传入文件名，那么就直接返回
    
    //1.取出对应的播放器
    AVAudioPlayer *player=[self musices][filename];
    
    //2.停止
    [player stop];
    
    //3.将播放器从字典中移除
    [[self musices] removeObjectForKey:filename];
}

//震动
-(void)shockEditor
{
	AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
}

-(void)chooseMyVoiceWithID:(int)Num
{
    AudioServicesPlaySystemSound(1022);
}

//注销音效
-(void)SoundFinished
{
	
}

@end
