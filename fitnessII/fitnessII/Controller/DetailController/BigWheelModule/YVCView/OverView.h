//
//  OverView.h
//  fitnessII
//
//  Created by Haley on 15/7/12.
//  Copyright (c) 2015年 samples.hankang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OverView : UIView

@property (nonatomic, strong) IBOutlet UILabel *classNo;
/*************变色特有*****************/
@property (nonatomic, strong) IBOutlet UILabel *bjpm;
@property (nonatomic, strong) IBOutlet UILabel *bjpmL;
@property (nonatomic, strong) IBOutlet UILabel *bjpmR;
@property (nonatomic, strong) IBOutlet UILabel *bjzj;
@property (nonatomic, strong) IBOutlet UIImageView *bjLine;

@property (nonatomic, strong) IBOutlet UILabel *njpm;
@property (nonatomic, strong) IBOutlet UILabel *njpmL;
@property (nonatomic, strong) IBOutlet UILabel *njpmR;
@property (nonatomic, strong) IBOutlet UILabel *njzj;
@property (nonatomic, strong) IBOutlet UIImageView *njLine;

@property (nonatomic, strong) IBOutlet UIImageView *cutLine;
/*************变色特有*****************/

@property (nonatomic, strong) IBOutlet UILabel *banP;
@property (nonatomic, strong) IBOutlet UILabel *banZ;
@property (nonatomic, strong) IBOutlet UILabel *banB;

@property (nonatomic, strong) IBOutlet UILabel *nianP;
@property (nonatomic, strong) IBOutlet UILabel *nianZ;
@property (nonatomic, strong) IBOutlet UILabel *nianB;

@property (nonatomic, strong) IBOutlet UIImageView *guoBIV;

@property (nonatomic, strong) IBOutlet UILabel *encourageLabel;

@property (nonatomic, strong) IBOutlet UIImageView *colorType;

-(void)showMessageWithDegree:(NSDictionary *)dataDic currentScore:(NSString *)score isBMI:(BOOL)isBMI;
-(void)showMessageWithRank:(NSArray *)dataArr;
-(void)changeColor:(NSString *)colorTag;
@end
