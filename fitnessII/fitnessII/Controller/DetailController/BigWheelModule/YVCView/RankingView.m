//
//  RankingView.m
//  fitnessII
//
//  Created by Haley on 15/7/12.
//  Copyright (c) 2015年 samples.hankang. All rights reserved.
//

#import "RankingView.h"
#import "RankVCell.h"
#define YELLOWCOLOR UIColorFromRGB(0x39a874)
#define BLUECOLOR   UIColorFromRGB(0x3F7BC9)
@implementation RankingView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
    }
    return self;
}

-(void)changeColor:(NSString *)colorTag
{
    _colorT = colorTag;
    if([colorTag isEqualToString:@"Y"])
    {
        self.titleLabel.textColor = YELLOWCOLOR;
        self.timeLabel.textColor = YELLOWCOLOR;
        self.lineImageV.backgroundColor = YELLOWCOLOR;
        self.bestLabel.textColor = YELLOWCOLOR;
        
        [_tableV reloadData];
    }
    else
    {
        self.titleLabel.textColor = BLUECOLOR;
        self.timeLabel.textColor = BLUECOLOR;
        self.lineImageV.backgroundColor = BLUECOLOR;
        self.bestLabel.textColor = BLUECOLOR;
        
        [_tableV reloadData];
    }
}

-(void)awakeFromNib
{
    [super awakeFromNib];
    _tableV.separatorStyle = UITableViewCellSeparatorStyleNone;
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_dataArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"identifier";
    RankVCell *cell = (RankVCell *)[tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[NSBundle mainBundle] loadNibNamed:@"RankVCell" owner:self options:nil][0];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if([_colorT isEqualToString:@"Y"])
    {
        cell.timeLabel.textColor = YELLOWCOLOR;
        cell.valueLabel.textColor = YELLOWCOLOR;
        cell.lineIV.backgroundColor = YELLOWCOLOR;
    }
    else
    {
        cell.timeLabel.textColor = BLUECOLOR;
        cell.valueLabel.textColor = BLUECOLOR;
        cell.lineIV.backgroundColor = BLUECOLOR;
    }
    if(_dataArray && [_dataArray count] > 0)
    {
        cell.timeLabel.text = [[_dataArray objectAtIndex:indexPath.row] objectForKey:@"Time"];
        cell.valueLabel.text = [[_dataArray objectAtIndex:indexPath.row] objectForKey:@"Score"];
    }
    return cell;
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return self.headView.frame.size.height;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    
    return self.headView;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 50;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
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
