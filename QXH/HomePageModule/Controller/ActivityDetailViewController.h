//
//  ActivityDetailViewController.h
//  QXH
//
//  Created by XUE on 14-5-19.
//  Copyright (c) 2014年 ZhaoLilong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PortraitView.h"

@interface ActivityDetailViewController : MyViewController<UITableViewDataSource, UITableViewDelegate, PortraitViewDelegate>

@property (nonatomic, strong) NSString *activityId;
@property (nonatomic, assign) BOOL isActivityEnd;//是否结束
@end
