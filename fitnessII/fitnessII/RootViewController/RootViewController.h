//
//  RootViewController.h
//  FitnessScene
//
//  Created by Haley on 15/5/21.
//  Copyright (c) 2015年 samples.hankang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LoginModel.h"

@interface RootViewController : UIViewController

@property (nonatomic, retain) LoginModel *loginModel;
-(void)getFMBModelWithLModle:(LoginModel *)model;

-(void)setNavTitleWithKaiti:(NSString *)title;
- (void)setNavTitleWithDFPShaoNvW5:(NSString *)title;
- (void)setNavTitle:(NSString *)title;
- (void)setNavTitle:(NSString *)title color:(UIColor *)color;
- (void)setNavTitleWithImage:(UIImage *)image;
//navgation 自定义标题View
- (void)setCustomTitleViewWithImage:(UIImage *)image orView:(UIView *)view WithFrame:(CGRect)frame;

- (void)setLeftButtonWithNormalImage:(UIImage *)image HighlightedImage:(UIImage *)hImage target:(id)target selector:(SEL)selector;

- (void)setLeftButtonTitle:(NSString *)title image:(UIImage *)image target:(id)target selector:(SEL)selector;

- (void)setRightButtonImage:(UIImage *)image target:(id)target selector:(SEL)selector;

//左右带字按钮
- (void)setLeftButtonTitle:(NSString *)title font:(UIFont *)f target:(id)target selector:(SEL)selector ;
- (void)setRightButtonTitle:(NSString *)title font:(UIFont *)f target:(id)target selector:(SEL)selector;

/**
 一般用来显示出错了, 过一段时间自动消失
 
 @param      error 需要显示的文字
 */
- (void)displayErrorHUDWithText:(NSString *)error;
- (void)displayErrorHUDWithTextOnWindow:(NSString *)error;
/**
 一般用来显示loading, 过一段时间不会消失，需要调用hideHUD方法使消失
 
 @param      text 需要显示的文字
 @see        hideHUD
 */
- (void)showLoadingHUDWithText:(NSString *)text;
/**
 隐藏loading, 一般与showLoadingHUDWithText:成对调用
 
 @see        showLoadingHUDWithText:
 */

- (void)showLoadingHUD;

- (void)hideHUD;

/**
 当前试图控制器出栈
 */
- (void)actionBack:(id)sender;
-(void)actionBackToResider:(id)sender;

-(BOOL)isInternetConnection;

@end
