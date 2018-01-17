//
//  GreenViewController.h
//  fitnessII
//
//  Created by Haley on 15/7/12.
//  Copyright (c) 2015年 samples.hankang. All rights reserved.
//

#import "RootViewController.h"
#import "TYMProgressBarView.h"

@interface GreenViewController : RootViewController
@property (nonatomic, strong) IBOutlet UIWebView *webView;
@property (nonatomic, strong) IBOutlet UIButton *recipeBut;

-(id)initWithUserID:(NSString *)userID;

@end
