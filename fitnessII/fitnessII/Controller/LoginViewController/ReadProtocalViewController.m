//
//  ReadProtocalViewController.m
//  fitnessII
//
//  Created by Haley on 15/8/17.
//  Copyright (c) 2015年 samples.hankang. All rights reserved.
//

#import "ReadProtocalViewController.h"

@interface ReadProtocalViewController ()

@end

@implementation ReadProtocalViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)viewWillAppear:(BOOL)animated
{
    self.navigationController.navigationBarHidden = NO;
}

//- (void)webViewDidFinishLoad:(UIWebView *)webView
//{
//    //字体大小
//    [webView stringByEvaluatingJavaScriptFromString:@"document.getElementsByTagName('body')[0].style.webkitTextSizeAdjust= '120%'"];
//    //字体颜色
//    [webView stringByEvaluatingJavaScriptFromString:@"document.getElementsByTagName('body')[0].style.webkitTextFillColor= 'red'"];
//    //页面背景色
//    [webView stringByEvaluatingJavaScriptFromString:@"document.getElementsByTagName('body')[0].style.background='#2E2E2E'"];
//}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self setNavTitleWithKaiti:@"应用服务协议"];
    [self setLeftButtonTitle:nil image:[UIImage imageNamed:@"arrow.png"] target:self selector:@selector(actionBack:)];
    
    UIWebView *web = [[UIWebView alloc] init];
    if(iPhone4S)
    {
        web.frame = CGRectMake(0, 0, self.view.bounds.size.width, self.view.frame.size.height-64-84);
    }
    else
    {
        web.frame = CGRectMake(0, 0, self.view.bounds.size.width, self.view.frame.size.height-64);
    }

    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://%@/Announce",HostName]];
    
    // 2. 把URL告诉给服务器,请求,从m.baidu.com请求数据
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    [web loadRequest:request];
    [self.view addSubview:web];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
