//
//  OneDreamController.h
//  QXH
//
//  Created by ZhaoLilong on 14-5-4.
//  Copyright (c) 2014年 ZhaoLilong. All rights reserved.
//  直播间界面

#import <UIKit/UIKit.h>
#import "ChatRoomController.h"
#import "ChatLiveViewController.h"


@interface OneDreamController : MyViewController<UITableViewDataSource, UITableViewDelegate>
{
    ChatLiveViewController* chatlive;
    NSInteger icout;
}


@property(strong,nonatomic)IBOutlet UITableView* tableview;
@end
