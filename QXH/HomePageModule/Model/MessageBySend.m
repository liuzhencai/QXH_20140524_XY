//
//  MessageBySend.m
//  QXH
//
//  Created by liuzhencai on 14-6-27.
//  Copyright (c) 2014年 ZhaoLilong. All rights reserved.
//  存储系统推送来的消息

#import "MessageBySend.h"
#import "UserInfoModelManger.h"

@implementation MessageBySend
static MessageBySend* ins =nil;

//@synthesize delegate;

- (instancetype)init
{
    self = [super init];
    if (self) {
        
        chatRoomMess = [[NSMutableDictionary alloc]init];
        unKnowCharMessDic = [[NSMutableDictionary alloc]init];
        sysMessDict = [[NSMutableDictionary alloc] init];
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
    NSDictionary* auserinfo = (NSDictionary*)[notif valueForKey:@"userInfo"];
    NSMutableDictionary* userinfo = [[NSMutableDictionary alloc]initWithDictionary:auserinfo];
    NSNumber* nmessid = (NSNumber*)[userinfo valueForKey:@"messid"];
    NSString*  amessid = [NSString stringWithFormat:@"%d",[nmessid intValue]];
    if ([messid isEqualToString:amessid]) {
        return;
    }
    messid = amessid;
    /*判断是不是部落消息聊天*/
    [self addChatRoomMessageArray:userinfo];
    [self AddTounKnowCharMessAyyay:userinfo];
//    [self AddSystemMessAyyay:userinfo];
  
    
}


- (void)addChatRoomMessageArray:(NSMutableDictionary*)notif
{
    /*判断接受到的消息类型*/
    NSNumber*  asendtype = (NSNumber*)[notif valueForKey:@"sendtype"];
    NSString* bsendtype =[NSString stringWithFormat:@"%d",[asendtype intValue]];
    if ([bsendtype isEqualToString:@"1"])
    {
        /*好友私聊*/
        /*同样加入聊天记录中*/
        /*
         chatRoomMess每一个元素是一个聊天室数组tempchatroomArray，通过tribeid查找
         */
        NSNumber* ntribeid = (NSNumber*)[notif valueForKey:@"senderid"];
        NSString* atribeid = [NSString stringWithFormat:@"%d",[ntribeid intValue]];
        NSMutableArray* tempchatroomarray = (NSMutableArray*)[chatRoomMess valueForKey:atribeid];
//        /*以私聊对象的id创建聊天室id，便于查找聊天记录时使用*/
        [notif setValue:ntribeid forKey:@"tribeid"];
        if (tempchatroomarray) {
            /*如果该聊天部落，聊天记录已经存在*/
            [tempchatroomarray addObject:notif];
        }else{
            /*如果该聊天部落，聊天记录不存在*/
            tempchatroomarray = [[NSMutableArray alloc]initWithObjects:notif, nil];
            [chatRoomMess setObject:tempchatroomarray forKey:atribeid];
        }
        DebugLog(@"chatRoomMess == %@",chatRoomMess);
        NSNumber* asenderId = [notif valueForKey:@"senderid"] ;
        NSString* tempSenderId = [NSString stringWithFormat:@"%d",[asenderId intValue]];
        NSString* meid = [UserInfoModelManger sharUserInfoModelManger].MeUserId;
        if (![tempSenderId isEqualToString:meid]) {
            /*如果是自己发送的就不用发消息刷新界面了*/
            [[NSNotificationCenter defaultCenter] postNotificationName:@"reloadeChatView" object:nil userInfo:notif];
        }
        
    }else if ([bsendtype isEqualToString:@"2"]) {
        /*部落聊天*/
            /*
             chatRoomMess每一个元素是一个聊天室数组tempchatroomArray，通过tribeid查找
             */
            NSNumber* ntribeid = (NSNumber*)[notif valueForKey:@"tribeid"];
            NSString* atribeid = [NSString stringWithFormat:@"%d",[ntribeid intValue]];
            NSMutableArray* tempchatroomarray = (NSMutableArray*)[chatRoomMess valueForKey:atribeid];
            if (tempchatroomarray) {
                /*如果该聊天部落，聊天记录已经存在*/
                [tempchatroomarray addObject:notif];
            }else{
             /*如果该聊天部落，聊天记录不存在*/
                tempchatroomarray = [[NSMutableArray alloc]initWithObjects:notif, nil];
                [chatRoomMess setObject:tempchatroomarray forKey:atribeid];
            }
        
        DebugLog(@"chatRoomMess == %@",chatRoomMess);
        NSNumber* asenderId = [notif valueForKey:@"senderid"] ;
        NSString* tempSenderId = [NSString stringWithFormat:@"%d",[asenderId intValue]];
        NSString* meid = [UserInfoModelManger sharUserInfoModelManger].MeUserId;
        if (![tempSenderId isEqualToString:meid]) {
            /*如果是自己发送的就不用发消息刷新界面了*/
            [[NSNotificationCenter defaultCenter] postNotificationName:@"reloadeChatRoom" object:nil userInfo:notif];
        }

   
    }else if ([bsendtype isEqualToString:@"3"] || [bsendtype isEqualToString:@"4"] || [bsendtype isEqualToString:@"0"] || [bsendtype isEqualToString:@"5"]
              || [bsendtype isEqualToString:@"6"]
              || [bsendtype isEqualToString:@"7"] || [bsendtype isEqualToString:@"12"] || [bsendtype isEqualToString:@"13"]){
        NSLog(@"info:%@",notif);
        NSNumber* asenderId = [notif valueForKey:@"senderid"] ;
        NSString* tempSenderId = [NSString stringWithFormat:@"%d",[asenderId intValue]];
        NSString* meid = [UserInfoModelManger sharUserInfoModelManger].MeUserId;
        if (![tempSenderId isEqualToString:meid]) {
            [self AddSystemMessAyyay:notif];
            /*如果是自己发送的就不用发消息刷新界面了*/
//            [[NSNotificationCenter defaultCenter] postNotificationName:@"addFirend" object:nil userInfo:notif];
        }
    }
}

/*自己私聊时调用*/
- (void)addChatRoomMessageArray:(NSMutableDictionary*)notif toOtherid:(NSNumber*)otherid
{
    /*判断接受到的消息类型*/
//    NSNumber*  asendtype = (NSNumber*)[notif valueForKey:@"sendtype"];
//    NSString* bsendtype =[NSString stringWithFormat:@"%d",[asendtype intValue]];
    [notif setObject:[NSNumber numberWithInt:1] forKey:@"sendtype"];
//    if ([bsendtype isEqualToString:@"1"])
//    {
        /*好友私聊*/
        /*同样加入聊天记录中*/
        /*
         chatRoomMess每一个元素是一个聊天室数组tempchatroomArray，通过tribeid查找
         */
//        NSNumber* ntribeid = (NSNumber*)[notif valueForKey:@"senderid"];
        NSString* atribeid = [NSString stringWithFormat:@"%d",[otherid intValue]];
        NSMutableArray* tempchatroomarray = (NSMutableArray*)[chatRoomMess valueForKey:atribeid];
        //        /*以私聊对象的id创建聊天室id，便于查找聊天记录时使用*/
        [notif setValue:otherid forKey:@"tribeid"];
        if (tempchatroomarray) {
            /*如果该聊天部落，聊天记录已经存在*/
            [tempchatroomarray addObject:notif];
        }else{
            /*如果该聊天部落，聊天记录不存在*/
            tempchatroomarray = [[NSMutableArray alloc]initWithObjects:notif, nil];
            [chatRoomMess setObject:tempchatroomarray forKey:atribeid];
        }
        DebugLog(@"chatRoomMess == %@",chatRoomMess);
        NSNumber* asenderId = [notif valueForKey:@"senderid"] ;
        NSString* tempSenderId = [NSString stringWithFormat:@"%d",[asenderId intValue]];
        NSString* meid = [UserInfoModelManger sharUserInfoModelManger].MeUserId;
        if (![tempSenderId isEqualToString:meid]) {
            /*如果是自己发送的就不用发消息刷新界面了*/
            [[NSNotificationCenter defaultCenter] postNotificationName:@"reloadeChatView" object:nil userInfo:notif];
        }
        
//    }
}

/*通过部落id，获取部落聊天内容，
 或者好友id获取私聊内容*/
-(NSArray*)getChatRoomMessArray:(NSString*)ChatRoomid
{
   NSArray* chatRoomArray = (NSArray*) [chatRoomMess valueForKey:ChatRoomid];
    return chatRoomArray;
}

/*把我自己发送的消息添加进入聊天室
 或者好友私聊*/
- (void)addChatRoomMessageByMe:(NSMutableDictionary*)Message andSendtype:(NSNumber*)asendtype
{
    /*
     asendtype
     1为好友私聊，2为部落聊天
     */
    
    /*
     Message 本身传进来时需要包含
     tribeid，mess，date
     */
    /*
     date = "2014-07-04 11:58:26";
     info = message;
     mess = Hi;
     messid = 1041;
     messtype = 1;  	//消息类型 1为文本，2为json对象，3为图片，4为录音
     opercode = 0131;
     senderid = 100069;
     sendername = "\U5218\U6b63\U624d111";
     senderphoto = "20140629/0034251930.png";
     sendtype = 2;
     sign = 33NRsRYD;
     statecode = "";
     tribeid = 37; //部落id
     tribename = "\U5218\U632f\U624d";
     tribephoto = "";
     */
//    [[UserInfoModelManger sharUserInfoModelManger]getUserInfo:^(UserInfoModel* meUser)
//     {
    UserInfoModel* meUser = [[UserInfoModelManger sharUserInfoModelManger]getMe];
    if (meUser) {
        [Message setValue:meUser.displayname forKey:@"sendername"];
        [Message setValue:meUser.photo forKey:@"senderphoto"];
        /*1为好友私聊，2为部落聊天*/
        [Message setValue:asendtype forKey:@"sendtype"];
        NSString* meuserid = [UserInfoModelManger sharUserInfoModelManger].MeUserId;
        NSNumber* sendid = [NSNumber numberWithInt:[meuserid intValue]];
        [Message setValue:sendid forKey:@"senderid"];
        //         [Message setValue:meUser.displayname forKey:@"sendername"];
        //         [Message setValue:meUser.displayname forKey:@"sendername"];
        
        /*添加进入聊天数组*/
        [self addChatRoomMessageArray:Message];
    }
    
}
//系统消息
- (void)AddSystemMessAyyay:(NSMutableDictionary*)message{
    /*判断接受到的消息类型*/
//    NSNumber*  asendtype = (NSNumber*)[message valueForKey:@"sendtype"];
//    NSString* bsendtype =[NSString stringWithFormat:@"%dId",[asendtype intValue]];
//    NSMutableArray* tempchatroomarray = (NSMutableArray*)[sysMessDict valueForKey:bsendtype];
//    if (tempchatroomarray) {
//        [tempchatroomarray addObject:message];
//    }else{
//        NSString *key = [NSString stringWithFormat:@"%@Id",bsendtype];
//        tempchatroomarray = [[NSMutableArray alloc]initWithObjects:message, nil];
//        [sysMessDict setObject:tempchatroomarray forKey:bsendtype];
//    }
//    
//    DebugLog(@"unKnowCharMessDic == %@",sysMessDict);
//    
//    /*如果是自己发送的就不用发消息刷新界面了*/
//    [[NSNotificationCenter defaultCenter] postNotificationName:@"addFirend" object:nil userInfo:sysMessDict];
    
    NSNumber*  asendtype = (NSNumber*)[message valueForKey:@"sendtype"];
    NSString* bsendtype =[NSString stringWithFormat:@"%d",[asendtype intValue]];
    NSMutableArray* tempchatroomarray = (NSMutableArray*)[unKnowCharMessDic valueForKey:bsendtype];
    if (tempchatroomarray) {
        [tempchatroomarray addObject:message];
    }else{
        tempchatroomarray = [[NSMutableArray alloc]initWithObjects:message, nil];
        [unKnowCharMessDic setObject:tempchatroomarray forKey:bsendtype];
    }
    
    DebugLog(@"unKnowCharMessDic == %@",unKnowCharMessDic);
    
    /*如果是自己发送的就不用发消息刷新界面了*/
    [[NSNotificationCenter defaultCenter] postNotificationName:@"addFirend" object:nil userInfo:unKnowCharMessDic];
}


#pragma mark 系统推送的聊天加入通讯录聊天当中
- (void)AddTounKnowCharMessAyyay:(NSMutableDictionary*)message
{
    /*判断接受到的消息类型*/
    NSNumber*  asendtype = (NSNumber*)[message valueForKey:@"sendtype"];
    NSString* bsendtype =[NSString stringWithFormat:@"%d",[asendtype intValue]];
    if ([bsendtype isEqualToString:@"1"])
    {
        /*好友私聊*/
        /*同样加入聊天记录中*/
        /*
         chatRoomMess每一个元素是一个聊天室数组tempchatroomArray，通过tribeid查找
         */
        NSNumber* ntribeid = (NSNumber*)[message valueForKey:@"senderid"];
        NSString* atribeid = [NSString stringWithFormat:@"%d",[ntribeid intValue]];
        NSMutableArray* tempchatroomarray = (NSMutableArray*)[unKnowCharMessDic valueForKey:atribeid];
        //        /*以私聊对象的id创建聊天室id，便于查找聊天记录时使用*/
        [message setValue:ntribeid forKey:@"tribeid"];
        if (tempchatroomarray) {
            /*如果该聊天部落，聊天记录已经存在*/
            [tempchatroomarray addObject:message];
        }else{
            /*如果该聊天部落，聊天记录不存在*/
            tempchatroomarray = [[NSMutableArray alloc]initWithObjects:message, nil];
            [unKnowCharMessDic setObject:tempchatroomarray forKey:atribeid];
        }
        DebugLog(@"chatRoomMess == %@",chatRoomMess);
        NSNumber* asenderId = [message valueForKey:@"senderid"] ;
//        NSString* tempSenderId = [NSString stringWithFormat:@"%d",[asenderId intValue]];
//        NSString* meid = [UserInfoModelManger sharUserInfoModelManger].MeUserId;
       
        /*如果是自己发送的就不用发消息刷新界面了*/
        [[NSNotificationCenter defaultCenter] postNotificationName:@"reloadeChatMessInfo" object:nil userInfo:unKnowCharMessDic];
    }
    else if ([bsendtype isEqualToString:@"2"]){
        /*部落聊天*/
        /*
         chatRoomMess每一个元素是一个聊天室数组tempchatroomArray，通过tribeid查找
         */
        NSNumber* ntribeid = (NSNumber*)[message valueForKey:@"tribeid"];
        NSString* atribeid = [NSString stringWithFormat:@"%d",[ntribeid intValue]];
        NSMutableArray* tempchatroomarray = (NSMutableArray*)[unKnowCharMessDic valueForKey:atribeid];
        if (tempchatroomarray) {
            /*如果该聊天部落，聊天记录已经存在*/
            [tempchatroomarray addObject:message];
        }else{
            /*如果该聊天部落，聊天记录不存在*/
            tempchatroomarray = [[NSMutableArray alloc]initWithObjects:message, nil];
            [unKnowCharMessDic setObject:tempchatroomarray forKey:atribeid];
        }
        
        DebugLog(@"unKnowCharMessDic == %@",unKnowCharMessDic);
    
            /*如果是自己发送的就不用发消息刷新界面了*/
            [[NSNotificationCenter defaultCenter] postNotificationName:@"reloadeChatMessInfo" object:nil userInfo:unKnowCharMessDic];
    }
}

#pragma mark 主动获取聊天记录接口
- (NSMutableDictionary*)getunKnowCharMessDic
{
    return unKnowCharMessDic;
}

#pragma mark 主动获取聊天记录接口
- (NSMutableArray*)getSystemMessDic
{
    return sysMess;
}


#pragma mark 查看部落聊天私聊接口
-(void)ReceiveAndSeeMessige:(NSString*)messigeid
                       type:(NSString*)type
                    tribeid:(NSString*)tribeid
{
    /*将服务器状态置为已读*/
    [DataInterface recvMessage:messigeid tribeid:tribeid type:type withCompletionHandler:^(NSMutableDictionary*dic){
        /*	opercode:"0132",		//operCode为0131，客户端通过该字段确定事件
         statecode:"0200",		//StateCode取值：发送成功[0200],发送失败[其他]
         info:"操作成功",		//客户端可以使用该info进行提示
         sign:"9aldai9adsf"*/
        NSLog(@"info==%@",dic[@"info"]);
        NSString* statecode = dic[@"statecode"];
//        NSString* statecode = [NSString stringWithFormat:@"%d",[astatecode integerValue]];
        if ([statecode isEqualToString:@"0200"]) {
            if ([tribeid length]) {
                /*未读消息中移除*/
                [unKnowCharMessDic removeObjectForKey:tribeid];
                /*如果是自己发送的就不用发消息刷新界面了*/
                [[NSNotificationCenter defaultCenter] postNotificationName:@"reloadeChatMessInfo" object:nil userInfo:unKnowCharMessDic];
            }
        }
    }];
}

#pragma mark 登录成功后获取用户离线消息
/*登录成功后获取用户离线消息*/
- (void)getOfflineMessage
{
    [DataInterface getLoginInfoWithCompletionHandler:^(NSMutableDictionary*backDic){
        /*
         opercode:"0140",		//operCode为0140，客户端通过该字段确定事件
         statecode:"0200",		//StateCode取值：获取成功[0200],获取失败[其他]
         info:"获取成功"			//修改成功/失败!
         official:[			/官方消息(添加好友，部落添加，等消息)
         {messid:12345,senderid:"123456",sendername:"名字",senderphoto:"1.jpg",sendtype:3,messtype:1,date:"2014-05-17 17:57:11",tribeid:1,tribename:"名字",tribephoto:"123",mess:"消息内容",count:1},
         {messid:12345,senderid:"123456",sendername:"名字",senderphoto:"1.jpg",sendtype:4,messtype:1,date:"2014-05-17 17:57:11",tribeid:1,tribename:"名字",tribephoto:"123",mess:"消息内容",count:1},
         {messid:12345,senderid:"123456",sendername:"名字",senderphoto:"1.jpg",sendtype:6,messtype:1,date:"2014-05-17 17:57:11",tribeid:1,tribename:"名字",tribephoto:"123",mess:"消息内容",count:1},
         ...
         
         ]
         chat:[				//好友聊天，部落聊天
         {messid:12345,senderid:"123456",sendername:"名字",senderphoto:"1.jpg",sendtype:3,messtype:1,date:"2014-05-17 17:57:11",tribeid:1,tribephoto:"123",mess:"消息内容",count:1},
         {messid:12345,senderid:"123456",sendername:"名字",senderphoto:"1.jpg",sendtype:4,messtype:1,date:"2014-05-17 17:57:11",tribeid:1,tribephoto:"123",mess:"消息内容",count:1},
         {messid:12345,senderid:"123456",sendername:"名字",senderphoto:"1.jpg",sendtype:6,messtype:1,date:"2014-05-17 17:57:11",tribeid:1,tribephoto:"123",mess:"消息内容",count:1},
         ...
         ]
         */
        NSLog(@"backDic");
    }];
}
@end

