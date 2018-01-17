//
//  OverView.m
//  fitnessII
//
//  Created by Haley on 15/7/12.
//  Copyright (c) 2015年 samples.hankang. All rights reserved.
//

#import "OverView.h"
#define YELLOWCOLOR UIColorFromRGB(0x39a874)
#define BLUECOLOR   UIColorFromRGB(0x3F7BC9)
@implementation OverView

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

-(void)changeColor:(NSString *)colorTag
{
    self.bjpm.hidden = NO;
    self.bjpmL.hidden = NO;
    self.bjpmR.hidden = NO;
    self.bjzj.hidden = NO;
    self.bjLine.hidden = NO;
    self.njpm.hidden = NO;
    self.njpmL.hidden = NO;
    self.njpmR.hidden = NO;
    self.njzj.hidden = NO;
    self.njLine.hidden = NO;
    
    self.banP.hidden = NO;
    self.banZ.hidden = NO;
    self.banB.hidden = NO;
    self.nianP.hidden = NO;
    self.nianZ.hidden = NO;
    self.nianB.hidden = NO;
    if([colorTag isEqualToString:@"Y"])
    {
        self.bjpm.textColor = YELLOWCOLOR;
        self.bjpmL.textColor = YELLOWCOLOR;
        self.bjpmR.textColor = YELLOWCOLOR;
        self.bjzj.textColor = YELLOWCOLOR;
        self.bjLine.backgroundColor = YELLOWCOLOR;
        self.njpm.textColor = YELLOWCOLOR;
        self.njpmL.textColor = YELLOWCOLOR;
        self.njpmR.textColor = YELLOWCOLOR;
        self.njzj.textColor = YELLOWCOLOR;
        self.njLine.backgroundColor = YELLOWCOLOR;

        self.banP.textColor = YELLOWCOLOR;
        self.banZ.textColor = YELLOWCOLOR;
        self.banB.textColor = YELLOWCOLOR;
        self.nianP.textColor = YELLOWCOLOR;
        self.nianZ.textColor = YELLOWCOLOR;
        self.nianB.textColor = YELLOWCOLOR;
        
        self.cutLine.hidden = NO;
        self.guoBIV.hidden = NO;
        self.colorType.hidden = NO;
        self.encourageLabel.hidden = NO;
    }
    else if([colorTag isEqualToString:@"BMI"])
    {
        self.bjpm.hidden = YES;
        self.bjpmL.hidden = YES;
        self.bjpmR.hidden = YES;
        self.bjzj.hidden = YES;
        self.bjLine.hidden = YES;
        self.njpm.hidden = YES;
        self.njpmL.hidden = YES;
        self.njpmR.hidden = YES;
        self.njzj.hidden = YES;
        self.njLine.hidden = YES;
        
        self.banP.hidden = YES;
        self.banZ.hidden = YES;
        self.banB.hidden = YES;
        self.nianP.hidden = YES;
        self.nianZ.hidden = YES;
        self.nianB.hidden = YES;
        
        self.cutLine.hidden = YES;
        self.guoBIV.hidden = NO;
        self.colorType.hidden = NO;
        self.encourageLabel.hidden = NO;
    }
    else
    {
        self.bjpm.textColor = BLUECOLOR;
        self.bjpmL.textColor = BLUECOLOR;
        self.bjpmR.textColor = BLUECOLOR;
        self.bjzj.textColor = BLUECOLOR;
        self.bjLine.backgroundColor = BLUECOLOR;
        self.njpm.textColor = BLUECOLOR;
        self.njpmL.textColor = BLUECOLOR;
        self.njpmR.textColor = BLUECOLOR;
        self.njzj.textColor = BLUECOLOR;
        self.njLine.backgroundColor = BLUECOLOR;
        
        self.banP.textColor = BLUECOLOR;
        self.banZ.textColor = BLUECOLOR;
        self.banB.textColor = BLUECOLOR;
        self.nianP.textColor = BLUECOLOR;
        self.nianZ.textColor = BLUECOLOR;
        self.nianB.textColor = BLUECOLOR;
        
        self.cutLine.hidden = YES;
        self.guoBIV.hidden = YES;
        self.colorType.hidden = YES;
        self.encourageLabel.hidden = YES;

    }
}

-(void)showMessageWithDegree:(NSDictionary *)dataDic currentScore:(NSString *)score isBMI:(BOOL)isBMI
{
    self.encourageLabel.text = [dataDic objectForKey:@"Description"]?[dataDic objectForKey:@"Description"]:@"";
    
    //red.png orange.png blue.png green1.png
    NSString *stdVal = [dataDic objectForKey:@"StdVal"];
    int stdLevel = [[dataDic objectForKey:@"StdLevel"] intValue];
    if(stdVal.length < 1)
    {
        //此项目没有国标
        self.colorType.hidden = YES;
        self.cutLine.hidden = YES;
        self.guoBIV.hidden = YES;
        self.encourageLabel.text = @"";
        return;
    }
    else
    {
        self.cutLine.hidden = NO;
        self.guoBIV.hidden = NO;
        self.colorType.hidden = NO;
    }
    NSArray *arr = [stdVal componentsSeparatedByString:@";"];
    float sco = [[dataDic objectForKey:@"MyScore"] floatValue];//[score floatValue];
    float low = [[arr objectAtIndex:0] floatValue];
    float bet = [[arr objectAtIndex:1] floatValue];
    float high = [[arr objectAtIndex:2] floatValue];
    self.colorType.hidden = NO;
    if(isBMI)
    {
        [self changeColor:@"BMI"];
        self.colorType.hidden = NO;
        switch (stdLevel) {
            case 1:
            {
                //红色
                self.colorType.image = [UIImage imageNamed:@"red.png"];
                self.colorType.frame = CGRectMake(18, 168, 69, 20);
            }
                break;
            case 2:
            {
                self.colorType.image = [UIImage imageNamed:@"green.png"];
                self.colorType.frame = CGRectMake(18+69+1, 168, 60, 20);
            }
                break;
            case 3:
            {
                self.colorType.image = [UIImage imageNamed:@"red.png"];
                self.colorType.frame = CGRectMake(69+60+ 18+1, 168, 60, 20);
            }
                break;
            case 4:
            {
                self.colorType.image = [UIImage imageNamed:@"red.png"];
                self.colorType.frame = CGRectMake(69+120 + 18+1, 168, 60, 20);
            }
                break;
            default:
            {
                self.colorType.hidden =YES;
            }
                break;
        }
        self.guoBIV.frame = CGRectMake(self.guoBIV.frame.origin.x, 95, self.guoBIV.frame.size.width, self.guoBIV.frame.size.height);
        self.colorType.frame = CGRectMake(self.colorType.frame.origin.x, 168 - 50, self.colorType.frame.size.width, self.colorType.frame.size.height);
        self.encourageLabel.frame = CGRectMake(self.encourageLabel.frame.origin.x, 225 - 50, self.encourageLabel.frame.size.width, self.encourageLabel.frame.size.height);
        return;
    }
    self.guoBIV.frame = CGRectMake(self.guoBIV.frame.origin.x, 95+50, self.guoBIV.frame.size.width, self.guoBIV.frame.size.height);
    self.colorType.frame = CGRectMake(self.colorType.frame.origin.x, 168, self.colorType.frame.size.width, self.colorType.frame.size.height);
    self.encourageLabel.frame = CGRectMake(self.encourageLabel.frame.origin.x, CGRectGetMaxY(self.guoBIV.frame) + 5, self.encourageLabel.frame.size.width, self.encourageLabel.frame.size.height);
    
    self.colorType.hidden = NO;
    switch (stdLevel) {
        case 1:
        {
            //红色
            self.colorType.image = [UIImage imageNamed:@"red.png"];
            self.colorType.frame = CGRectMake(18, 168, 69, 20);
        }
            break;
        case 2:
        {
            //黄色
            self.colorType.image = [UIImage imageNamed:@"orange.png"];
            self.colorType.frame = CGRectMake(18+69+1, 168, 60, 20);
        }
            break;
        case 3:
        {
            //蓝色
            self.colorType.image = [UIImage imageNamed:@"blue.png"];
            self.colorType.frame = CGRectMake(69+60+ 18+1, 168, 60, 20);
        }
            break;
        case 4:
        {
            //绿色
            self.colorType.image = [UIImage imageNamed:@"green.png"];
            self.colorType.frame = CGRectMake(69+120 + 18+1, 168, 60, 20);
        }
            break;
        default:
        {
            self.colorType.hidden =YES;
        }
            break;
    }
}

-(void)showMessageWithRank:(NSArray *)dataArr
{
    if([dataArr count] > 0)
    {
        NSDictionary *d1 = [dataArr objectAtIndex:0];
        NSDictionary *d2 = [dataArr objectAtIndex:1];
        if([[d1 objectForKey:@"RankType"] isEqualToString:@"R1"])
        {
            self.banP.text = [NSString stringWithFormat:@"%@",[d1 objectForKey:@"Position"]];
            self.banZ.text = [NSString stringWithFormat:@"/%@",[d1 objectForKey:@"Cnt"]];
            self.banB.text = [NSString stringWithFormat:@"%@",[d1 objectForKey:@"TopScore"]];
            
            self.nianP.text = [NSString stringWithFormat:@"%@",[d2 objectForKey:@"Position"]];
            self.nianZ.text = [NSString stringWithFormat:@"/%@",[d2 objectForKey:@"Cnt"]];
            self.nianB.text = [NSString stringWithFormat:@"%@",[d2 objectForKey:@"TopScore"]];
        }
        else
        {
            self.banP.text = [NSString stringWithFormat:@"%@",[d2 objectForKey:@"Position"]];
            self.banZ.text = [NSString stringWithFormat:@"/%@",[d2 objectForKey:@"Cnt"]];
            self.banB.text = [NSString stringWithFormat:@"%@",[d2 objectForKey:@"TopScore"]];
            
            self.nianP.text = [NSString stringWithFormat:@"%@",[d1 objectForKey:@"Position"]];
            self.nianZ.text = [NSString stringWithFormat:@"/%@",[d1 objectForKey:@"Cnt"]];
            self.nianB.text = [NSString stringWithFormat:@"%@",[d1 objectForKey:@"TopScore"]];
        }
    }
    else
    {
        self.banP.text = @"0";
        self.banZ.text = [NSString stringWithFormat:@"/%@", @"0"];
        self.banB.text = @"0";
        
        self.nianP.text = @"0";
        self.nianZ.text = [NSString stringWithFormat:@"/%@", @"0"];
        self.nianB.text =  @"0";
    }
}

-(void)layoutSubviews
{
    [super layoutSubviews];
}

@end
