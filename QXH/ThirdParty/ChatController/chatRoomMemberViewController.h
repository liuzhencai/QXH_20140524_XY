//
//  chatRoomMemberViewController.h
//  QXH
//
//  Created by liuzhencai on 14-6-19.
//  Copyright (c) 2014年 ZhaoLilong. All rights reserved.
//  聊天室中的成员界面

#import <UIKit/UIKit.h>

@interface chatRoomMemberViewController :  MyViewController<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic,retain) UITableView* tableview;
@property(nonatomic,retain)NSMutableArray* Arrlist;
@property(nonatomic,assign)UINavigationController* navigation;

@end
