//
//  BlackGroundView.m
//  fitnessII
//
//  Created by Haley on 15/7/14.
//  Copyright (c) 2015年 samples.hankang. All rights reserved.
//

#import "BlackGroundView.h"

@implementation BlackGroundView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
    }
    return self;
}

-(void)showFaceWithType:(NSString *)type
{
    self.faceIV.hidden = NO;
    if([type isEqualToString:@"S"])
    {
        //笑
        self.faceIV.image = [UIImage imageNamed:@"action_smile"];
    }
    else
    {
        //哭
        self.faceIV.image = [UIImage imageNamed:@"action_cry"];
    }
}


- (void)handlePanRecognizer:(UIPanGestureRecognizer*)recognizer {
    
    CGPoint location = [recognizer locationInView:self.sliderBackIV];
        NSLog(@"location : %@",NSStringFromCGPoint(location));
    if (recognizer.state == UIGestureRecognizerStateBegan) {
        beginPoint = CGPointMake(0, 5);
    }
    else if (recognizer.state == UIGestureRecognizerStateChanged) {
        
        float yy = location.y-5;
        if(location.y < 5)
        {
            yy = 5.0f;
        }
        if(location.y > 202)
        {
            yy = 202.0f;
        }

        
        self.sliderIV.frame = CGRectMake(self.sliderIV.frame.origin.x, yy, self.sliderIV.frame.size.width, self.sliderIV.frame.size.height);
    }
    else if (recognizer.state == UIGestureRecognizerStateEnded || recognizer.state == UIGestureRecognizerStateCancelled) {
        if(location.y  - beginPoint.y> 190)
        {
            if([self.formWhere isEqualToString:@"BlueViewController"])
            {
            }
            else
            {
                NSLog(@"成功");
                if([self isSuccessUnLock])
                {
                    [self showFaceWithType:@"S"];
                    self.nameLabel.text = @"赞！成功解锁！";
                }
                else
                {
                    [self showFaceWithType:@"N"];
                    self.nameLabel.text = @"好遗憾~再来咯！";
                }
            }
            [self actionOK:nil];
        }
        else
        {
            
        }
        [UIView animateWithDuration:0.3 animations:^{
            self.sliderIV.frame = CGRectMake(self.sliderIV.frame.origin.x, 5.0, self.sliderIV.frame.size.width, self.sliderIV.frame.size.height);
        } completion:^(BOOL finished) {
            //
            [self changeSliderStyle];
        }];

    }
}

-(void)completeUnlock{
    [self showFaceWithType:@"S"];
    self.nameLabel.text = @"赞！成功解锁！";
    [self actionOK:nil];
}

-(void)awakeFromNib
{
    [super awakeFromNib];
    _timeNumber = 0;
    countNum = 0;
    
    _myDataLogger = [[DataLogger alloc] init];
    _myDataLogger.xyzDelegate = self;
    
    UIPanGestureRecognizer *ges = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePanRecognizer:)];
    [self.sliderIV addGestureRecognizer:ges];
}

-(void)timeForPBZC:(NSString *)sender
{
    if([self.nameLabel.text isEqualToString:@"平板支撑"])
    {
        if([self isSuccessUnLock])
        {
            //解锁功能  并且接锁成功
            [self completeUnlock];
        }
        self.timeLabel.text = [NSString stringWithFormat:@"%d",_timeNumber++];
    }
    else
    {
        _timeNumber++;
    }
}


//针对解锁  进行判断
-(void)changeSliderStyle
{
    if([self.formWhere isEqualToString:@"BlueViewController"])
    {
        self.sliderBackIV.image = [UIImage imageNamed:@"action_slider_allback"];
    }
    else
    {
        self.sliderBackIV.image = [UIImage imageNamed:@"action_slider_cutback"];
    }
    self.sliderView.hidden = NO;
}

-(BOOL)isSuccessUnLock
{
    if([self.formWhere isEqualToString:@"BlueViewController"])
    {
        return NO;
    }
    else
    {
        if([self.actionNumber intValue] <= [_timeLabel.text intValue])
        {
            //达到解锁条件
            return YES;//...........
        }
        else
        {
            return NO;
        }
    }
}


-(void)actionStartSport
{
    _timeKit = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(timeForPBZC:) userInfo:nil repeats:YES];
    
    if([self.nameLabel.text isEqualToString:@"平板支撑"])
    {

    }
    else if([self.nameLabel.text isEqualToString:@"卷腹"] || [self.nameLabel.text isEqualToString:@"俯卧撑"])
    {
        _timeLabel.text = [NSString stringWithFormat:@"%d",countNum];
        UIDevice *_curDevice = [UIDevice currentDevice];
        [_curDevice setProximityMonitoringEnabled:YES];
        
        if(self.observe)
        {
            [[NSNotificationCenter defaultCenter] removeObserver:self.observe];
            self.observe = nil;
        }
        self.observe = [[NSNotificationCenter defaultCenter] addObserverForName:UIDeviceProximityStateDidChangeNotification
                                    object:nil
                                     queue:[NSOperationQueue mainQueue]
                                usingBlock:^(NSNotification *note) {
                                    
                                    if (_curDevice.proximityState == YES) {
                                        _timeLabel.text = [NSString stringWithFormat:@"%d",countNum++];
                                        if([self isSuccessUnLock])
                                        {
                                            //解锁功能  并且接锁成功
                                            [self completeUnlock];
                                        }
                                    }
                                    else {

                                    }
                                }];
    }
    else if([self.nameLabel.text isEqualToString:@"深蹲"])
    {
        _timeLabel.text = [NSString stringWithFormat:@"%d",countNum];
        [_myDataLogger startLoggingMotionData];
    }
    else
    {
    
    }
}

#pragma mark - View lifecycle
-(void)actionShow:(NSDictionary *)dic
{
    if([[dic objectForKey:@"xx"] floatValue] < -0.9)
    {
        iskk = YES;
        begin = [[dic objectForKey:@"tt"] floatValue];
    }
    
    if(iskk && [[dic objectForKey:@"xx"] floatValue] > 0.4)
    {
        isJJ = YES;
        end = [[dic objectForKey:@"tt"] floatValue];
    }
    
    if(iskk && isJJ)
    {
//        float v =  end - begin;
        self.timeLabel.text = [NSString stringWithFormat:@"%d",countNum++];
        if([self isSuccessUnLock])
        {
            //解锁功能  并且接锁成功
            [self completeUnlock];
        }
        iskk = NO;
        isJJ = NO;
    }
}

-(void)xyz:(NSString *)xx y:(NSString *)yy z:(NSString *)zz timestamp:(NSString *)time
{
    NSDictionary *d = [[NSDictionary alloc] initWithObjectsAndKeys:xx,@"xx",yy,@"yy",zz,@"zz",time,@"tt", nil];
    [self performSelectorOnMainThread:@selector(actionShow:) withObject:d waitUntilDone:YES];
}

-(void)timeFire
{
    __block int timeout=5; //倒计时时间
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,queue);
    dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0),1.0*NSEC_PER_SEC, 0); //每秒执行
    dispatch_source_set_event_handler(_timer, ^{
        if(timeout<0)
        { //倒计时结束，关闭
            dispatch_source_cancel(_timer);
            dispatch_async(dispatch_get_main_queue(), ^{
                //设置界面的按钮显示 根据自己需求设置
                [self actionStartSport];
                [self changeSliderStyle];
            });
        }
        else
        {
            [self performSelectorOnMainThread:@selector(actionUpdate:) withObject:[NSString stringWithFormat:@"%d",timeout--] waitUntilDone:YES];
        }
    });
    dispatch_resume(_timer);
}

-(void)actionUpdate:(NSString *)sender
{
    _timeLabel.text = sender;
}

-(void)showTraining
{
    [UIView animateWithDuration:0.3 animations:^{
        //

    } completion:^(BOOL finished) {
        //
    }];
}

-(IBAction)actionOK:(id)sender
{
    [_timeKit invalidate];
    _timeKit = nil;
    if(![self.formWhere isEqualToString:@"BlueViewController"])
    {
        self.timeLabel.hidden = YES;
    }
    [_myDataLogger stopLoggingMotionDataAndSave];
    
    UIDevice *_curDevice = [UIDevice currentDevice];
    [_curDevice setProximityMonitoringEnabled:NO];
    
    if(self.observe)
    {
        [[NSNotificationCenter defaultCenter] removeObserver:self.observe];
        self.observe = nil;
    }

    //此处延时执行 让face多显示一会
    [self performSelector:@selector(actionReturn) withObject:nil afterDelay:0.7];
}

-(void)actionReturn
{
    NSString *score = [NSString stringWithFormat:@"%@",_timeLabel.text];
    NSString *dur = [NSString stringWithFormat:@"%d",_timeNumber-5];
    if(self.delegate && [self.delegate respondsToSelector:@selector(closeBlackGroundView:score:duration:)])
    {
        [self.delegate closeBlackGroundView:self score:score duration:dur];
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
