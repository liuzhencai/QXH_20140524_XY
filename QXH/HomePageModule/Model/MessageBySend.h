//
//  MessageBySend.h
//  QXH
//
//  Created by liuzhencai on 14-6-27.
//  Copyright (c) 2014年 ZhaoLilong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MBProgressHUD.h"
#import "DBManager.h"

//@protocol MessageBySendDelegate <NSObject>
//
///*部落聊天室聊天刷新接口*/
//- (void)ChatRoomReloade:(NSMutableArray*)achatRoomMess;
//
//@end

#define ChatMessageFile   @"ChatMessageFile.plist"

@protocol MessageBySendDelegate <NSObject>

- (void)NoHistory;

@end

@interface MessageBySend : NSObject
{
    /*sendtype 0;系统消息存储进该数组，其中元素是字典*/
    NSMutableArray* sysMess;
    NSMutableDictionary *sysMessDict;
    /*sendtype 1;好友私聊存储进该数组，其中元素是字典*/
//    NSMutableArray* chatMess;
    /*sendtype 2;部落聊天存储进该数组，其中元素是字典*/
    NSMutableDictionary* chatRoomMess;
//    /*sendtype 3;加好友申请存储进该数组，其中元素是字典*/
//    NSMutableArray* friendReceiveMess;
//    /*sendtype 4;处理好友申请存储进该数组，其中元素是字典*/
//    NSMutableArray* friendDoMess;
//    /*sendtype 5;加入部落申请存储进该数组，其中元素是字典*/
//    NSMutableArray* TribeReceiveMess;
//    /*sendtype 6;处理加入部落申请存储进该数组，其中元素是字典*/
//    NSMutableArray* TribeDoMess;
//    /*sendtype 7;完全退出部落存储进该数组，其中元素是字典*/
//    NSMutableArray* TribeDestroyMess;
//    /*sendtype 8;进入部落存储进该数组，其中元素是字典*/
//    NSMutableArray* TribeInMess;
//    /*sendtype 9;退出部落房间存储进该数组，其中元素是字典*/
//    NSMutableArray* TribeExitMess;
//    /*sendtype 10;好友上线通知存储进该数组，其中元素是字典*/
//    NSMutableArray* friendOnlineMess;
//    /*sendtype 11;好友下线通知存储进该数组，其中元素是字典*/
//    NSMutableArray* friendofflineMess;
//    /*sendtype 12;@某人存储进该数组，其中元素是字典*/
//    NSMutableArray* someOnMess;
//    /*sendtype 13;@部落存储进该数组，其中元素是字典*/
//    NSMutableArray* someTribeOnMess;
    /*未阅读聊天记录存储进该数组，其中元素是字典*/
    NSMutableDictionary* unKnowCharMessDic;
//    /*获取离线消息时，临时存储，其中元素是字典*/
//    NSMutableArray* tempUnKnowCharMessArray;
    
    /*存储上一个获取到的消息，如果两个一样，就抛弃*/
    NSString* messid;
    
    MBProgressHUD* progressHUD;
    
    /*文件路径*/
    DBManager* db;
    
    /*聊天记录显示的最后一条信息位置的字典*/
    NSMutableDictionary* hisStatDic;
    
    /*储存已经看过的离线消息*/
    NSMutableDictionary* haveSeeOffline;
}

@property(nonatomic,assign)id<MessageBySendDelegate>delegate;

+(MessageBySend*)sharMessageBySend;

/*通过部落id，获取部落聊天内容*/
-(NSMutableArray*)getChatRoomMessArray:(NSString*)ChatRoomid andStart:(NSString*)start andcount:(NSString*)count andSendType:(NSString*)sendType;
-(NSMutableArray*)getChatRoomMessArrayOld:(NSString*)ChatRoomid;

/*获取聊天记录*/
- (NSMutableArray*)getHistoryFormLocalByTargid:(NSString*)atargetid andBack:(BOOL)back;
/*
 1、把我自己发送的消息添加进入聊天室
 2、对方发送私聊
 */
- (void)addChatRoomMessageByMe:(NSMutableDictionary*)Message andSendtype:(NSNumber*)asendtype;
/*自己私聊时调用*/
- (void)addChatRoomMessageArray:(NSMutableDictionary*)notif toOtherid:(NSNumber*)otherid;
/*主动获取聊天记录接口*/
- (NSMutableDictionary*)getunKnowCharMessDic;
/*查卡系统发送的消息，将聊天记录中消息置为已读*/
-(void)ReceiveAndSeeMessige:(NSString*)messigeid
                       type:(NSString*)type
                    tribeid:(NSString*)tribeid;
/*登录成功后获取用户离线消息*/
- (void)getOfflineMessage;
/*保存数据库，外部当发送图片时调用*/
- (void)saveFmdb:(NSDictionary*)dic;
#pragma mark 获取网络聊天历史记录
-(void)getMessageHistory:(NSMutableDictionary *)fromdic andSendtype:(NSString*)sendtype andStartMessageid:(NSString*)startid;
#pragma mark 全屏等待框
- (void)showprogressHUD:(NSString*)string withView:(UIView*)aview;
- (void)hideprogressHUD;

#pragma mark 获取图片接口
- (void)getimageView:(UIImageView*)picImageView byImagePath:(NSString*)pic;

/*清空所有数据*/
- (void)cleanAllData;
@end


/*
 //推送消息到客户端
 Response:{
 opercode:"0131",		//operCode为0131，客户端通过该字段确定事件
 statecode:"0200",		//StateCode取值：发送成功[0200],发送失败[其他]
 info:"message",			//客户端可以使用该info进行提示，如:登录成功/账号或密码错误,登录失败!
 senderid:"123456",		//发送者的id
 sendername:"发送人名字",	//发送人名称,如果为系统消息sendername="系统消息"
 senderphoto:"1.jpg",		//发送者的头像
 sendtype:"1",			//0为系统消息,1为好友私聊，2为部落聊天,3为加好友申请，4为处理请求好友申请，5为加入部落申请,6为处理部落加入申请,7为完全退出部落,8为进入部落，9为退出部落房间,10好友上线通知，11好友下线通知,12 @某人,13 @部落
 messtype:"1",			//消息类型 1为文本，2为json对象，3为图片，4为录音
 date:"2014-05-17 17:57:11",	//消息时间
 tribeid:"12345",		//部落id(sendtype=2时读取该字段)
 tribename:"部落名称",		//部落名称(sendtype=2时读取该字段)
 tribephoto:"2.jpg",		//部落头像
 messid:"123456",		//消息唯一标识符
 mess:"消息内容",		//消息内容
 sign:"9aldai9adsf"		//sign请求唯一标识
 }
 
 json对象的mess说明：
 名片:{userid:"123",username:"周扒皮",photo:"2",displayname:"张三",signature:"这个是签名...",usertype:"0",level:"1",uduty:"某某学校 校长"}
 广场文章:{artid:"1234",sid:"123456",sname:"发送人名字",sphoto:"1.jpg",date:"2014-05-06 22:13:11",title:"标题",artimgs:"1.jpg,2.jpg",content:"这是消息",authflag:"0",browsetime:10},
 咨询违章:{artid:"1234",sid:"123456",sname:"发送人名字",sphoto:"1.jpg",date:"2014-05-06 22:13:11",title:"标题",artimgs:"1.jpg,2.jpg",content:"这是消息",authflag:"0",browsetime:10},
 活动:{actid:"1234",actname:"活动名称",photos:"1.jpg,2.jpg",signupbegindate:"2014-05-01 12:00:00",signupenddate:"2014-05-03 12:00:00",begindate:"2014-05-05 12:00:00",enddate:"2014-05-05 13:00:00",actaddr:"活动地址",maxcount:"30",nowcount:"10",folcount:"10",tags:"标签，标签",desc:"",acttype:"活动类型"}
 */
