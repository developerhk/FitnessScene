//
//  DetailView.h
//  fitnessII
//
//  Created by Haley on 15/7/12.
//  Copyright (c) 2015年 samples.hankang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FamilyMembersModel.h"

@protocol DetailViewDelegate <NSObject>

-(void)actionPressWithButtonAttribute:(int)tag;

@end

@interface DetailView : UIView

@property (nonatomic, assign) id<DetailViewDelegate> dvDelegate;


@property (nonatomic, strong) IBOutlet UIButton *headBut;    //20
@property (nonatomic, strong) IBOutlet UIButton *starBut;    //22
@property (nonatomic, strong) IBOutlet UIButton *jtpmBut;    //23
@property (nonatomic, strong) IBOutlet UIButton *tzpjBut;    //24
@property (nonatomic, strong) IBOutlet UIButton *gbcpBut;    //25
@property (nonatomic, strong) IBOutlet UIButton *zwdlBut;    //26
@property (nonatomic, strong) IBOutlet UIButton *xlfdBut;    //27

@property (nonatomic, strong) IBOutlet UIButton *firBut;    //30
@property (nonatomic, strong) IBOutlet UIButton *ssBut;     //31
@property (nonatomic, strong) IBOutlet UIButton *ttBut;     //32
@property (nonatomic, strong) IBOutlet UIButton *ffBut;     //33
@property (nonatomic, strong) IBOutlet UIButton *fffBut;     //34

@end
