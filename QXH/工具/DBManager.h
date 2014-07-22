//
//  DBManager.h
//  QXH
//
//  Created by ZhaoLilong on 14-7-22.
//  Copyright (c) 2014年 ZhaoLilong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FMDatabase.h"
#import "ChatMess.h"

/**
 *  存储与读取聊天消息
 */
@interface DBManager : NSObject

- (void)saveChatMess:(ChatMess *)mess;

- (NSMutableArray *)getChatMessCount:(NSString *)count lastMessId:(NSString *)messid;

@end
