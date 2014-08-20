//
//  config.h
//  Education
//
//  Created by liuzhencai on 14-5-5.
//  Copyright (c) 2014年 liuzhencai. All rights reserved.
//  定义的常量，宏等

#ifndef Education_config_h
#define Education_config_h




#pragma mark - Device macro

#define iPhone5 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen] currentMode].size) : NO)
#define IS_OS_5_OR_LATER    ([[[UIDevice currentDevice] systemVersion] floatValue] >= 5.0)
#define IS_OS_6_OR_LATER    ([[[UIDevice currentDevice] systemVersion] floatValue] >= 6.0)
#define IS_OS_7_OR_LATER    ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0)

#pragma mark - UI Macro

#define UI_NAVIGATION_BAR_HEIGHT        44
#define UI_TOOL_BAR_HEIGHT              44
#define UI_TAB_BAR_HEIGHT               49
#define UI_STATUS_BAR_HEIGHT            20
#define UI_SCREEN_WIDTH                 ([[UIScreen mainScreen] bounds].size.width)
#define UI_SCREEN_HEIGHT                ([[UIScreen mainScreen] bounds].size.height)
#define MENU_HEIGHT 34

#pragma mark - color Macro
//
#define COLOR_WITH_ARGB(R,G,B,A) [UIColor colorWithRed:R / 255.0 green:G / 255.0 blue:B / 255.0 alpha:A]
#define GREEN_FONT_COLOR [UIColor colorWithRed:83 / 255.0 green:170 / 255.0 blue:97 / 255.0 alpha:1.0]
//RGB color macro
#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
green:((float)((rgbValue & 0xFF00) >> 8))/255.0 \
blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

#pragma mark - String
#define USER_NAME @"userName"   //用户名
#define PASSWORLD @"passworld"  //密码
#define LOGIN_DATE @"loginDate" //登录时间

#endif
