//
//  AppDelegate.h
//  QXH
//
//  Created by ZhaoLilong on 14-5-4.
//  Copyright (c) 2014年 ZhaoLilong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WXApi.h"
#import "CustomTabBarController.h"

#define UMENG_APPKEY @"53c3db8e56240b17ae05ec28"

@interface AppDelegate : UIResponder <UIApplicationDelegate, WXApiDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (nonatomic, strong) CustomTabBarController *tabController;

//- (void)login;
@end
