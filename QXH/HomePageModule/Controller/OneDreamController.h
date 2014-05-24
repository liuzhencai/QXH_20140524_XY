//
//  OneDreamController.h
//  QXH
//
//  Created by ZhaoLilong on 14-5-4.
//  Copyright (c) 2014年 ZhaoLilong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ChatController.h"



@interface OneDreamController : MyViewController<UITableViewDataSource, UITableViewDelegate,ChatControllerDelegate>
{
    ChatController* _chatController;
    NSInteger icout;
}

@end
