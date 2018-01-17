//
//  BlueSPView.m
//  fitnessII
//
//  Created by Haley on 15/8/11.
//  Copyright (c) 2015年 samples.hankang. All rights reserved.
//

#import "BlueSPView.h"

@implementation BlueSPView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

-(void)awakeFromNib
{
    [super awakeFromNib];
}

-(void)showMessageWithRank:(NSArray *)dataArr
{
    if([dataArr count] > 0)
    {
        NSDictionary *d1 = [dataArr objectAtIndex:0];
        NSDictionary *d2 = [dataArr objectAtIndex:1];
        if([[d1 objectForKey:@"RankType"] isEqualToString:@"R1"])
        {
            self.rankS.text = [d1 objectForKey:@"Position"];
            self.myScoreS.text = [d1 objectForKey:@"MyTopScore"];
            self.bestScoreS.text = [d1 objectForKey:@"AllTopScore"];
            
            self.rankL.text = [d2 objectForKey:@"Position"];
            self.myScoreL.text = [d2 objectForKey:@"MyTopScore"];
            self.bestScoreL.text = [d2 objectForKey:@"AllTopScore"];
        }
        else
        {
            self.rankS.text = [d2 objectForKey:@"Position"];
            self.myScoreS.text = [d2 objectForKey:@"MyTopScore"];
            self.bestScoreS.text = [d2 objectForKey:@"AllTopScore"];
            
            self.rankL.text = [d1 objectForKey:@"Position"];
            self.myScoreL.text = [d1 objectForKey:@"MyTopScore"];
            self.bestScoreL.text = [d1 objectForKey:@"AllTopScore"];
        }
    }
    else
    {
        self.rankS.text = @"0";
        self.myScoreS.text = @"0";
        self.bestScoreS.text = @"0";
        
        self.rankL.text = @"0";
        self.myScoreL.text = @"0";
        self.bestScoreL.text =  @"0";
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
