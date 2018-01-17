//
//  HttpDefine.h
//  IXinjiekouBusiness
//
//  Created by hankang on 14-5-22.
//  Copyright (c) 2014年 user. All rights reserved.
//

#ifndef IXinjiekouBusiness_HttpDefine_h
#define IXinjiekouBusiness_HttpDefine_h

//SERVER_INTERNAL为内网环境，发布到线上时候，需要把SERVER_TEST注释掉
#define SERVER_TEST
#ifdef SERVER_TEST

//#define HostName        @"www.tiyuplus.com:8080/home"
#define HostName              @"www.tiyuplus.com/main"    //正式环境
//#define HostName @"139.196.148.121/main"
//#define HostName              @"120.26.210.26/test/main"     //测试环境
#define RecipeHostName        @"192.168.32.125"

#else
#define HostName         @"18652947896.xicp.net/Home"

#endif

#define Request_VerifyInivationCode      @"/VerifyInvitationCode"      //邀请码

#define Request_FetchVerifyCode          @"/FetchVerifyCode"           //获取手机验证码

#define Request_ProcForgetPassword       @"/ProcForgetPassword"        //重置密码

#define Request_CreateUserAndRelation    @"/UserBuild"                 //创建账号

#define Request_LoginByMobile            @"/LoginByMobile"             //手机登录

#define Request_GetFamilyMembers         @"/GetFamilyMembersByUserID2"  //获取用户家庭成员列表

#define Request_GetTimeChannel           @"/GetTimeChannel2"           //获取这个人以及相关人员的活动列表

#define Request_InviteOthers             @"/InviteOthers"              //邀请别人

#define Request_GetFamilyMemberByIC      @"/GetFamilyMemberByIC"       //获取此邀请码中的成员

#define Request_AddFamilyMember          @"/AddFamilyMember"           //加小孩

#define Request_GetRankOfFamilyScore     @"/GetRankOfFamilyScore2"     //获得家庭排名

#define Request_GetHisByProgramID        @"/GetHisByProgramID"         //获得某项目历史成绩

#define Request_GetRankOfStudent         @"/GetRankOfStudent"          //学生的排行榜

#define Request_GetRankOfParent          @"/GetRankOfParent"           //家长的排行榜

#define Request_AddActivityInfoOfMobile  @"/AddActivityInfoOfMobile"   //上传成绩

#define Request_CheckNewEvent            @"/CheckNewEvent"             //检查时间轴是否有最新的

#define Request_GetUserInfo              @"/GetUserInfo"               //进入上传头像界面

#define Request_UploadHeadPortrait       @"/UploadHeadPortrait"        //上传头像

#define Request_UpdateUserInfo           @"/UpdateUserInfo"            //更新用户名和昵称

#define Request_GetResouceInfo           @"/GetResouceInfo"            //资源包的版本信息

#define Request_GetExerciseGuide         @"/GetExerciseGuide2"         //获取运动处方信息

#define Request_AddExerciseProcess       @"/AddExerciseProcess"        //上传运动指导成绩

#define Request_GetFamilyRewards         @"/GetFamilyRewards"          //设置界面 家庭积分

#define Request_GetForumVideoInfo        @"/GetForumVideoInfo"         //获取孙教授视频列表

#define Request_GetUserUnlockProgramInfo @"/GetUserUnlockProgramInfo"  //获取解锁的动作和数量

#define Request_GetCoachInfoURL          @"/GetCoachInfoURL"           //获取心理指导URL

#define Request_GetCoachVideoInfo        @"/GetCoachVideoInfo"         //获取心理辅导视频接口

#define Request_UpdateUserRegistrationID @"/UpdateUserRegistrationID" //ios专用 上传UpdateUserRegistrationID

#endif



