//
//  UnLockView.m
//  fitnessII
//
//  Created by Haley on 15/11/23.
//  Copyright (c) 2015年 samples.hankang. All rights reserved.
//

#import "UnLockView.h"

@implementation UnLockView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

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

-(UIImage *)imageWithProID:(NSString *)idd
{
    int tag = [idd intValue];
    switch (tag) {
        case 103:
        {
            return [UIImage imageNamed:@"task_unlock_pbzc"];
        }
            break;
        case 101:
        {
            return [UIImage imageNamed:@"task_unlock_ywqz"];
        }
            break;
        case 102:
        {
            return [UIImage imageNamed:@"task_unlock_fwc"];
        }
            break;
        case 100:
        {
            return [UIImage imageNamed:@"task_unlock_xd"];
        }
            break;
        default:
            break;
    }
    return nil;
}

-(NSString *)showMessageWithProID:(NSString *)idd
{
    int tag = [idd intValue];
    switch (tag) {
        case 103:
        {
            return TEXT_PBZC;
        }
            break;
        case 101:
        {
            return TEXT_YWQZ;
        }
            break;
        case 102:
        {
            return TEXT_FWC;
        }
            break;
        case 100:
        {
            return TEXT_SD;
        }
            break;
            
        default:
            break;
    }
    return @"";
}

-(void)showMessageWithDic:(NSDictionary *)dic
{
    NSString *name = [dic objectForKey:@"ProgramName"];
    NSString *proID = [dic objectForKey:@"ProgramID"];
    NSString *repeat = [dic objectForKey:@"RepeatTimes"];
    
    self.taskLabel.text = [NSString stringWithFormat:@"任务: 在手机检测下完成%@%@%@",name,repeat,[name isEqualToString:@"平板支撑"]?@"秒":@"个"];
    
    self.actionIV.image = [self imageWithProID:proID];
    
    self.detailLabel.text = [self showMessageWithProID:proID];
    
}

-(IBAction)actionDelete:(id)sender
{
    if(self.dmBlock)
    {
        self.dmBlock();
    }
}

-(IBAction)actionGo:(id)sender
{
    if(self.gBlock)
    {
        self.gBlock();
    }
}

@end
