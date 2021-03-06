//
//  MessageBySend.m
//  QXH
//
//  Created by liuzhencai on 14-6-27.
//  Copyright (c) 2014年 ZhaoLilong. All rights reserved.
//  存储系统推送来的消息

#import <AudioToolbox/AudioToolbox.h>

#import "MessageBySend.h"
#import "UserInfoModelManger.h"
#import "ChatMess.h"

@implementation MessageBySend
static MessageBySend* ins =nil;


@synthesize delegate;
@synthesize messid;
//@synthesize messageCountLiu;

//@synthesize delegate;

- (instancetype)init
{
    self = [super init];
    if (self) {
        
        chatRoomMess = [[NSMutableDictionary alloc]init];
        unKnowCharMessDic = [[NSMutableDictionary alloc]init];
//        tempUnKnowCharMessArray = [[NSMutableArray alloc]init];
        sysMessDict = [[NSMutableDictionary alloc] init];
        haveSeeOffline = [[NSMutableDictionary alloc]init];
        /*创建数据库*/
        db = [DBManager sharedManager];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(recvMsg:) name:@"recvMsg" object:nil];
//        messageCountLiu = 0;
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
    NSLog(@"MessageBySend接受到信息");
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
    self.messid = amessid;
      /*因为直播间消息也会给自己推送*/
    NSNumber* senderid = (NSNumber*)[userinfo valueForKey:@"senderid"];
    NSNumber* meuserid = [defaults objectForKey:@"userid"] ;
    /*2 为分享的信息，如果是自己分享的则要显示*/
    NSNumber* messtype = [userinfo valueForKey:@"messtype"];
    if (([senderid integerValue] == [meuserid integerValue]) &&([messtype integerValue] != 2)) {
        return;
    }

    
//    AudioServicesPlaySystemSound(1007);

    /*暂时屏蔽此处离线消息*/
    [self AddTounKnowCharMessAyyay:userinfo];
    /*判断是不是部落消息聊天*/
    [self addChatRoomMessageArray:userinfo];
    if (!sound) {
        /*如果后台进入前台，有可能会一次接受20条消息，所以，会提示连续响20声，该判断解决该问题*/
        sound = YES;
        [self performSelector:@selector(messageTip) withObject:nil afterDelay:1];
    }

//    [self AddSystemMessAyyay:userinfo];
  
    
}

- (void)messageTip{
    sound = NO;
//铃声
    BOOL enableRing = [[defaults objectForKey:@"enableRing"] boolValue];
    if (enableRing) {
        AudioServicesPlaySystemSound(1007);
    }
//振动
    BOOL enableShake = [[defaults objectForKey:@"enableShake"] boolValue];
    if (enableShake) {
        AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
    }
}

#pragma mark 判断系统消息是不是部落消息聊天
- (void)addChatRoomMessageArray:(NSMutableDictionary*)notif
{
    /*判断接受到的消息类型
     0为系统消息,1为好友私聊，2为部落聊天,3为加好友申请，4为处理请求好友申请，5为加入部落申请,6为处理部落加入申请,7为完全退出部落,8为进入部落，9为退出部落房间,10好友上线通知
     */
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
//        DebugLog(@"chatRoomMess == %@",chatRoomMess);
        NSNumber* asenderId = [notif valueForKey:@"senderid"] ;
        NSString* tempSenderId = [NSString stringWithFormat:@"%d",[asenderId intValue]];
        NSString* meid = [UserInfoModelManger sharUserInfoModelManger].MeUserId;
        
        /*如果存在离线消息时不保存，*/
//        NSMutableArray* offarray = (NSMutableArray*)[unKnowCharMessDic valueForKey:atribeid];
        /*是否已经查看离线消息*/
//        NSString* targeid = [haveSeeOffline valueForKey:atribeid];
//        if ([offarray count] && !targeid) {
//            /*如果存在离线消息，并且没有查看不保存*/
//        }else{
        /*更改保存数据接口，自己判断该数据是否已经保存*/
          [self saveFmdb:notif];
//        }
        
        if (![tempSenderId isEqualToString:meid]) {
//             [self saveFmdb:notif];
            /*如果是自己发送的就不用发消息刷新界面了*/
            [[NSNotificationCenter defaultCenter] postNotificationName:@"reloadeChatView" object:nil userInfo:notif];
           
        }
        
    }else if ([bsendtype isEqualToString:@"2"] || [bsendtype isEqualToString:@"14"]|| [bsendtype isEqualToString:@"13"]) {//
        /*14是直播间消息*/
        /*
         分享进入部落里的文章，活动，个人名片也添加进入部落聊天当中
         数据格式
         date = "2014-07-14 11:59:15";
         info = message;
         mess = "{\"actaddr\":\"\",\"actid\":43,\"actname\":\"\U5e72\U561b\",\"acttype\":\"\",\"begindate\":\"\",\"comefrom\":\"\",\"creater\":0,\"creatername\":\"\",\"desc\":\"\",\"enddate\":\"\",\"folcount\":0,\"isjoin\":0,\"maxcount\":0,\"nowcount\":0,\"photos\":\"20140712/2037065000.png\",\"signupbegindate\":\"\",\"signupenddate\":\"\",\"sourcetype\":3,\"status\":0,\"tags\":\"\"}";
         messid = 0;
         messtype = 2;
         opercode = 0131;
         senderid = 100070;
         sendername = "\U5218\U632f\U624d2";
         senderphoto = "20140629/1043057210.png";
         sendtype = 13;
         sign = L8j34rKx;
         statecode = 0200;
         tribeid = 38;
         tribename = "\U771f\U624d";
         tribephoto = "20140627/2227514720.png";
         */
        
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
        
//        DebugLog(@"chatRoomMess == %@",chatRoomMess);
        NSNumber* asenderId = [notif valueForKey:@"senderid"] ;
        NSString* tempSenderId = [NSString stringWithFormat:@"%d",[asenderId intValue]];
        NSString* meid = [UserInfoModelManger sharUserInfoModelManger].MeUserId;
        NSNumber* messtype = [notif valueForKey:@"messtype"] ;

        if ([tempSenderId isEqual:meid] && [messtype intValue]==3) {
            /*如果是我发送的图片就暂时不保存*/
        }else{
//            NSMutableArray* offarray = (NSMutableArray*)[unKnowCharMessDic valueForKey:atribeid];
            /*是否已经查看离线消息*/
//            NSString* targeid = [haveSeeOffline valueForKey:atribeid];
//            if ([offarray count] && !targeid) {
//                /*如果存在离线消息不保存*/
//            }else{
                [self saveFmdb:notif];
//            }
//          [self saveFmdb:notif];
        }
        if (![tempSenderId isEqualToString:meid]) {
//             [self saveFmdb:notif];
            /*如果是自己发送的就不用发消息刷新界面了*/
            [[NSNotificationCenter defaultCenter] postNotificationName:@"reloadeChatRoom" object:nil userInfo:notif];
        }
   
    }else if ([bsendtype isEqualToString:@"3"] || [bsendtype isEqualToString:@"4"] || [bsendtype isEqualToString:@"0"] || [bsendtype isEqualToString:@"5"]
              || [bsendtype isEqualToString:@"6"]
              || [bsendtype isEqualToString:@"7"] || [bsendtype isEqualToString:@"12"] /*|| [bsendtype isEqualToString:@"13"]这是分享到部落的活动，文章和名片*/){
        NSLog(@"info:%@",notif);
        NSNumber* asenderId = [notif valueForKey:@"senderid"] ;
        NSString* tempSenderId = [NSString stringWithFormat:@"%d",[asenderId intValue]];
        NSString* meid = [UserInfoModelManger sharUserInfoModelManger].MeUserId;
        if (![tempSenderId isEqualToString:meid]) {
            [self AddSystemMessAyyay:notif];
        }
    }
    if ([bsendtype isEqualToString:@"13"]) {
        NSLog(@"info:%@",notif);
    
//        NSNumber* ntribeid = (NSNumber*)[notif valueForKey:@"tribeid"];
//        NSString* atribeid = [NSString stringWithFormat:@"%d",[ntribeid intValue]];
//        NSMutableArray* tempchatroomarray = (NSMutableArray*)[unKnowCharMessDic valueForKey:atribeid];
//        if (tempchatroomarray) {
//            /*如果该聊天部落，聊天记录已经存在*/
//            [tempchatroomarray addObject:notif];
//        }else{
//            /*如果该聊天部落，聊天记录不存在*/
//            tempchatroomarray = [[NSMutableArray alloc]initWithObjects:notif, nil];
//            [unKnowCharMessDic setObject:tempchatroomarray forKey:atribeid];
//        }
        NSNumber* ntribeid = (NSNumber*)[notif valueForKey:@"tribeid"];
        NSString* atribeid = [NSString stringWithFormat:@"%d",[ntribeid intValue]];
        NSMutableArray* tempchatroomarray = (NSMutableArray*)[unKnowCharMessDic valueForKey:atribeid];
        if (tempchatroomarray) {
            /*手动加上count值*/
            NSDictionary* temp1 = [tempchatroomarray lastObject];
            NSNumber* acount = temp1[@"count"];
            [notif setValue:[NSNumber numberWithInt:([acount integerValue]+1)] forKey:@"count"];
            [tempchatroomarray removeAllObjects];
            /*如果该聊天部落，聊天记录已经存在*/
            [tempchatroomarray addObject:notif];
        }else{
            /*如果该聊天部落，聊天记录不存在*/
            /*手动加上count值
             如果该聊天是刚创建，则判断，是否传过来的messag是否有count
             如果有，则是离线消息，count不变，
             如果没有，则是有人给我发送的消息
             */
            NSNumber* acount = notif[@"count"];
            if (!acount) {
                [notif setValue:[NSNumber numberWithInt:1] forKey:@"count"];
            }
            tempchatroomarray = [[NSMutableArray alloc]initWithObjects:notif, nil];
            [unKnowCharMessDic setObject:tempchatroomarray forKey:atribeid];
        }
        /*因为已经写进数据库，*/
        [haveSeeOffline setObject:@"13" forKey:atribeid];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"addFirend" object:nil userInfo:unKnowCharMessDic];
    }
}

/*自己私聊时调用*/
- (void)addChatRoomMessageArray:(NSMutableDictionary*)notif toOtherid:(NSNumber*)otherid
{
    /*判断接受到的消息类型*/
    [notif setObject:[NSNumber numberWithInt:1] forKey:@"sendtype"];
    UserInfoModel* meUser = [[UserInfoModelManger sharUserInfoModelManger]getMe];
    if (meUser) {
        [notif setValue:meUser.displayname forKey:@"sendername"];
        [notif setValue:meUser.photo forKey:@"senderphoto"];
    }
    
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
//        DebugLog(@"chatRoomMess == %@",chatRoomMess);
        NSNumber* asenderId = [notif valueForKey:@"senderid"] ;
        NSString* tempSenderId = [NSString stringWithFormat:@"%d",[asenderId intValue]];
        NSString* meid = [UserInfoModelManger sharUserInfoModelManger].MeUserId;
    /*写数据库*/
    NSNumber* messtype = [notif valueForKey:@"messtype"];
    if ([messtype intValue]==3) {
        /*发送图片时在界面保存数据*/
    }else{
        NSMutableArray* offarray = (NSMutableArray*)[unKnowCharMessDic valueForKey:atribeid];
        NSString* targeid = (NSString*)[haveSeeOffline valueForKey:atribeid];
//        if ([offarray count] && !targeid) {
//            /*如果存在离线消息不保存*/
//        }else{
            [self saveFmdb:notif];
//        }
//      [self saveFmdb:notif];
    }
    
        if (![tempSenderId isEqualToString:meid]) {
            /*如果是自己发送的就不用发消息刷新界面了*/
            [[NSNotificationCenter defaultCenter] postNotificationName:@"reloadeChatView" object:nil userInfo:notif];
        }
        
//    }
}

/*通过部落id，获取部落聊天内容，
 或者好友id获取私聊内容*/
-(NSMutableArray*)getChatRoomMessArray:(NSString*)ChatRoomid andStart:(NSString*)start andcount:(NSString*)count andSendType:(NSString*)sendType
{

    /*暂时屏蔽获取离线消息*/
     NSMutableArray* temparray1 = [unKnowCharMessDic valueForKey:ChatRoomid];
    NSString* havsee = (NSString*)[haveSeeOffline valueForKey:ChatRoomid];
    if ([temparray1 count] && !havsee) {
        /*当离线消息数据，大于本地缓存中数据*/
//        NSDictionary* last = (NSDictionary*)[temparray1 lastObject];
//        NSNumber* countNum = (NSNumber*)[last valueForKey:@"count"];
//        if (countNum && [countNum integerValue]> [temparray1 count]) {
            [self getOffMessageHistory:ChatRoomid andSendtype:sendType];
            return nil;
//        }
    }

    /*刘振财*/
//    if ([count isEqualToString:@"0"]) {
//        count = @"20";
//    }
    /*每次进来只获取最新20条，否则永远保存，内存会过大*/
   NSMutableArray* chatRoomArray =  [db getChatMessStart:start maxCount:count Andtargetid:ChatRoomid];
//    NSMutableArray* chatRoomArray = (NSMutableArray*) [chatRoomMess valueForKey:ChatRoomid];
    NSMutableArray* temp = [[NSMutableArray alloc]init];
    for (int i=[chatRoomArray count]-1; i>-1; i--) {
        [temp addObject: [chatRoomArray objectAtIndex:i]];
    }
   
    [chatRoomMess setValue:temp forKey:ChatRoomid];
    return temp;
}

/*老方法暂时没有删除*/
-(NSMutableArray*)getChatRoomMessArrayOld:(NSString*)ChatRoomid
{
    NSMutableArray* chatRoomArray = (NSMutableArray*) [chatRoomMess valueForKey:ChatRoomid];
    return chatRoomArray;
}

/*把我自己发送的消息添加进入聊天室*/
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
            /*手动加上count值*/
            NSDictionary* temp1 = [tempchatroomarray lastObject];
            NSNumber* acount = temp1[@"count"];
            [message setValue:[NSNumber numberWithInt:([acount integerValue]+1)] forKey:@"count"];
            [tempchatroomarray removeAllObjects];
            /*如果该聊天部落，聊天记录已经存在*/
            [tempchatroomarray addObject:message];
            
           
        }else{
            /*手动加上count值
             如果该聊天是刚创建，则判断，是否传过来的messag是否有count
             如果有，则是离线消息，count不变，
             如果没有，则是有人给我发送的消息
             */
            NSNumber* acount = message[@"count"];
            if (!acount) {
                [message setValue:[NSNumber numberWithInt:1] forKey:@"count"];
            }

            /*如果该聊天部落，聊天记录不存在*/
            tempchatroomarray = [[NSMutableArray alloc]initWithObjects:message, nil];
            [unKnowCharMessDic setObject:tempchatroomarray forKey:atribeid];
        }
//        DebugLog(@"chatRoomMess == %@",chatRoomMess);
       
        /*如果正在获取离线消息就不用发消息刷新界面了*/
        [[NSNotificationCenter defaultCenter] postNotificationName:@"reloadeChatMessInfo" object:nil userInfo:unKnowCharMessDic];
    }
    else if ([bsendtype isEqualToString:@"2"]/*|| [bsendtype isEqualToString:@"13"]*/){
        /*部落聊天*/
        /*
         chatRoomMess每一个元素是一个聊天室数组tempchatroomArray，通过tribeid查找
         */
        NSNumber* ntribeid = (NSNumber*)[message valueForKey:@"tribeid"];
        NSString* atribeid = [NSString stringWithFormat:@"%d",[ntribeid intValue]];
        NSMutableArray* tempchatroomarray = (NSMutableArray*)[unKnowCharMessDic valueForKey:atribeid];
        if (tempchatroomarray) {
            /*手动加上count值*/
            NSDictionary* temp1 = [tempchatroomarray lastObject];
            NSNumber* acount = temp1[@"count"];
            [message setValue:[NSNumber numberWithInt:([acount integerValue]+1)] forKey:@"count"];
            [tempchatroomarray removeAllObjects];
            /*如果该聊天部落，聊天记录已经存在*/
            [tempchatroomarray addObject:message];
        }else{
            /*如果该聊天部落，聊天记录不存在*/
            /*手动加上count值
             如果该聊天是刚创建，则判断，是否传过来的messag是否有count
             如果有，则是离线消息，count不变，
             如果没有，则是有人给我发送的消息
             */
            NSNumber* acount = message[@"count"];
            if (!acount) {
                [message setValue:[NSNumber numberWithInt:1] forKey:@"count"];
            }
            tempchatroomarray = [[NSMutableArray alloc]initWithObjects:message, nil];
            [unKnowCharMessDic setObject:tempchatroomarray forKey:atribeid];
        }
        
        DebugLog(@"unKnowCharMessDic == %@",unKnowCharMessDic);
    
        /*如果是自己发送的就不用发消息刷新界面了*/
        [[NSNotificationCenter defaultCenter] postNotificationName:@"reloadeChatMessInfo" object:nil userInfo:unKnowCharMessDic];
    }
}

//#pragma mark 临时存储离线消息
//- (void)AddToTempunKnowCharMessAyyay:(NSMutableDictionary*)message
//{
//    /*判断接受到的消息类型*/
//    /*
//     date = "2014-07-12 05:41:40";
//     mess = Thy;
//     messid = 1591;
//     messtype = 1;
//     sid = 100070;
//     sname = "\U5218\U632f\U624d2";
//     sphoto = "20140629/1043057210.png";
//     */
//
//        NSNumber* ntribeid = (NSNumber*)[message valueForKey:@"sid"];
////        NSString* atribeid = [NSString stringWithFormat:@"%d",[ntribeid intValue]];
//        [message setValue:ntribeid forKey:@"tribeid"];
//        [message setValue:ntribeid forKey:@"senderid"];
//        [message setValue:[message valueForKey:@"sphoto"] forKey:@"senderphoto"];
//
//        [tempUnKnowCharMessArray insertObject:message atIndex:0];
//            
// 
//        DebugLog(@"tempUnKnowCharMessArray == %@",tempUnKnowCharMessArray);
//
//}

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
    /*
     1、将服务器状态置为已读
     此处应该启动计时器，
     如果没有返回则过30秒，
     继续发送消息
     2、进行该操作同事，删除本地离线消息
     */
    /*如果是自己发送的就不用发消息刷新界面了*/

    NSLog(@"向服务器发送已读通知");
    if ([[unKnowCharMessDic allKeys] count] &&[unKnowCharMessDic valueForKey:tribeid]) {
         [unKnowCharMessDic removeObjectForKey:tribeid];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"reloadeChatMessInfo" object:nil userInfo:unKnowCharMessDic];
    }


    if ([[unKnowCharMessDic allKeys]count]==0) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"NoChatMessInfo" object:nil userInfo:unKnowCharMessDic];
        
    }
    
    if ([type isEqualToString:@"1"]) {
        /*私聊*/
        [DataInterface recvMessage:messigeid userid:tribeid withCompletionHandler:^(NSMutableDictionary*dic){
            /*	opercode:"0132",		//operCode为0131，客户端通过该字段确定事件
             statecode:"0200",		//StateCode取值：发送成功[0200],发送失败[其他]
             info:"操作成功",		//客户端可以使用该info进行提示
             sign:"9aldai9adsf"*/
            NSLog(@"置为已读返回数据：%@",dic);
            NSLog(@"info==%@",dic[@"info"]);
            NSString* statecode = dic[@"statecode"];
            //        NSString* statecode = [NSString stringWithFormat:@"%d",[astatecode integerValue]];
            if ([statecode isEqualToString:@"0200"]) {
                
                /*未读消息中移除*/
                NSLog(@"服务器收到已读通知");
                
            }
        }];
        
        /*以下方法有错误，不能使用，不要再打开了*/
//        [DataInterface recvMessage:messigeid
//                           tribeid:tribeid
//                              type:type
//             withCompletionHandler:^(NSMutableDictionary *dict){
//            NSLog(@"info==%@",dict[@"info"]);
//            NSString* statecode = dict[@"statecode"];
//            if ([statecode isEqualToString:@"0200"]) {
//                /*未读消息中移除*/
//                NSLog(@"服务器收到已读通知xxx");
//            }
//        }];
        
    }else{
        [DataInterface recvMessage:messigeid tribeid:tribeid type:type withCompletionHandler:^(NSMutableDictionary*dic){
            /*	opercode:"0132",		//operCode为0131，客户端通过该字段确定事件
             statecode:"0200",		//StateCode取值：发送成功[0200],发送失败[其他]
             info:"操作成功",		//客户端可以使用该info进行提示
             sign:"9aldai9adsf"*/
            NSLog(@"info==%@",dic[@"info"]);
            NSString* statecode = dic[@"statecode"];
            //        NSString* statecode = [NSString stringWithFormat:@"%d",[astatecode integerValue]];
            if ([statecode isEqualToString:@"0200"]) {
             
                NSLog(@"服务器收到已读通知");
                
            }
        }];
    }

}

#pragma mark 登录成功后获取用户离线消息
/*登录成功后获取用户离线消息*/
- (void)getOfflineMessage
{
    NSLog(@"获取离线信息");
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
        NSLog(@"backDic==%@",backDic);
        NSArray* chatdata = (NSArray*)[backDic valueForKey:@"chat"];
        for (int i=0; i<[chatdata count]; i++) {
            NSMutableDictionary* tempdic = [[NSMutableDictionary alloc]initWithDictionary:[chatdata objectAtIndex:i]];
            NSNumber* asendtype = [tempdic valueForKey:@"sendtype"];
            NSString* sendtype = [NSString stringWithFormat:@"%d",[asendtype integerValue]];
            if ([sendtype isEqualToString:@"1"]) {
                /*私聊*/
                [self AddTounKnowCharMessAyyay:tempdic];
            }else if([sendtype isEqualToString:@"2"])
            {
              /*部落聊天*/
                [self AddTounKnowCharMessAyyay:tempdic];
            }
            
        }
        
        NSArray* official = (NSArray*)[backDic valueForKey:@"official"];
        for (int i=0; i<[official count]; i++) {
            NSMutableDictionary* tempdic = [[NSMutableDictionary alloc]initWithDictionary:[official objectAtIndex:i]];
            NSNumber* asendtype = [tempdic valueForKey:@"sendtype"];
            NSString* bsendtype = [NSString stringWithFormat:@"%d",[asendtype integerValue]];
            if ([bsendtype isEqualToString:@"3"] || [bsendtype isEqualToString:@"4"] || [bsendtype isEqualToString:@"0"] || [bsendtype isEqualToString:@"5"]
                || [bsendtype isEqualToString:@"6"]
                || [bsendtype isEqualToString:@"7"] || [bsendtype isEqualToString:@"12"] /*|| [bsendtype isEqualToString:@"13"]这是分享到部落的活动，文章和名片*/){
                NSLog(@"info:%@",tempdic);

//                if (![tempSenderId isEqualToString:meid]) {
                    [self AddSystemMessAyyay:tempdic];
                    /*如果是自己发送的就不用发消息刷新界面了*/
                    //            [[NSNotificationCenter defaultCenter] postNotificationName:@"addFirend" object:nil userInfo:notif];
                }

            
        }
        
    }];
}

/*
 opercode:"0133",
 userid:"1234565",		//用户唯一标识
 token:"ab123456789"		//当用户登陆之后，服务器会指定唯一的令牌给相应的客户端，通过此令牌拥有用户权限
 targetid:"12344556",		//发送给，好友或部落
 sendtype:"1",			//1为好友私聊，2为部落聊天
 start:"10",			//起始消息version号，不填写该字段读取最新消息n个
 count:"20"			//获取消息数量
 */
#pragma mark 获取聊天历史记录
-(void)getMessageHistory:(NSMutableDictionary *)fromdic andSendtype:(NSString*)sendtype andStartMessageid:(NSString*)startid
{
    NSString* astartid = nil;
    NSString* direction = nil;
    if (!startid) {
        astartid= @"0";
        direction= @"after";
       
    }else{
        astartid = startid;
        direction= @"before";
    }
    
    NSLog(@"获取聊天历史记录\n");
    NSString* targetid = fromdic[@"targetid"];
    NSString* count = fromdic[@"count"];
    if ([count integerValue]>20) {
        count= [NSString stringWithFormat:@"%d",20];
    }else if(!count){
        
        count= [NSString stringWithFormat:@"%d",20];
    }
    
    [DataInterface getChatHistory:targetid sendtype:sendtype start:astartid  direction:direction count:count withCompletionHandler:^(NSMutableDictionary *dict) {
        NSMutableArray* list = (NSMutableArray*)[dict valueForKey:@"list"];
        NSMutableArray* chatRoomMessArray = (NSMutableArray*)[chatRoomMess valueForKey:targetid];
        if (!chatRoomMessArray) {
            chatRoomMessArray = [[NSMutableArray alloc]init];
        }
//        for (int i = ([list count]-1); i>=0; i--)
        for (int i = 0; i<([list count]); i++)
        {
            NSMutableDictionary* tempdic = [[NSMutableDictionary alloc]initWithDictionary:[list objectAtIndex:i]];
            NSLog(@"tempdic == %@",tempdic);
            
            NSNumber* ntribeid = (NSNumber*)[tempdic valueForKey:@"sid"];
//            NSString* atribeid = [NSString stringWithFormat:@"%d",[ntribeid intValue]];
            [tempdic setValue:ntribeid forKey:@"tribeid"];
            [tempdic setValue:ntribeid forKey:@"senderid"];
            [tempdic setValue:[tempdic valueForKey:@"sphoto"] forKey:@"senderphoto"];
            [tempdic setValue:[tempdic valueForKey:@"sname"] forKey:@"sendername"];
            /*写入数据库*/
            [self saveFmdb:tempdic];
            [chatRoomMessArray insertObject:tempdic atIndex:0];
        }
        
        /*移除离线消息*/
       NSMutableArray* temparray1 = [unKnowCharMessDic valueForKey:targetid];
        if (temparray1) {
             [unKnowCharMessDic removeObjectForKey:temparray1];
        }
       
        
//        NSMutableArray* temp2 = [[NSMutableArray alloc]initWithArray:tempUnKnowCharMessArray];
        NSLog(@"chatRoomMessArray == %@",chatRoomMessArray);
        [chatRoomMess setObject:chatRoomMessArray forKey:targetid];
        

        /*暂时不移除*/
//         [tempUnKnowCharMessArray removeAllObjects];
        if ([sendtype isEqualToString:@"1"]) {
            
            [[NSNotificationCenter defaultCenter] postNotificationName:@"reloadeChatViewAll" object:nil userInfo:nil];
        }else{
            [[NSNotificationCenter defaultCenter] postNotificationName:@"reloadeChatRoomAll" object:nil userInfo:nil];
        }
        /*
         list:				//
         [
         {messid:"123",sid:"123456",sname:"发送人名字",sphoto:"1.jpg",date:"2014-05-06 22:13:11",messtype:"1",mess:"这是消息"},
         {messid:"124",sid:"123456",sname:"发送人名字",sphoto:"1.jpg",date:"2014-05-06 22:13:11",messtype:"1",mess:"这是消息"},
         {messid:"125",sid:"123456",sname:"发送人名字",sphoto:"1.jpg",date:"2014-05-06 22:13:11",messtype:"1",mess:"这是消息"},
         ......
         ]
         */
    }];
}

#pragma mark 获取所有离线消息详情
-(void)getOffMessageHistory:(NSString *)targetid andSendtype:(NSString*)sendtype
{
    UIWindow* aWindow = [[UIApplication sharedApplication]delegate].window;
    
    progressHUD = [[MBProgressHUD alloc] initWithWindow:aWindow];
    progressHUD.animationType = MBProgressHUDAnimationFade;
    progressHUD.labelFont = [UIFont systemFontOfSize:13.f];
        //       [keyWindow addSubview:progressHUD];
    
    //    progressHUD.labelText = @"正在获取离线消息，请耐心等待...";
    [aWindow addSubview:progressHUD];
    progressHUD.labelText = @"正在获取离线消息，请耐心等待...";
    [progressHUD show:YES];
    
    
    NSString* astartid = @"0";
    NSString* direction = @"after";
    NSString* count = nil;
    
    /*离线消息*/
    NSMutableArray* temparray1 = [unKnowCharMessDic valueForKey:targetid];
    if (temparray1) {
        NSDictionary* last = (NSDictionary*)[temparray1 lastObject];
//        [unKnowCharMessDic removeObjectForKey:temparray1];
        NSNumber* acou = (NSNumber*)[last valueForKey:@"count"];
        count = [NSString stringWithFormat:@"%d",[acou intValue]];
    }
//    return;
    if (!count) {
        count = @"20";
    }
    [DataInterface getChatHistory:targetid sendtype:sendtype start:astartid  direction:direction count:count withCompletionHandler:^(NSMutableDictionary *dict) {
        NSMutableArray* list = (NSMutableArray*)[dict valueForKey:@"list"];
        NSMutableArray* chatRoomMessArray = [[NSMutableArray alloc]init];
        //        for (int i = ([list count]-1); i>=0; i--)
        for (int i = [list count]-1; i>-1; i--)
        {
            NSMutableDictionary* tempdic = [[NSMutableDictionary alloc]initWithDictionary:[list objectAtIndex:i]];
            NSLog(@"tempdic == %@",tempdic);
            
            NSNumber* ntribeid = (NSNumber*)[tempdic valueForKey:@"sid"];
            //            NSString* atribeid = [NSString stringWithFormat:@"%d",[ntribeid intValue]];
            [tempdic setValue:targetid forKey:@"tribeid"];
            [tempdic setValue:ntribeid forKey:@"senderid"];
            [tempdic setValue:[tempdic valueForKey:@"sphoto"] forKey:@"senderphoto"];
            [tempdic setValue:[tempdic valueForKey:@"sname"] forKey:@"sendername"];
            /*写入数据库*/
            [self saveFmdb:tempdic];
            [chatRoomMessArray addObject:tempdic];
        }
        
 
        
        
        //        NSMutableArray* temp2 = [[NSMutableArray alloc]initWithArray:tempUnKnowCharMessArray];
        NSLog(@"chatRoomMessArray == %@",chatRoomMessArray);
        [chatRoomMess setObject:chatRoomMessArray forKey:targetid];
        
        NSDictionary *usercount = [[NSDictionary alloc]initWithObjectsAndKeys:chatRoomMessArray,@"chatRoomMessArray", nil];
        /*离线消息中移除*/
        [unKnowCharMessDic removeObjectForKey:targetid];
        [haveSeeOffline setObject:targetid forKey:targetid];
        /*关闭对话框*/
        [self hideprogressHUD];
        /*暂时不移除*/
        if ([sendtype isEqualToString:@"1"]) {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"reloadeChatViewAll" object:nil userInfo:usercount];
        }else{
            [[NSNotificationCenter defaultCenter] postNotificationName:@"reloadeChatRoomAll" object:nil userInfo:usercount];
        }
        /*
         list:				//
         [
         {messid:"123",sid:"123456",sname:"发送人名字",sphoto:"1.jpg",date:"2014-05-06 22:13:11",messtype:"1",mess:"这是消息"},
         {messid:"124",sid:"123456",sname:"发送人名字",sphoto:"1.jpg",date:"2014-05-06 22:13:11",messtype:"1",mess:"这是消息"},
         {messid:"125",sid:"123456",sname:"发送人名字",sphoto:"1.jpg",date:"2014-05-06 22:13:11",messtype:"1",mess:"这是消息"},
         ......
         ]
         */
    }];
}

#pragma mark 从本地获取聊天记录，当本地没有时，就不获取了
- (NSMutableArray*)getHistoryFormLocalByTargid:(NSString*)atargetid andBack:(BOOL)back
{
    
    NSMutableArray* offarray = (NSMutableArray*)[unKnowCharMessDic valueForKey:atargetid];
    if ([offarray count]) {
        /*如果有离线消息，先获取离线消息*/
        
    }else{
        /*
         start 总记录数组当中最后一位
         */
        /*back 为yes时，查看start时间之前的历史记录，如9月1号之前，8月
         no，查看start之后的记录，如果9月1日之后9月2日*/
        NSMutableArray* chatRoomArray = (NSMutableArray*) [chatRoomMess valueForKey:atargetid];
        NSInteger arraycount = [chatRoomArray count];
        if (!hisStatDic) {
            hisStatDic = [[NSMutableDictionary alloc]init];
        }
        NSString* start = [hisStatDic valueForKey:atargetid];
        if (!start) {
            start = [NSString stringWithFormat:@"%d",arraycount];
        }
        NSInteger Instart = [start integerValue];
        if (back) {
            /*下啦刷新*/
            //        NSInteger Instart = [start integerValue];
            //        start = [NSString stringWithFormat:@"%d",Instart-[chatRoomArray count]];
            /*此时插入前面*/
            NSMutableArray* templocal = [db getChatMessStart:start maxCount:@"20" Andtargetid:atargetid];
            
            /*因为是倒的所以要这么插入*/
            NSMutableArray *tempArray =  [[NSMutableArray alloc]init];
            for (int i= [templocal count]-1; i>-1; i--) {
                [tempArray addObject:[templocal objectAtIndex:i]];
            }
            
            //            /*此时插入前面*/
            //           NSMutableArray *tempArray =  [[NSMutableArray alloc]initWithArray:[db getChatMessStart:start maxCount:@"20" Andtargetid:atargetid]];
            
            /*记录最新stat值*/
            start = [NSString stringWithFormat:@"%d",(Instart +[tempArray count])];
            [hisStatDic setValue:start forKey:atargetid];
            if ([tempArray count]==0) {
                NSDictionary* noUser = [[NSDictionary alloc]initWithObjectsAndKeys:atargetid,@"targetid", nil];
//                /*没有历史记录*/
                if (delegate && [delegate respondsToSelector:@selector(NoHistory)]) {
                    [delegate NoHistory];
                }
            }else{
                /*内存中只存储40个*/
                if ( arraycount>=40) {
                    NSRange rang = NSMakeRange(20, arraycount -20);
                    [chatRoomArray removeObjectsInRange:rang];
                }
                [tempArray addObjectsFromArray:chatRoomArray];
                [chatRoomMess setObject:tempArray forKey:atargetid];
            }
            
            return tempArray;
            
        }else{
            
            if (Instart<=40) {
                NSDictionary* noUser = [[NSDictionary alloc]initWithObjectsAndKeys:atargetid,@"targetid", nil];
                /*没有历史记录*/
//                [[NSNotificationCenter defaultCenter] postNotificationName:@"NOHistory" object:nil userInfo:noUser];
                if (delegate && [delegate respondsToSelector:@selector(NoHistory)]) {
                    [delegate NoHistory];
                }
            }else{
                /*上啦刷新*/
                if (arraycount >=20) {
                    NSRange rang = NSMakeRange(0, arraycount -20);
                    [chatRoomArray removeObjectsInRange:rang];
                }
                
                /*此时追加*/
                NSMutableArray *tempArray = [[NSMutableArray alloc]initWithArray:chatRoomArray];
                NSMutableArray* resultarray = nil;
                if ((Instart -arraycount -20)>0) {
                    start = [NSString stringWithFormat:@"%d",(Instart -arraycount -20)];
                    resultarray = [db getChatMessStart:start maxCount:@"20" Andtargetid:atargetid];
                }else{
                    start = @"0";
                    NSInteger temp = (Instart -arraycount);
                    //            if (temp<20) {
                    //                temp
                    //            }
                    resultarray = [db getChatMessStart:start maxCount:[NSString stringWithFormat:@"%d",temp] Andtargetid:atargetid];
                }
                for (int i=[resultarray count]-1; i>-1; i--) {
                    [tempArray addObject:[resultarray objectAtIndex:i]];
                }
                //            [tempArray addObjectsFromArray:resultarray];
                [chatRoomMess setObject:tempArray forKey:atargetid];
                
                start = [NSString stringWithFormat:@"%d",([start intValue]+[tempArray count])];
                [hisStatDic setValue:start forKey:atargetid];
                return tempArray;
                
                
            }
            
            
        }
  
    }

    return nil;
}

#pragma mark 显示加载框
- (void)showprogressHUD:(NSString*)string withView:(UIView*)aview
{
//    UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
//    if (!progressHUD) {
//        progressHUD = [[MBProgressHUD alloc] initWithView:aview];
//        progressHUD.animationType = MBProgressHUDAnimationFade;
//        progressHUD.labelFont = [UIFont systemFontOfSize:13.f];
////       [keyWindow addSubview:progressHUD];
//    }
////    progressHUD.labelText = @"正在获取离线消息，请耐心等待...";
//    [aview addSubview:progressHUD];
//    progressHUD.labelText = string;
//   
//    [progressHUD show:YES];
}

- (void)hideprogressHUD
{
     [progressHUD hide:YES];
}

#pragma mark 获取图片接口

- (void)getimageView:(UIImageView*)picImageView byImagePath:(NSString*)pic
{
    NSURL *url2 = IMGURL(pic);
    
    [picImageView setImageWithURL:url2 completed:^(UIImage* aimage, NSError *error, SDImageCacheType cacheType)
     {
         
         NSLog(@"getimageView == %@\n pic==%@",aimage,pic);
     }];
    
    
   
//    if(!historyPicDic)
//    {
//        historyPicDic = [[NSMutableDictionary alloc]init];
//        /*正在获取是1，成功是2，字符串*/
////        querPic = [[NSMutableDictionary alloc]init];
//    }
//    UIImage* tempic = (UIImage*)[historyPicDic valueForKey:pic];
////    id  state = [querPic valueForKey:pic];
//    /*因为总内存警报，所以每次最多获取10个图片*/
//    if (!tempic /*&& !state &&[[querPic allKeys]count]<10*/) {
//        piccount++;
//        NSLog(@"获取图片次数==%d\n",piccount);
//        NSURL *url2 = IMGURL(pic);
//        [picImageView setImageWithURL:url2 completed:^(UIImage* aimage, NSError *error, SDImageCacheType cacheType)
//         {
//             [querPic removeObjectForKey:pic];
//             
//             NSLog(@"getimageView == %@\n pic==%@",aimage,pic);
//            
//             if (aimage) {
//                 [historyPicDic setObject:aimage forKey:pic];
//             }
//         }];
//
//    }else if(tempic){
//        NSLog(@"getimageView == %@\n pic==%@",tempic,pic);
//        picImageView.image = tempic;
//    }
    

}



#pragma mark 保存进入数据库
- (void)saveFmdb:(NSDictionary*)dic
{
    NSLog(@"写数据库");
    ChatMess* chat = [[ChatMess alloc]init];
    //聊天主键id
//    chat.cid = @"";
//    // 用户id
//    chat.uid = @"";
    // 会话唯一标示
    //    chat.sessionid = @"";

    // 消息唯一标示
    NSNumber* amessid = (NSNumber*)dic[@"messid"];
    if (!amessid) {
        amessid = [NSNumber numberWithInt:-1];
    }
    chat.msgid = amessid;//nsnumber
    // 消息类型
    NSNumber* asendtype = (NSNumber*)dic[@"sendtype"];
    if (!asendtype) {
        asendtype = (NSNumber*)dic[@"messtype"];
    }
    chat.type = asendtype;
    // 来自id标示
    chat.fromid = (NSNumber*)dic[@"senderid"];//nsnumber
    // 来自name标示
    chat.fromname = dic[@"sendername"];
    // 来自图片标示
    chat.fromphotoid = dic[@"senderphoto"];
    // 消息时间
//    chat.dttime = @"";
    // 消息日期
    chat.dtdate = dic[@"date"];
//    chat.dtdate = @"20140818123";
    // 内容文本
    chat.contenttext = dic[@"mess"];
    // 目标id标示
    chat.targetid = (NSNumber*)dic[@"tribeid"];//nsnumbe
    // 目标name标示
    chat.targetname = dic[@"tribename"];
    // 目标图片
    chat.targetphoto = dic[@"tribephoto"];
    // 目标消息类型
    chat.messagetype = (NSNumber*)dic[@"messtype"];
    if (!chat.type || !chat.fromid || !chat.fromname || !chat.fromphotoid || !chat.dtdate || !chat.contenttext || !chat.targetid) {
         NSLog(@"有数据为空==%@",dic);
        return;
    }
    NSLog(@"数据正常");
    if (![db Search:chat.dtdate]) {
        /*判断该数据，数据库中是否存在如果不存在*/
          [db saveChatMess:chat];
    }
 
   
}

/*清空所有数据*/
- (void)cleanAllData
{
    [sysMess removeAllObjects];
    [sysMessDict removeAllObjects];
    [chatRoomMess removeAllObjects];
    [unKnowCharMessDic removeAllObjects];
    [hisStatDic removeAllObjects];
    [db clearAllUserData];
    
}
@end

