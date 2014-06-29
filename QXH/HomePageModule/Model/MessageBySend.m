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

//@synthesize delegate;

- (instancetype)init
{
    self = [super init];
    if (self) {
        
        chatRoomMess = [[NSMutableArray alloc]init];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(recvMsg:) name:@"recvMsg" object:nil];
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

- (void)recvMsg:(NSNotification *)notif
{
//    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"服务器推送消息" message:[[notif userInfo] description] delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
//    [alert show];
    if (!notif) {
        return;
    }
    /*判断接受到的消息，是不是已经接受到*/
    NSDictionary* userinfo = (NSDictionary*)[notif valueForKey:@"userInfo"];
    NSNumber* nmessid = (NSNumber*)[userinfo valueForKey:@"messid"];
    NSString*  amessid = [NSString stringWithFormat:@"%d",[nmessid intValue]];
    if ([messid isEqualToString:amessid]) {
        return;
    }
    messid = amessid;
    /*判断是不是部落消息聊天*/
    [self addChatRoomMessageArray:userinfo];
  
    
}


- (void)addChatRoomMessageArray:(NSDictionary*)notif
{
    /*判断接受到的消息类型*/
    NSNumber*  asendtype = (NSNumber*)[notif valueForKey:@"sendtype"];
    NSString* bsendtype =[NSString stringWithFormat:@"%d",[asendtype intValue]];
    if ([bsendtype isEqualToString:@"2"]) {
        /*部落聊天*/
        NSMutableDictionary* chatRoomdic = nil;
        for (int i=0; i<[chatRoomMess count]; i++) {
            /*
             chatRoomMess数组每一个元素是一个聊天室字典tempchatroom
             tempchatroom tribeid,聊天室id；messageArray，聊天室内容
             */
            NSMutableDictionary* tempchatroom = (NSMutableDictionary*)[chatRoomMess objectAtIndex:i];
            NSNumber* ntribeid = (NSNumber*)[notif valueForKey:@"tribeid"];
            NSString* atribeid = [NSString stringWithFormat:@"%d",[ntribeid intValue]];
;
            if ([atribeid isEqualToString:[tempchatroom valueForKey:@"tribeid"]]) {
                NSMutableArray* tempArray = (NSMutableArray*)[tempchatroom valueForKey:@"messageArray"];
                [tempArray addObject:notif];
                chatRoomdic = tempchatroom;
                break;
            }
        }
        
        if (!chatRoomdic) {
            /*如果该聊天室推送通知不存在，则创建一个*/
            chatRoomdic = [[NSMutableDictionary alloc]init];
            [chatRoomdic setValue:[notif valueForKey:@"tribeid"] forKey:@"tribeid"];
            NSMutableArray* tempMessageArray = [[NSMutableArray alloc]initWithObjects:notif, nil];
            [chatRoomdic setValue:tempMessageArray forKey:@"messageArray"];
            [chatRoomMess addObject:chatRoomdic];
            
        }
        /*发送消息*/
        [[NSNotificationCenter defaultCenter] postNotificationName:@"reloadeChatRoom" object:nil userInfo:chatRoomdic];
   
    }
}
@end

