//
//  RootViewController.m
//  FitnessScene
//
//  Created by Haley on 15/5/21.
//  Copyright (c) 2015年 samples.hankang. All rights reserved.
//

#import "RootViewController.h"
#import "MBProgressHUD.h"
#import "SCGIFImageView.h"
#import "AppDelegate.h"
#import "MainViewController.h"

#define title_font  [UIFont systemFontOfSize:16.0f]
#define DMsgWidth 260.0f
#define DErrTextFont [UIFont systemFontOfSize:15.0f]
#define DErrTextHeight 19.0f

@interface RootViewController ()
{
    SCGIFImageView *_gifImageView;
}
@end

@implementation RootViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)getFMBModelWithLModle:(LoginModel *)model
{
    self.loginModel = model;
    [[NSUserDefaults standardUserDefaults] setObject:model.gender forKey:LoginUserGender];
    [[NSUserDefaults standardUserDefaults] setObject:model.headPic forKey:LoginUserHead];
    [[NSUserDefaults standardUserDefaults] setObject:model.nickName forKey:LoginUserNickName];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(hideHUD) name:@"RemoveAllHudsNotification" object:nil];
    
    if(IOS7_OR_LATER)
    {
        self.edgesForExtendedLayout =UIRectEdgeNone;
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
}
- (void)setNavTitleWithImage:(UIImage *)image
{
    [self setCustomTitleViewWithImage:image orView:nil WithFrame:CGRectMake(0, 0, image.size.width, image.size.height)];
}

- (void)setNavTitle:(NSString *)title color:(UIColor *)color
{
    UILabel *titleLb = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 180, 44)];
    titleLb.backgroundColor = [UIColor clearColor];
    titleLb.font = [UIFont boldSystemFontOfSize:18.0];
    titleLb.textColor = color;
    titleLb.textAlignment = TextAlignmentCenter;
    titleLb.text = title;
    [self setCustomTitleViewWithImage:nil orView:titleLb WithFrame:CGRectZero];
}

- (void)setNavTitle:(NSString *)title
{
    UILabel *titleLb = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 180, 44)];
    titleLb.backgroundColor = [UIColor clearColor];
    titleLb.font = [UIFont boldSystemFontOfSize:18.0];
    titleLb.textColor = [UIColor blackColor];
    titleLb.textAlignment = TextAlignmentCenter;
    titleLb.text = title;
    [self setCustomTitleViewWithImage:nil orView:titleLb WithFrame:CGRectZero];
}

- (void)setNavTitleWithDFPShaoNvW5:(NSString *)title
{
    UILabel *titleLb = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 180, 44)];
    titleLb.backgroundColor = [UIColor clearColor];
    titleLb.font = [UIFont fontWithName:@"DFPShaoNvW5" size:18];
    titleLb.textColor = [UIColor blackColor];
    titleLb.textAlignment = TextAlignmentCenter;
    titleLb.text = title;
    [self setCustomTitleViewWithImage:nil orView:titleLb WithFrame:CGRectZero];
}
-(void)setNavTitleWithKaiti:(NSString *)title
{
    UILabel *titleLb = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 180, 44)];
    titleLb.backgroundColor = [UIColor clearColor];
    titleLb.font = [UIFont systemFontOfSize:16];//[UIFont fontWithName:@"STKaiti" size:22];
    titleLb.textColor = [UIColor blackColor];
    titleLb.textAlignment = TextAlignmentCenter;
    titleLb.text = title;
    [self setCustomTitleViewWithImage:nil orView:titleLb WithFrame:CGRectZero];
}

- (void)setCustomTitleViewWithImage:(UIImage *)image orView:(UIView *)view WithFrame:(CGRect)frame
{
    if (image) {
        UIImageView *v = [[UIImageView alloc] initWithFrame:frame];
        v.image = image;
        self.navigationItem.titleView = v;
    }
    else {
        self.navigationItem.titleView = view;
    }
}

- (void)setLeftButtonWithNormalImage:(UIImage *)image HighlightedImage:(UIImage *)hImage target:(id)target selector:(SEL)selector
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setFrame:CGRectMake(0, 0, image.size.width, image.size.height)];
    [button addTarget:target action:selector forControlEvents:UIControlEventTouchUpInside];
    [button setBackgroundImage:image forState:UIControlStateNormal];
    [button setBackgroundImage:hImage forState:UIControlStateHighlighted];
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    self.navigationItem.leftBarButtonItem = backItem;
}

- (void)setLeftButtonTitle:(NSString *)title image:(UIImage *)image target:(id)target selector:(SEL)selector {
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setFrame:CGRectMake(0, 0, image.size.width, image.size.height)];
    if (title && [title length] > 0) {
        [button setTitle:title forState:UIControlStateNormal];
        [button.titleLabel setFont:title_font];
    }
    [button addTarget:target action:selector forControlEvents:UIControlEventTouchUpInside];
    [button setBackgroundImage:image forState:UIControlStateNormal];
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    self.navigationItem.leftBarButtonItem = backItem;
}

- (void)setRightButtonImage:(UIImage *)image target:(id)target selector:(SEL)selector
{
    if (image) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
		[button setBackgroundImage:image forState:UIControlStateNormal];
        [button setFrame:CGRectMake(0, 0, image.size.width, image.size.height)];
		[button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
		[button setTitleColor:[UIColor colorWithRed:143.0/255.0 green:177.0/255.0 blue:204.0/255.0 alpha:1.0] forState:UIControlStateDisabled];
        [button.titleLabel setFont:title_font];
		//        [button.titleLabel setShadowColor:[UIColor blackColor]];
		//        [button.titleLabel setShadowOffset:CGSizeMake(0, -1)];
		//        [button setBackgroundImage:image forState:UIControlStateNormal];
        [button addTarget:target action:selector forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithCustomView:button];
        self.navigationItem.rightBarButtonItem = backItem;
    }
    else {
        self.navigationItem.rightBarButtonItem = nil;
    }
}

- (void)setLeftButtonTitle:(NSString *)title font:(UIFont *)f target:(id)target selector:(SEL)selector {
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setFrame:CGRectMake(0, 0, 40, 30)];
    if (title && [title length] > 0) {
        [button setTitle:title forState:UIControlStateNormal];
        [button.titleLabel setFont:f];
        [button setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        button.titleEdgeInsets = UIEdgeInsetsMake(0, -10, 0, 0);
    }
    [button addTarget:target action:selector forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    self.navigationItem.leftBarButtonItem = backItem;
}
- (void)setRightButtonTitle:(NSString *)title font:(UIFont *)f target:(id)target selector:(SEL)selector {
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setFrame:CGRectMake(0, 0, 45, 30)];
    if (title && [title length] > 0) {
        [button setTitle:title forState:UIControlStateNormal];
        [button setTitleColor:UIColorFromRGB(0xFF7171) forState:UIControlStateNormal];
        button.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, -15);
    }
    button.titleLabel.font = f;
    [button addTarget:target action:selector forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    self.navigationItem.rightBarButtonItem = backItem;
}

// 内部方法，global决定是贴在view上还是window上
- (void)displayErrorHUDWithText:(NSString *)error global:(BOOL)global
{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:global?self.view.window:self.view
                                              animated:YES];
    // Configure for text only and offset down
    hud.mode = MBProgressHUDModeCustomView;
    //    hud.labelText = error;
    if(error == nil || error.length == 0)
    {
         return;
    }
    NSString *msg2Show = [NSString stringWithString:error];
    CGSize msgSize = [msg2Show sizeWithFont:DErrTextFont
                          constrainedToSize:CGSizeMake(DMsgWidth, MAXFLOAT)
                              lineBreakMode:LineBreakByWordWrapping];
    
    int lines = (int)ceilf(msgSize.height / DErrTextHeight);
    
    UILabel *textLabel = [[UILabel alloc]initWithFrame:CGRectMake(0.0f, 0.0f, msgSize.width, DErrTextHeight * lines)];
    [textLabel setTextAlignment:TextAlignmentCenter];
    [textLabel setLineBreakMode:LineBreakByWordWrapping];
    [textLabel setText:msg2Show];
    [textLabel setFont:DErrTextFont];
    [textLabel setTextColor:[UIColor whiteColor]];
    [textLabel setBackgroundColor:[UIColor clearColor]];
    [textLabel setNumberOfLines:lines];
    hud.customView = textLabel;
    
    hud.margin = 20.f;
    //    hud.yOffset = 0.f;
    hud.removeFromSuperViewOnHide = YES;
    [hud hide:YES afterDelay:2.0f];
}

- (void)displayErrorHUDWithTextOnWindow:(NSString *)error
{
    [self displayErrorHUDWithText:error global:YES];
}
- (void)displayErrorHUDWithText:(NSString *)error
{
    [self displayErrorHUDWithText:error global:NO];
}

// 内部方法，global决定是贴在view上还是window上
- (void)showGlobalLodingHUDWithText:(NSString *)text global:(BOOL)global
{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:global?self.view.window:self.view animated:YES];
    hud.labelText = text;
    hud.labelFont = DErrTextFont;
    hud.margin = 20.0f;
}

- (void)showLoadingHUDWithText:(NSString *)text {
    [self showGlobalLodingHUDWithText:text global:NO];
}

- (void)showLoadingHUD
{
    MBProgressHUD *hud = [MBProgressHUD showHUDForFitnessAddedTo:self.view];
    hud.margin = 20.0f;
}

- (void)hideHUD {
    [MBProgressHUD hideHUDForView:self.view animated:NO];
    [MBProgressHUD hideAllHUDsForView:self.view.window animated:NO];
}

- (void)actionBack:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)actionBackToResider:(id)sender
{
    AppDelegate *delegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
    MainViewController *controller = [[MainViewController alloc] init];
    [[NSNotificationCenter defaultCenter] postNotificationName:showMenuNotification object:nil];
    [self.sideMenuViewController setContentViewController:[delegate.navgationController initWithRootViewController:controller] animated:YES];
}

-(void)showSpecialLoading
{
    if ([[Reachability reachabilityForInternetConnection]isReachable]) {
        _gifImageView = [[SCGIFImageView alloc]initWithGIFFile:[[NSBundle mainBundle]pathForResource:@"loadingS" ofType:@"gif"]];
        _gifImageView.contentMode = UIViewContentModeCenter;
        _gifImageView.frame = CGRectMake(self.view.bounds.size.width/2 - 15, 200, 30, 30);
        _gifImageView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
        [self.view addSubview:_gifImageView];
    }
}

-(void)hideSpecialLoading
{
    [_gifImageView stop];
    [_gifImageView removeFromSuperview];
}

-(BOOL)isInternetConnection
{
    if ([[Reachability reachabilityForInternetConnection]isReachable])
    {
        return YES;
    }
    else
    {
        return NO;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
