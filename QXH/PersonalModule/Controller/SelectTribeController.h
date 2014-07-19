//
//  SelectTribeController.h
//  QXH
//
//  Created by ZhaoLilong on 7/19/14.
//  Copyright (c) 2014 ZhaoLilong. All rights reserved.
//

#import "MyViewController.h"
#import "MJRefresh.h"
#import "MyCardController.h"

@interface SelectTribeController : MyViewController<UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tribeTbl;
@property (nonatomic, assign) MyCardController *parentController;

@end
