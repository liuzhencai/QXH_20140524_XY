//
//  UDPRequest.h
//  QXH
//
//  Created by ZhaoLilong on 5/28/14.
//  Copyright (c) 2014 ZhaoLilong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GCDAsyncUdpSocket.h"

/*
 ---------------------------------------------------------------------------------------------------------------------------------
 API:0101(UDP) 心跳:维持客户端与服务器连接
 --------------------------------------------------------
 Request(Client Call):
 {
 opercode:"0101",		//操作码：固定值0101 ，指维持心跳请求
 userid:666666,			//标识用户的唯一标识
 token:"ab123456789"		//当用户登陆之后，服务器会指定唯一的令牌给相应的客户端，通过此令牌拥有用户权限
 sign:"9aldai9adsf"		//sign请求唯一标识
 }
 
 Response:{
 opercode:"0101",
 statecode:"0200"		//0200为成功，0440
 info:"心跳成功"			//客户端可以使用该info进行提示，如:登录成功/账号或密码错误,登录失败!
 sign:"9aldai9adsf"		//sign请求唯一标识
 }
  ---------------------------------------------------------------------------------------------------------------------------------
 API:0102(UDP) 用户登录 (登录时username/phone选择其一,如果都写则读取username作为登录依据)
 --------------------------------------------------------
 Request(Client Call):
 {
 opercode:"0102",
 username:"tianbuleng",		//用户的账号
 pwd:"1111111111111",		//MD5加密后的密码
 sign:"9aldai9adsf",		//sign请求唯一标识
 }
 //用户登录成功/失败，服务器发送udp报文 通知客户端登录状态
 Response:{
 opercode:"0102",		//operCode为0102，客户端通过该字段确定事件
 statecode:"0200",		//StateCode取值：登录成功[0200],登录失败[其他]
 info:"登录成功"			//客户端可以使用该info进行提示，如:登录成功/账号或密码错误,登录失败!
 userid:"666666",		//标识用户的唯一标识
 token:"ab123456789",		//当用户登陆之后，服务器会指定唯一的令牌给相应的客户端，通过此令牌拥有用户权限
 sign:"9aldai9adsf",		//sign请求唯一标识
 }
 
 
 ---------------------------------------------------------------------------------------------------------------------------------
 API:0103(UDP) 用户退出
 --------------------------------------------------------
 Request(Client Call):
 {
 opercode:"0103",
 userid:"666666",		//标识用户的唯一标识
 token:"ab123456789"		//当用户登陆之后，服务器会指定唯一的令牌给相应的客户端，通过此令牌拥有用户权限
 sign:"9aldai9adsf"		//sign请求唯一标识
 }
 //用户登录成功/失败，服务器发送udp报文 通知客户端登录状态
 Response:{
 opercode:"0103",		//operCode为0103，客户端通过该字段确定事件
 statecode:"0200",		//StateCode取值：退出成功[0200],退出失败[其他]
 info:"退出成功"
 sign:"9aldai9adsf"		//sign请求唯一标识
 
 }
 
 
 ---------------------------------------------------------------------------------------------------------------------------------
 
 ---------------------------------------------------------------------------------------------------------------------------------
 API:0130(UDP) 聊天通用接口
 --------------------------------------------------------
 Request(Client Call):
 {
 opercode:"0130",
 userid:"1234565",		//用户唯一标识
 token:"ab123456789"		//当用户登陆之后，服务器会指定唯一的令牌给相应的客户端，通过此令牌拥有用户权限
 targetid:"12344556",		//发送给，好友或部落
 sendtype:"1",			//1为好友私聊，2为部落聊天
 mess:"消息内容",		//消息内容
 sign:"9aldai9adsf"		//sign请求唯一标识
 }
 
 Response:{
 opercode:"0130",		//operCode为0130，客户端通过该字段确定事件
 statecode:"0200",		//StateCode取值：发送成功[0200],发送失败[其他]
 info:"发送成功",		//客户端可以使用该info进行提示，如:登录成功/账号或密码错误,登录失败!
 sign:"9aldai9adsf"		//sign请求唯一标识
 }
  ---------------------------------------------------------------------------------------------------------------------------------
 API:0131(UDP) 服务器推送消息/通知
 --------------------------------------------------------
 //推送消息到客户端
 Response:{
 opercode:"0131",		//operCode为0131，客户端通过该字段确定事件
 statecode:"0200",		//StateCode取值：发送成功[0200],发送失败[其他]
 info:"message",			//客户端可以使用该info进行提示，如:登录成功/账号或密码错误,登录失败!
 senderid:"123456",		//发送者的id
 sendername:"发送人名字",	//发送人名称,如果为系统消息sendername="系统消息"
 senderphoto:"1.jpg",		//发送者的头像
 sendtype:"1",			//0为系统消息,1为好友私聊，2为部落聊天,3为加好友申请，4为处理请求好友申请，5为加入部落申请,6为处理部落加入申请,7为完全退出部落,8为进入部落，9为退出部落房间,10好友上线通知，11好友下线通知,12 @某人, 13.直播间聊
 messtype:"1",			//消息类型 1为文本，2为名片，3为图片，4为录音
 date:"2014-05-17 17:57:11",	//消息时间
 tribeid:"12345",		//部落id(sendtype=2时读取该字段)
 tribename:"部落名称",		//部落名称(sendtype=2时读取该字段)
 tribephoto:"2.jpg",		//部落头像
 messid:"123456",		//消息唯一标识符
 mess:"消息内容",		//消息内容
 sign:"9aldai9adsf"		//sign请求唯一标识
 }
 ---------------------------------------------------------------------------------------------------------------------------------
 API:0132(UDP) 客户端发送收到消息/通知（此时服务器端更新消息状态，将消息设置为已读）
 --------------------------------------------------------
 Request(Client Call):
 {
 opercode:"0132",
 userid:"1234565",		//用户唯一标识
 token:"ab123456789"		//当用户登陆之后，服务器会指定唯一的令牌给相应的客户端，通过此令牌拥有用户权限
 messids:"123456,23456",		//消息唯一标识符,多个消息以逗号隔开
 sign:"9aldai9adsf"		//sign请求唯一标识
 }
 
 Response:{
 opercode:"0132",		//operCode为0131，客户端通过该字段确定事件
 statecode:"0200",		//StateCode取值：发送成功[0200],发送失败[其他]
 info:"操作成功",		//客户端可以使用该info进行提示
 sign:"9aldai9adsf"		//sign请求唯一标识
 }
 
 
 ---------------------------------------------------------------------------------------------------------------------------------
 */

@interface UDPRequest : NSObject<GCDAsyncUdpSocketDelegate>
{
    long tag;
}

@property (nonatomic, copy)FinishLoadBlock block;
@property (atomic,retain)NSMutableArray* saveArray;
@property (nonatomic,retain)NSString* oldSign;

- (void)forceClose;

- (void)send:(NSDictionary *)params;

@end
