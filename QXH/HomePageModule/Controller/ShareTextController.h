//
//  ShareTextController.h
//  QXH
//
//  Created by ZhaoLilong on 5/18/14.
//  Copyright (c) 2014 ZhaoLilong. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, SquareInfoType) {
    SquareInfoTypeSq = 1, // 广场发布的信息
    SquareInfoTypeInf, // 资讯转发的信息
    SquareInfoTypeTrans // 转评的广场消息
};

@interface ShareTextController : MyViewController<UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, assign) SquareInfoType type;
@property (weak, nonatomic) IBOutlet UITableView *contentTable;
@property (strong, nonatomic) IBOutlet UIView *toolbarView;
@property (strong, nonatomic) IBOutlet UIView *topView;
@property (nonatomic, strong) SquareInfo *info;
- (IBAction)click:(id)sender;

@end
