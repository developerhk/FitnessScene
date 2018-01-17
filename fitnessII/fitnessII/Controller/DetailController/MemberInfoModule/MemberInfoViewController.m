//
//  MemberInfoViewController.m
//  fitnessII
//
//  Created by Haley on 15/8/26.
//  Copyright (c) 2015年 samples.hankang. All rights reserved.
//

#import "MemberInfoViewController.h"
#import "UIImageView+WebCache.h"
#import "SDImageCache.h"
#import "ImageManager.h"
#import "FMUString.h"

@interface MemberInfoViewController ()
{
    NSString *_useID;
    UIImagePickerController *_pickerController;

    UIImage *_defaultImage;
    
    BOOL isAllowToChange;
    
    NSString *_newHeadImageStr;
    
    NSString *_nickN;
    NSString *_realN;
    
    BOOL issLoginUser;
}

@end

@implementation MemberInfoViewController

-(id)initWithNothing
{
    self = [super init];
    if (self) {
        // Custom initialization
        NSString *userID = [[NSUserDefaults standardUserDefaults] objectForKey:USERID];
        NSString *gender = [[NSUserDefaults standardUserDefaults] objectForKey:LoginUserGender];
        
        _useID = userID;
        //Gender：性别（B：男孩；G：女孩；F:女士；M：男士）
        if([gender isEqualToString:@"B"])    //boy
        {
            _defaultImage = [UIImage imageNamed:@"mianboy.png"];
        }
        else if ([gender isEqualToString:@"G"])  //girl
        {
            _defaultImage = [UIImage imageNamed:@"miangirl.png"];
        }
        else if ([gender isEqualToString:@"M"])  //男
        {
            _defaultImage = [UIImage imageNamed:@"miandad.png"];
        }
        else if ([gender isEqualToString:@"F"])  //女
        {
            _defaultImage = [UIImage imageNamed:@"mianmom.png"];
        }
        issLoginUser = YES;
    }
    return self;
}

-(id)initWithUserModel:(FamilyMembersModel *)model
{
    self = [super init];
    if (self) {
        // Custom initialization
        _useID = model.userID;
        //Gender：性别（B：男孩；G：女孩；F:女士；M：男士）
        if([model.gender isEqualToString:@"B"])    //boy
        {
            _defaultImage = [UIImage imageNamed:@"mianboy.png"];
        }
        else if ([model.gender isEqualToString:@"G"])  //girl
        {
            _defaultImage = [UIImage imageNamed:@"miangirl.png"];
        }
        else if ([model.gender isEqualToString:@"M"])  //男
        {
            _defaultImage = [UIImage imageNamed:@"miandad.png"];
        }
        else if ([model.gender isEqualToString:@"F"])  //女
        {
            _defaultImage = [UIImage imageNamed:@"mianmom.png"];
        }

        if([model.isLoginUser isEqualToString:@"T"])
        {
            issLoginUser = YES;
        }
        else
        {
            issLoginUser = NO;
        }
    }
    return self;
}

-(void)resignEverything
{
    if([_nameFld isFirstResponder])
    {
        [UIView animateWithDuration:0.3 animations:^{
            self.view.frame = CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height);
            
        } completion:^(BOOL finished) {
            //
            [_nameFld resignFirstResponder];
        }];
    }
    else if([_nickNameFld isFirstResponder])
    {
        [UIView animateWithDuration:0.3 animations:^{
            self.view.frame = CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height);
            
        } completion:^(BOOL finished) {
            //
            [_nickNameFld resignFirstResponder];
        }];
    }
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self resignEverything];
}

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    if(iPhone4S)
    {
        [UIView animateWithDuration:0.3 animations:^{
            self.view.frame = CGRectMake(0, -120, self.view.bounds.size.width, self.view.bounds.size.height);
            
        } completion:^(BOOL finished) {
            //
        }];
    }
    else
    {
        [UIView animateWithDuration:0.3 animations:^{
            self.view.frame = CGRectMake(0, -60, self.view.bounds.size.width, self.view.bounds.size.height);
            
        } completion:^(BOOL finished) {
            //
        }];
    }
    
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [UIView animateWithDuration:0.3 animations:^{
        self.view.frame = CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height);
        
    } completion:^(BOOL finished) {
        //
        [textField resignFirstResponder];
    }];
    return YES;
}

- (UIImagePickerController *)imagePickerController {
    if (_pickerController == nil) {
        _pickerController = [[UIImagePickerController alloc] init];
        _pickerController.delegate = self;
        _pickerController.allowsEditing=YES;
    }
    return _pickerController;
}

- (IBAction)actionBack:(id)sender {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
    
    if(self.delegate && [self.delegate respondsToSelector:@selector(uploadHeadImageToDetailViewWithHeadImageURL:)])
    {
        [self.delegate uploadHeadImageToDetailViewWithHeadImageURL:_newHeadImageStr];
    }
    
    self.navigationController.navigationBarHidden = NO;
    UIImage *image = [[UIImage imageNamed:@"navigationBar_background-7.png"] stretchableImageWithLeftCapWidth:1 topCapHeight:0];
    [self.navigationController.navigationBar setBackgroundImage:image forBarMetrics:UIBarMetricsDefault];
    if(issLoginUser)
    {
        [self actionBackToResider:nil];
    } 
    else
    {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

-(void)hideKeyboard
{
    [self resignEverything];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationController.navigationBarHidden = YES;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(hideKeyboard) name:UIKeyboardWillHideNotification object:nil];
    
    _newHeadImageStr = nil;
    NSString *loginUser = [[NSUserDefaults standardUserDefaults] objectForKey:USERID];
    [self showLoadingHUD];
    HttpInvokeItem *dataItem = [[HttpInvokeItem alloc] init];
    if ([self respondsToSelector:@selector(selfInfoSuccess:)] && [self respondsToSelector:@selector(selfInfoFailure:)])
    {
        [dataItem TargetSuper:self Success:@selector(selfInfoSuccess:) Failure:@selector(selfInfoFailure:)];
    }
    dataItem.dataEncodingType = MKNKPostDataEncodingTypeJSON;
    NSString *path = [NSString stringWithFormat:@"%@?userID=%@&targetUserID=%@", Request_GetUserInfo,loginUser,_useID];
    
    [[HttpInvokeEngine shareHttpInvoke] InvokeHttpMethod:path withParams:nil addFile:nil withMethod:@"GET" InvokeItem:dataItem];
}

- (void)selfInfoSuccess:(id)response
{
    [self hideHUD];
    NSLog(@"%@",[response objectForKey:@"Data"]);
    if ([[response objectForKey:@"Result"] intValue] == 1)
    {
        _newHeadImageStr = [[response objectForKey:@"Data"] objectForKey:@"HeadPortrait"];
        if([FMUString isEmptyString:_newHeadImageStr])
        {
            //空url 则默认头像
            _headImage.image = _defaultImage;
        }
        else
        {
            NSArray *arr = [_newHeadImageStr componentsSeparatedByString:@"/"];
            if([[ImageManager sharedInstance] isExistFileWithFileName:[arr lastObject]])
            {
                //本地图片和网络的图片是一样的  直接显示本地的
                NSString *imageName = [[ImageManager sharedInstance] imagePathWithName:[arr lastObject]];
                _headImage.image = [UIImage imageWithContentsOfFile:imageName];
            }
        }
        
        _nameFld.text = [[response objectForKey:@"Data"] objectForKey:@"RealName"];
        _nickNameFld.text = [[response objectForKey:@"Data"] objectForKey:@"NickName"];
        
        _realN = _nameFld.text;
        _nickN = _nickNameFld.text;
        
        if([[[response objectForKey:@"Data"] objectForKey:@"IsAllow"] boolValue])
        {
            //可修改
        }
        else
        {
            //不可修改
            _nameFld.userInteractionEnabled = NO;
            _nickNameFld.userInteractionEnabled = NO;
            _nameFld.textColor = [UIColor grayColor];
            _nickNameFld.textColor = [UIColor grayColor];
            _headBut.enabled = NO;
            _completeBut.enabled = NO;
        }
    }
    else
    {
        if([[response objectForKey:@"Message"] length] > 1)
        {
            [self displayErrorHUDWithText:[response objectForKey:@"Message"]];
        }
    }
}

- (void)selfInfoFailure:(id)response
{
    [self hideHUD];
    [self displayErrorHUDWithText:@"请稍后再试"];
}

-(IBAction)actionComplete:(id)sender
{
    NSString *userID = [[NSUserDefaults standardUserDefaults] objectForKey:USERID];
    if([userID isEqualToString:_useID])
    {
        //事件统计 修改家长头像 保存按钮
        [MobClick event:ParentPortrait_SaveInfo];
    }
    else
    {
        //事件统计 上传小孩头像 保存按钮
        [MobClick event:ChildPortrait_SaveInfo];
    }
    
    /**********/
    if([_realN isEqualToString:_nameFld.text] && [_nickN isEqualToString:_nickNameFld.text])
    {
        [self actionBack:nil];
        return;
    }
    /**********/
    
    if(_nameFld.text.length == 0)
    {
        [self displayErrorHUDWithText:@"请填写姓名"];
        return;
    }
    if([FMUString textLengthWithChineseAndEnglish:_nickNameFld.text]  > 10)
    {
        [self displayErrorHUDWithText:@"昵称过长(最多5个汉字或10个字母)"];
        return;
    }
    
    [self showLoadingHUD];
    HttpInvokeItem *dataItem = [[HttpInvokeItem alloc] init];
    if ([self respondsToSelector:@selector(changeNiceNameSuccess:)] && [self respondsToSelector:@selector(changeNiceNameFailure:)])
    {
        [dataItem TargetSuper:self Success:@selector(changeNiceNameSuccess:) Failure:@selector(changeNiceNameFailure:)];
    }
    dataItem.dataEncodingType = MKNKPostDataEncodingTypeJSON;
    NSString *path = [NSString stringWithFormat:@"%@?userID=%@&nickName=%@&realName=%@", Request_UpdateUserInfo,_useID,_nickNameFld.text.length > 0?_nickNameFld.text:@"",_nameFld.text];
    path = [path stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];

    [[HttpInvokeEngine shareHttpInvoke] InvokeHttpMethod:path withParams:nil addFile:nil withMethod:@"GET" InvokeItem:dataItem];
}

- (void)changeNiceNameSuccess:(id)response
{
    [self hideHUD];
    NSLog(@"%@",[response objectForKey:@"Data"]);
    if ([[response objectForKey:@"Result"] intValue] == 1)
    {
        [self displayErrorHUDWithText:[response objectForKey:@"Message"]];
        if(issLoginUser)
        {
            //专为设置界面用
            [[NSUserDefaults standardUserDefaults] setObject:[response objectForKey:@"NickName"] forKey:LoginUserNickName];
            [[NSUserDefaults standardUserDefaults] synchronize];
        }
        [self actionBack:nil];
    }
    else
    {
        if([[response objectForKey:@"Message"] length] > 1)
        {
            [self displayErrorHUDWithText:[response objectForKey:@"Message"]];
        }
    }
}

- (void)changeNiceNameFailure:(id)response
{
    [self hideHUD];
    [self displayErrorHUDWithText:@"请稍后再试"];
}

-(IBAction)actionHeadPicture:(id)sender
{
    UIActionSheet *aSheet = [[UIActionSheet alloc] initWithTitle:@"选取照片" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍照",@"从相册选择", nil];
    [aSheet showInView:[UIApplication sharedApplication].keyWindow];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex;
{
    switch (buttonIndex)
    {
        case 0:
        {
            if ([UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeCamera])
            {
                [self imagePickerController].sourceType = UIImagePickerControllerSourceTypeCamera;
                [self presentViewController:[self imagePickerController] animated:YES completion:^{
                    //
                }];
            }
        }
            break;
        case 1:
        {
            if ([UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeSavedPhotosAlbum])
            {
                [self imagePickerController].sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;//
                [self presentViewController:[self imagePickerController] animated:YES completion:^{
                    //
                }];
            }
        }
            break;
        default:
        {
        }
            break;
    }
}

#pragma mark - UIPickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(NSDictionary *)editingInfo
{
    if(picker.sourceType == UIImagePickerControllerSourceTypeCamera)
    {
        //相机拍照保存本地
        UIImageWriteToSavedPhotosAlbum(image, self,nil, nil);
    }
    [picker dismissViewControllerAnimated:YES completion:^{
        //
        [self showLoadingHUD];
        HttpInvokeItem *dataItem = [[HttpInvokeItem alloc] init];
        if ([self respondsToSelector:@selector(uploadHeadImageSuccess:)] && [self respondsToSelector:@selector(uploadHeadImageFailure:)])
        {
            [dataItem TargetSuper:self Success:@selector(uploadHeadImageSuccess:) Failure:@selector(uploadHeadImageFailure:)];
        }
        dataItem.dataEncodingType = MKNKPostDataEncodingTypeJSON;


        NSString *userID = [[NSUserDefaults standardUserDefaults] objectForKey:USERID];
        if([userID isEqualToString:_useID])
        {
            //事件统计 上传家长头像
            [MobClick event:ParentPortrait_UploadImg];
        }
        else
        {
            //事件统计 上传小孩头像
            [MobClick event:ChildPortrait_UploadImg];
        }

        NSData *imageData = UIImageJPEGRepresentation(image, 0.25);
        
        NSMutableDictionary *params = [[NSMutableDictionary alloc]init];
        [params setObject:imageData forKey:@"uploadFile"];
        NSMutableDictionary *param = [[NSMutableDictionary alloc]init];
        [param setObject:_useID forKey:@"userID"];

        [[HttpInvokeEngine shareHttpInvoke] InvokeHttpMethod:Request_UploadHeadPortrait withParams:param addFile:params withMethod:@"POST" InvokeItem:dataItem];
    
    }];
    _pickerController = nil;
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:^{
        //
        _pickerController = nil;
    }];
}

- (void)uploadHeadImageSuccess:(id)response
{
    NSLog(@"%@",[response objectForKey:@"Message"]);
    if ([[response objectForKey:@"Result"] intValue] == 1)
    {
        _newHeadImageStr =[response objectForKey:@"URL"];
        NSURL *urll = [NSURL URLWithString:[response objectForKey:@"URL"]];
        NSArray *arr = [_newHeadImageStr componentsSeparatedByString:@"/"];
        [self.headImage sd_setImageWithURL:urll placeholderImage:_defaultImage];
        //保存本地
        [[SDWebImageManager sharedManager] downloadImageWithURL:urll options:SDWebImageRetryFailed progress:^(NSInteger receivedSize, NSInteger expectedSize) {
            //
        } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
            //
            [self hideHUD];
            [[ImageManager sharedInstance] saveImageWithName:[arr lastObject] image:image];
            if(issLoginUser)
            {
                //专为设置界面用
                [[NSUserDefaults standardUserDefaults] setObject:_newHeadImageStr forKey:LoginUserHead];
                [[NSUserDefaults standardUserDefaults] synchronize];
            }
            [self displayErrorHUDWithText:[response objectForKey:@"Message"]];
        }];
    }
    else
    {
        if([[response objectForKey:@"Message"] length] > 1)
        {
            [self displayErrorHUDWithText:[response objectForKey:@"Message"]];
        }
    }
}

- (void)uploadHeadImageFailure:(id)response
{
    [self hideHUD];
    [self displayErrorHUDWithText:@"请稍后再试"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
