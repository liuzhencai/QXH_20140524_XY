//
//  chatRoomActivViewController.h
//  QXH
//
//  Created by liuzhencai on 14-6-19.
//  Copyright (c) 2014年 ZhaoLilong. All rights reserved.
//  部落中的活动列表

#import <UIKit/UIKit.h>

@interface chatRoomActivViewController : MyViewController<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic,retain) UITableView* tableview;
@property(nonatomic,retain)NSMutableArray* activitysList;
@property(nonatomic,assign)UINavigationController* navigation;
@end
