//
//  CustomTabBarController.h
//  QXH
//
//  Created by ZhaoLilong on 14-5-22.
//  Copyright (c) 2013年 ZhaoLilong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TabBarControl.h"

@interface CustomTabBarController : UITabBarController<UINavigationControllerDelegate>
{
    NSArray *btnTitleArray;
    NSArray *iconArray;
}

@property (nonatomic, assign) NSInteger currentTab;

- (void)hideSystemTabBar;
- (void)hideTabBar:(BOOL)hide;
- (void)addCustomElements;
- (void)selectTab:(int)tabID;
- (void)setTabBarHiddenNow:(NSNumber *)aboolNum;

@end
