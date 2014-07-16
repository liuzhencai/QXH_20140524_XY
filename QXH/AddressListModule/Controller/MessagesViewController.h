//
//  MessagesViewController.h
//  QXH
//
//  Created by XueYong on 7/8/14.
//  Copyright (c) 2014 ZhaoLilong. All rights reserved.
//

#import "MyViewController.h"

@interface MessagesViewController : MyViewController
@property (nonatomic, strong) NSMutableArray *messagesList;
@property (nonatomic, strong) NSMutableArray *lastMessagesList;//上次查看的消息列表
@end
