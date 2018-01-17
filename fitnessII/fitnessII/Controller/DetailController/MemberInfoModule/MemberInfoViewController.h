//
//  MemberInfoViewController.h
//  fitnessII
//
//  Created by Haley on 15/8/26.
//  Copyright (c) 2015年 samples.hankang. All rights reserved.
//

#import "RootViewController.h"
#import "FamilyMembersModel.h"

@protocol MemberInfoDelegate <NSObject>

-(void)uploadHeadImageToDetailViewWithHeadImageURL:(NSString *)url;

@end

@interface MemberInfoViewController : RootViewController<UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIActionSheetDelegate,UITextFieldDelegate>
@property (nonatomic, assign) id<MemberInfoDelegate> delegate;

@property (nonatomic, retain) IBOutlet UIImageView *headImage;
@property (nonatomic, retain) IBOutlet UIButton *headBut;
@property (nonatomic, retain) IBOutlet UITextField *nameFld;
@property (nonatomic, retain) IBOutlet UITextField *nickNameFld;
@property (nonatomic, retain) IBOutlet UIButton *completeBut;

//专用于Setting头像设置
-(id)initWithNothing;

//专用于小孩修改头像
-(id)initWithUserModel:(FamilyMembersModel *)model;

@end
