//
//  ShareTextController.h
//  QXH
//
//  Created by ZhaoLilong on 5/18/14.
//  Copyright (c) 2014 ZhaoLilong. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, SquareInfoType) {
    SquareInfoTypeInf, // 资讯转发的信息
    SquareInfoTypeSq, // 广场发布的信息
    SquareInfoTypeAct // 活动转发至广场的信息
};

@interface ShareTextController : MyViewController<UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, assign) SquareInfoType type;
@property (weak, nonatomic) IBOutlet UITableView *contentTable;
@property (strong, nonatomic) IBOutlet UIView *toolbarView;
@property (strong, nonatomic) IBOutlet UIView *topView;
- (IBAction)click:(id)sender;

@end
