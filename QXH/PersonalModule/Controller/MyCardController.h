//
//  MyCardController.h
//  QXH
//
//  Created by ZhaoLilong on 14-5-8.
//  Copyright (c) 2014年 ZhaoLilong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyCardController : MyViewController<UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *cardTable;

@property (strong, nonatomic) IBOutlet UIView *topView;

- (IBAction)btnClicked:(id)sender;

@end
