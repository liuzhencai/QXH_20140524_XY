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
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(recvMsg:) name:@"recvMsg" object:nil];
    }
    return ins ;
}

- (void)recvMsg:(NSNotification *)notif
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"服务器推送消息" message:[[notif userInfo] description] delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
    [alert show];
}

@end

