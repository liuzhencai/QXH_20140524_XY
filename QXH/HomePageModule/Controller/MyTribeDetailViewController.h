//
//  MyTribeDetailViewController.h
//  QXH
//
//  Created by XUE on 14-5-21.
//  Copyright (c) 2014年 ZhaoLilong. All rights reserved.
//

#import "MyViewController.h"

@interface MyTribeDetailViewController : MyViewController
@property (nonatomic, assign) BOOL isCreatDetail;
@property (nonatomic, strong) NSDictionary *tribeDict;//部落详情参数
@property (nonatomic, strong) NSArray *numbers;//添加部落成员
@end
