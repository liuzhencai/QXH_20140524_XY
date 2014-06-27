//
//  MessageBySend.m
//  QXH
//
//  Created by liuzhencai on 14-6-27.
//  Copyright (c) 2014年 ZhaoLilong. All rights reserved.
//  存储系统推送来的消息

#import "MessageBySend.h"

@implementation MessageBySend
static MessageBySend* ins =nil;

- (instancetype)init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}


+(MessageBySend*)sharMessageBySend
{
    if (!ins) {
        ins = [[MessageBySend alloc]init];
    }
    return ins ;
}

- (void)getdata
{
    [DataInterface recvRemoteNoficationWithCompletionHandler:^(NSMutableDictionary *dict){
        NSLog(@"服务器推送消息/通知：%@",dict);
//        [self showAlert:[dict objectForKey:@"info"]];
    }];
}
@end

