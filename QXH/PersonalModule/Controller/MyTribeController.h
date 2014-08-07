//
//  MyTribeController.h
//  QXH
//
//  Created by ZhaoLilong on 5/14/14.
//  Copyright (c) 2014 ZhaoLilong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyTribeCell.h"
#import "ChatRoomController.h"

@interface MyTribeController : MyViewController<UITableViewDelegate, UITableViewDataSource>
{
    /*因为通知消息会多次弹出问题*/
    ChatRoomController *chatview;
}
@property (weak, nonatomic) IBOutlet UITableView *mytribeTbl;

@end
