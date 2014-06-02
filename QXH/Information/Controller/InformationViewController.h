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

@interface InformationViewController : MyViewController<UITableViewDataSource,UITableViewDelegate, CustomSegmentControlDelegate>

@property (strong, nonatomic) IBOutlet UIView *recommendView;
@property(nonatomic,retain)IBOutlet UITableView* _tableview;

@end
