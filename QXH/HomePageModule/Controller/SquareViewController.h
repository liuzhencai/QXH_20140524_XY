//
//  SquareViewController.h
//  QXH
//
//  Created by ZhaoLilong on 14-5-4.
//  Copyright (c) 2014年 ZhaoLilong. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 *  文章类型  1为广场发布的文章，2为转发到广场的咨询，3为转发到广场的活动,4为每日一问(如果存在会在列表第一个显示),5为转评到广场的广场文章
 */

@interface SquareViewController : MyViewController<UITableViewDataSource, UITableViewDelegate, UIScrollViewDelegate>

@property (weak, nonatomic) IBOutlet UIButton *lastestBtn;
@property (weak, nonatomic) IBOutlet UIButton *hotBtn;
@property (strong, nonatomic) IBOutlet UITableView *squareTable;
@property (strong, nonatomic) IBOutlet UITableView *hotestTable;
@property (weak, nonatomic) IBOutlet UIImageView *slipbar;
- (IBAction)btnClick:(id)sender;

@end
