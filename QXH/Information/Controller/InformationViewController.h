//
//  InformationViewController.h
//  QXH
//
//  Created by liuzhencai on 14-5-12.
//  Copyright (c) 2014年 ZhaoLilong. All rights reserved.
//  资讯主界面

#import <UIKit/UIKit.h>
#import "MyViewController.h"
#import "CustomSegmentControl.h"

#define MENU_FIXED_WIDTH 80
#define MENU_FIXED_HEIGHT 34

@interface InformationViewController : MyViewController<UITableViewDataSource,UITableViewDelegate, UIScrollViewDelegate>

@end
