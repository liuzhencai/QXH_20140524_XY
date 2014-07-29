//
//  ChatMess.h
//  QXH
//
//  Created by ZhaoLilong on 14-7-22.
//  Copyright (c) 2014年 ZhaoLilong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ChatMess : NSObject

@property (nonatomic, copy) NSString *cid; // 聊天主键id

@property (nonatomic, copy) NSString *uid; // 用户id

@property (nonatomic, copy) NSNumber *msgid; // 消息唯一标示

@property (nonatomic, copy) NSString *sessionid; // 会话唯一标示

@property (nonatomic, copy) NSNumber *type; // 消息类型

@property (nonatomic, copy) NSNumber *fromid; // 来自id标示

@property (nonatomic, copy) NSString *fromname; // 来自name标示

@property (nonatomic, copy) NSString *fromphotoid; // 来自图片标示

@property (nonatomic, copy) NSString *dttime; // 消息时间

@property (nonatomic, copy) NSString *dtdate; // 消息日期

@property (nonatomic, copy) NSString *contenttext; // 内容文本

@property (nonatomic, copy) NSString *contentres; // 内容资源

@property (nonatomic, copy) NSString *state; // 消息状态

@property (nonatomic, copy) NSNumber *targetid; // 目标id标示

@property (nonatomic, copy) NSString *targetname; // 目标name标示

@property (nonatomic, copy) NSString *targetphoto; // 目标图片

@property (nonatomic, copy) NSNumber *messagetype; // 目标消息类型

@end
