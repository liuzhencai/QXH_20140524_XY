//
//  SelectTribeViewController.h
//  QXH
//
//  Created by XUE on 14-5-21.
//  Copyright (c) 2014年 ZhaoLilong. All rights reserved.
//

#import "MyViewController.h"
typedef void (^SelectTribeCallBack)(NSDictionary *);
@interface SelectTribeViewController : MyViewController
@property (nonatomic, copy) SelectTribeCallBack selectTribeCallBack;
@end
