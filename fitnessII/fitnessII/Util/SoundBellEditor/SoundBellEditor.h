//
//  SoundBellEditor.h
//  MaiXin
//
//  Created by rdc-hankang on 13-1-4.
//  Copyright (c) 2013年 sunjianwen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
#import "AudioToolbox/AudioToolbox.h"

//时间比较短的（称之为音效）使用AudioServicesCreateSystemSoundID来创建，而本地时间较长（称之为音乐）使用AVAudioPlayer类
//一个AVAudioPlayer只能播放一个url，如果想要播放多个文件，那么就得创建多个播放器。

@interface SoundBellEditor : NSObject<AVAudioPlayerDelegate>
{
    AVAudioPlayer *player;
    AVAudioPlayer *_hkPlayer;
}
@property (nonatomic, retain) AVAudioPlayer *hkPlayer;
@property (nonatomic, retain) NSDictionary *soundDic;

+ (SoundBellEditor *)sharedInstance;

+ (NSMutableDictionary *)musices;
/**
*播放音乐文件
*/
+(BOOL)playMusic:(NSString *)filename;

/**
*暂停播放
*/
+(void)pauseMusic:(NSString *)filename;

/**
*播放音乐文件
*/
+(void)stopMusic:(NSString *)filename;


//Num目前规定1022 － Calypso即兴曲调
-(void)chooseMyVoiceWithID:(int)Num;

@end


