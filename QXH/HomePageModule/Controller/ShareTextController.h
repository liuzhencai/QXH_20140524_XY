//
//  ShareTextController.h
//  QXH
//
//  Created by ZhaoLilong on 5/18/14.
//  Copyright (c) 2014 ZhaoLilong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ShareTextController : MyViewController<UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *contentTable;
@property (strong, nonatomic) IBOutlet UIView *toolbarView;
@property (strong, nonatomic) IBOutlet UIView *topView;
- (IBAction)click:(id)sender;

@end
