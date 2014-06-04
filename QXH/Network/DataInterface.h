//
//  DataInterface.h
//  QXH
//
//  Created by ZhaoLilong on 6/4/14.
//  Copyright (c) 2014 ZhaoLilong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DataInterface : NSObject

/**
 *  用户注册
 *
 *  @param name     用户名
 *  @param pswd     密码
 *  @param callback 回调
 */
+ (void)registerUser:(NSString *)name andPswd:(NSString *)pswd withCompletionHandler:(DictCallback)callback;

/**
 *  用户登陆
 *
 *  @param name     用户名
 *  @param pswd     密码
 *  @param callback 回调
 */
+ (void)login:(NSString *)name andPswd:(NSString *)pswd withCompletinoHandler:(DictCallback)callback;

/**
 *  心跳
 *
 *  @param callback 回调
 */
+ (void)heartBeatWithCompletionHandler:(DictCallback)callback;

/**
 *  用户退出
 *
 *  @param callback 回调
 */
+ (void)logoutWithCompletionHandler:(DictCallback)callback;

/**
 *  获取最新版本号
 *
 *  @param callback 回调
 */
+ (void)getLatestVersionWithCompletionHandler:(DictCallback)callback;

/**
 *  获取用户信息
 *
 *  @param targetid 用户userid
 *  @param callback 回调
 */
+ (void)getUserInfo:(NSString *)targetid withCompletionHandler:(DictCallback)callback;

/**
 *  加好友请求
 *
 *  @param targetid 被处理的加入成员的userid
 *  @param mess     好友请求验证消息
 *  @param callback 回调
 */
+ (void)requestAddFriend:(NSString *)targetid
                    mess:(NSString *)mess
   withCompletionHandler:(DictCallback)callback;

/**
 *  获取好友(通讯录)/查找用户列表公用接口
 *
 *  @param type        1为获取好友列表，2为搜索
 *  @param address     籍贯编码
 *  @param domicile    居住地编码
 *  @param displayname 昵称
 *  @param usertype    用户类型,为空时不区分类型
 *  @param start       起始位置
 *  @param count       获取数量
 *  @param callback    回调
 */
+ (void)getFriendInfo:(NSString *)type
              address:(NSString *)address
             domicile:(NSString *)domicile
          displayname:(NSString *)displayname
             usertype:(NSString *)usertype
                start:(NSString *)start
                count:(NSString *)count
withCompletionHandler:(DictCallback)callback;

/**
 *  加好友确认/修改备注
 *
 *  @param targetid 被处理的加入成员的userid
 *  @param type     0为同意并添加对方为好友(备注不为空添加备注)，1为同意但不添加对方为好友，2为拒绝，3为修改备注
 *  @param remark   备注
 *  @param callback 回调
 */
+ (void)addFriendConfirm:(NSString *)targetid
                    type:(NSString *)type
                  remark:(NSString *)remark
   withCompletionHandler:(DictCallback)callback;

/**
 *  获取码表信息
 *
 *  @param codetype   district为省市区信息,hobby为获取爱好列表，...
 *  @param fathercode 当为获取省列表时fathercode=000000,获取市区时fathercode为父级区域的编码
 *  @param callback   当用户登陆之后，服务器会指定唯一的令牌给相应的客户端，通过此令牌拥有用户权限
 */
+ (void)getCodeSheet:(NSString *)codetype
          fathercode:(NSString *)fathercode
withCompletionHandler:(DictCallback)callback;

/**
 *  获取部落/群组/直播间列表
 *
 *  @param type      1为获取已加入的部落列表，2为搜索相关部落列表(为2时读取下列条件)
 *  @param tribename 部落名称
 *  @param authflag  0为全部，1为普通部落，2为官方认证部落
 *  @param tribetype 1为部落，2为直播间
 *  @param tag       搜索是只允许单个标签搜索
 *  @param district  地域信息
 *  @param start     起始位置
 *  @param count     获取数量
 *  @param callback  回调
 */
+ (void)requestTribeList:(NSString *)type
               tribename:(NSString *)tribename
                authflag:(NSString *)authflag
               tribetype:(NSString *)tribetype
                     tag:(NSString *)tag
                district:(NSString *)district
                   start:(NSString *)start
                   count:(NSString *)count
   withCompletionHandler:(DictCallback)callback;

/**
 *  创建部落
 *
 *  @param tribename  部落名称
 *  @param tribestyle 部落类型
 *  @param userid     秘书长userid
 *  @param signature  部落签名
 *  @param desc       部落描述
 *  @param condition  加入条件
 *  @param purpose    宗旨
 *  @param rule       章程
 *  @param tags       不同标签之间用逗号隔开
 *  @param district   地域信息
 *  @param maxcount   最多人数
 *  @param members    部落成员，成员(userid)之间以逗号隔开
 *  @param callback   回调
 */
+ (void)createTribe:(NSString *)tribename
         tribestyle:(NSString *)tribestyle
          secretary:(NSString *)userid
          signature:(NSString *)signature
               desc:(NSString *)desc
          condition:(NSString *)condition
            purpose:(NSString *)purpose
               rule:(NSString *)rule
               tags:(NSString *)tags
           district:(NSString *)district
           maxcount:(NSString *)maxcount
            members:(NSString *)members
withCompletionHandler:(DictCallback)callback;

/**
 *  修改部落信息
 *
 *  @param tribeid    部落唯一标示
 *  @param tribename  部落名称
 *  @param tribestyle 部落类型
 *  @param userid     秘书长userid
 *  @param signature  部落签名
 *  @param desc       部落描述
 *  @param condition  加入条件
 *  @param purpose    宗旨
 *  @param rule       章程
 *  @param tags       不同标签之间用逗号隔开
 *  @param district   地域信息
 *  @param maxcount   最多人数
 *  @param callback   回调
 */
+ (void)modifyTribeInfo:(NSString *)tribeid
              tribename:(NSString *)tribename
             tribestyle:(NSString *)tribestyle
              secretary:(NSString *)userid
              signature:(NSString *)signature
                   desc:(NSString *)desc
              condition:(NSString *)condition
                purpose:(NSString *)purpose
                   rule:(NSString *)rule
                   tags:(NSString *)tags
               district:(NSString *)district
               maxcount:(NSString *)maxcount
  withCompletionHandler:(DictCallback)callback;

/**
 *  获取部落信息
 *
 *  @param tribeid  部落id
 *  @param callback 回调
 */
+ (void)getTribeInfo:(NSString *)tribeid withCompletionHandler:(DictCallback)callback;


/**
 *  申请加入部落
 *
 *  @param tribeid  部落id
 *  @param callback 回调
 */
+ (void)requestAddTribe:(NSString *)tribeid withCompletionHandler:(DictCallback)callback;

/**
 *  部落创建者/秘书长处理加入部落请求
 *
 *  @param tribeid  部落唯一标示
 *  @param targetid 被处理的加入成员的userid
 *  @param flag     允许标示：1为允许加入，2为拒绝加入
 *  @param callback 回调
 */
+ (void)dealAddTribeRequest:(NSString *)tribeid
                   targetid:(NSString *)targetid
                 permitflag:(NSString *)flag
      withCompletionHandler:(DictCallback)callback;

/**
 *  获取部落成员列表
 *
 *  @param tribeid  部落id
 *  @param callback 回调
 */
+ (void)getTribeMembers:(NSString *)tribeid
  withCompletionHandler:(DictCallback)callback;

/**
 *  退出部落
 *
 *  @param targetid 被处理的退出成员的userid(如果该字段与userid相同为主动退出，不相同，为管理者踢出部落)
 *  @param tribeid  部落唯一标示
 *  @param callback 回调
 */
+ (void)quitTribe:(NSString *)targetid
          tribeid:(NSString *)tribeid
withCompletionHandler:(DictCallback)callback;

/**
 *   发布广场/资讯信息
 *
 *  @param title    文章标题
 *  @param tags     不同标签之间用逗号隔开
 *  @param type     信息类型(1为广场消息，2为咨询)
 *  @param arttype  文章类型
 *  @param content  内容
 *  @param callback 回调
 */
+ (void)distributeInfo:(NSString *)title
                  tags:(NSString *)tags
                  type:(NSString *)type
               arttype:(NSString *)arttype
               content:(NSString *)content
 withCompletionHandler:(DictCallback)callback;

/**
 *  获取广场/咨询消息详细信息
 *
 *  @param type     信息类型(1为广场消息，2为咨询)
 *  @param artid    广场消息的唯一标示
 *  @param callback 回调
 */
+ (void)getDetailInfo:(NSString *)type
                artid:(NSString *)artid
withCompletionHandler:(DictCallback)callback;

/**
 *  聊天通用接口
 *
 *  @param targetid 发送给，好友或部落
 *  @param sendtype 1为好友私聊，2为部落聊天
 *  @param mess     消息内容
 *  @param callback 回调
 */
+ (void)chat:(NSString *)targetid
    sendtype:(NSString *)sendtype
        mess:(NSString *)mess
withCompletionHandler:(DictCallback)callback;

/**
 *  客户端发送收到消息/通知（此时服务器端更新消息状态，将消息设置为已读）
 *
 *  @param messids  消息唯一标识符,多个消息以逗号隔开
 *  @param callback 回调
 */
+ (void)recvMessage:(NSString *)messids withCompletionHandler:(DictCallback)callback;

/**
 *  获取聊天记录信息
 *
 *  @param targetid  发送给，好友或部落
 *  @param sendtype  1为好友私聊，2为部落聊天
 *  @param start     起始消息version号，不填写该字段读取最新消息n个
 *  @param direction 方向 before获取start消息之前的n条,after获取start消息之后的n调
 *  @param count     获取消息数量
 *  @param callback  回调
 */
+ (void)getChatHistory:(NSString *)targetid
              sendtype:(NSString *)sendtype
                 start:(NSString *)start
             direction:(NSString *)direction
                 count:(NSString *)count
 withCompletionHandler:(DictCallback)callback;

/**
 *  进入直播间
 *
 *  @param tribeid  部落id
 *  @param callback 回调
 */
+ (void)gotoOneDream:(NSString *)tribeid withCompletionHandler:(DictCallback)callback;

/**
 *  临时退出部落回话(非退出部落，关系保留)/直播间
 *
 *  @param tribeid  部落id
 *  @param callback 回调
 */
+ (void)leaveOneDream:(NSString *)tribeid withCompletionHandler:(DictCallback)callback;

@end
