//
//  NetworkApiDefine.h
//  ExproTeam
//
//  Created by Christ on 14/10/18.
//  Copyright (c) 2014年 lichengfei. All rights reserved.
//

#import <Foundation/Foundation.h>

#ifndef ExproTeam_NetworkApiDefine_h
#define ExproTeam_NetworkApiDefine_h

static NSString *const registeApi = @"register";
/**
 *  用户名密码登录
 */
static NSString *const loginApi = @"login";
/**
 *  自动登录
 */
static NSString *const autoLoginApi = @"autologin";
/**
 *  消息列表
 */
static NSString *const messageListApi = @"getpersonalmessagelist";
/**
 *  新闻列表
 */
static NSString *const newsListApi = @"getnewslist";
/**
 *  对象列表
 */
static NSString *const objectListApi = @"getobjectlist";
/**
 *  对象列表（我关注的列表）
 */
static NSString *const myObjectListApi = @"getmyobjectlist";
/**
 *  捐助
 */
static NSString *const donateApi = @"donate";
/**
 *  关注
 */
static NSString *const careApi = @"care";
/**
 *  取消关注
 */
static NSString *const cancelCareApi = @"cancelcare";
/**
 *  发现
 */
static NSString *const searchObjApi = @"searchObj";
/**
 *  活动
 */
static NSString *const activityList = @"getactlist";
/**
 *  feedback
 */
static NSString *const feedbackApi = @"feedback";
/**
 *  获取我的关注列表
 */
static NSString *const carListApi = @"getcarelist";

#endif