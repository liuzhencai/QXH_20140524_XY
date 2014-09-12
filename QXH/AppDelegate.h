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

@protocol RespForWeChatViewDelegate <NSObject>
- (void) RespLinkContent;
@end

@interface AppDelegate : UIResponder <UIApplicationDelegate, WXApiDelegate>
{
    BOOL needReconnection;
}

@property (nonatomic, assign) BOOL tokenError; // token错误

@property (strong, nonatomic) UIWindow *window;

@property (nonatomic, strong) CustomTabBarController *tabController;

@property (nonatomic, assign) id<RespForWeChatViewDelegate,NSObject> delegate;

@property (nonatomic, strong) NSTimer *timer;

//- (void)login;
@end
