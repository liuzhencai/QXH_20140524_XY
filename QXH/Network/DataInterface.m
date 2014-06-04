//
//  DataInterface.m
//  QXH
//
//  Created by ZhaoLilong on 6/4/14.
//  Copyright (c) 2014 ZhaoLilong. All rights reserved.
//

#import "DataInterface.h"

@implementation DataInterface

+ (void)registerUser:(NSString *)name andPswd:(NSString *)pswd withCompletionHandler:(DictCallback)callback
{
    NSDictionary *param = @{@"opercode":@"0135",@"email":name,@"pwd":[pswd md5HexDigest]};
    NSLog(@"\n##########调用用户注册接口##########\n[参 数]:%@\n#############################\n",param);
    [HttpRequest requestWithParams:param andCompletionHandler:^(NSMutableDictionary *dict) {
        NSLog(@"\n##########用户注册返回结果##########\n[结 果]:%@\n#############################\n",dict);
        callback(dict);
    }];
}

+ (void)login:(NSString *)name andPswd:(NSString *)pswd withCompletinoHandler:(DictCallback)callback
{
    NSDictionary *param = @{@"opercode": @"0102", @"username":name, @"pwd":[pswd md5HexDigest],@"sign":[SignGenerator getSign]};
    NSLog(@"\n##########调用用户登陆接口##########\n[参 数]:%@\n#############################\n",param);
    [[UDPServiceEngine sharedEngine] sendData:param withCompletionHandler:^(id data) {
        NSLog(@"\n##########用户登陆返回结果##########\n[结 果]:%@\n#############################\n",data);
        callback(data);
        // 存储token和userid
        [defaults setObject:[data objectForKey:@"userid"] forKey:@"userid"];
        [defaults setObject:[data objectForKey:@"token"] forKey:@"token"];
        [defaults synchronize];
    } andErrorHandler:^(id data) {
        NSLog(@"\n##########用户登陆出错##########\n[原 因]:%@\n#############################\n",data);
    }];
}

+ (void)heartBeatWithCompletionHandler:(DictCallback)callback
{
    NSDictionary *param = @{@"opercode": @"0101",@"userid":[defaults objectForKey:@"userid"],@"token":[defaults objectForKey:@"token"],@"sign":[SignGenerator getSign]};
    NSLog(@"\n##########调用心跳接口##########\n[参 数]:%@\n#############################\n",param);
    [[UDPServiceEngine sharedEngine] sendData:param withCompletionHandler:^(id data) {
        NSLog(@"\n##########心跳返回结果##########\n[结 果]:%@\n#############################\n",data);
        callback(data);
    } andErrorHandler:^(id data) {
        NSLog(@"\n##########心跳出错##########\n[原 因]:%@\n#############################\n",data);
    }];
}

+ (void)logoutWithCompletionHandler:(DictCallback)callback;
{
    NSDictionary *param = @{@"opercode": @"0103", @"userid":[defaults objectForKey:@"userid"], @"token":[defaults objectForKey:@"token"],@"sign":[SignGenerator getSign]};
    NSLog(@"\n##########调用用户退出接口##########\n[参 数]:%@\n#############################\n",param);
    [[UDPServiceEngine sharedEngine] sendData:param withCompletionHandler:^(id data) {
        NSLog(@"\n##########用户退出返回结果##########\n[结 果]:%@\n#############################\n",data);
        callback(data);
    } andErrorHandler:^(id data) {
        NSLog(@"\n##########用户退出出错##########\n[原 因]:%@\n#############################\n",data);
    }];
}

+ (void)getLatestVersionWithCompletionHandler:(DictCallback)callback
{
    NSDictionary *param = @{@"opercode": @"0104", @"platform":@"2", @"version":APP_VER};
    NSLog(@"\n##########获取应用最新版本号接口##########\n[参 数]:%@\n#############################\n",param);
    [HttpRequest requestWithParams:param andCompletionHandler:^(NSMutableDictionary *dict) {
        NSLog(@"\n##########获取应用最新版本号返回结果##########\n[结 果]:%@\n#############################\n",dict);
        callback(dict);
    }];
}

+ (void)getUserInfo:(NSString *)targetid withCompletionHandler:(DictCallback)callback
{
    NSDictionary *param = @{@"opercode": @"0105", @"userid":[defaults objectForKey:@"userid"], @"token":[defaults objectForKey:@"token"],@"targetid":targetid};
    NSLog(@"\n##########获取用户信息接口##########\n[参 数]:%@\n#############################\n",param);
    [HttpRequest requestWithParams:param andCompletionHandler:^(NSMutableDictionary *dict) {
        NSLog(@"\n##########获取用户信息返回结果##########\n[结 果]:%@\n#############################\n",dict);
        callback(dict);
    }];
}

+ (void)getFriendInfo:(NSString *)type
              address:(NSString *)address
             domicile:(NSString *)domicile
          displayname:(NSString *)displayname
             usertype:(NSString *)usertype
                start:(NSString *)start
                count:(NSString *)count
withCompletionHandler:(DictCallback)callback
{
    NSDictionary *param = @{@"opercode": @"0107", @"userid":[defaults objectForKey:@"userid"], @"token":[defaults objectForKey:@"token"],@"type":type,@"address":address, @"domicile":domicile, @"displayname":displayname,@"usertype":usertype,@"start":start,@"count":count};
    NSLog(@"\n##########获取好友(通讯录)/查找用户列表公用接口##########\n[参 数]:%@\n#############################\n",param);
    [HttpRequest requestWithParams:param andCompletionHandler:^(NSMutableDictionary *dict) {
        NSLog(@"\n##########获取好友(通讯录)/查找用户列表公用接口返回结果##########\n[结 果]:%@\n#############################\n",dict);
        callback(dict);
    }];
}

+ (void)requestAddFriend:(NSString *)targetid
                    mess:(NSString *)mess
   withCompletionHandler:(DictCallback)callback
{
    NSDictionary *param = @{@"opercode": @"0108", @"userid":[defaults objectForKey:@"userid"], @"token":[defaults objectForKey:@"token"],@"targetid":targetid,@"mess":mess};
    NSLog(@"\n##########加好友请求接口##########\n[参 数]:%@\n#############################\n",param);
    [HttpRequest requestWithParams:param andCompletionHandler:^(NSMutableDictionary *dict) {
        NSLog(@"\n##########获加好友请求返回结果##########\n[结 果]:%@\n#############################\n",dict);
        callback(dict);
    }];
}

+ (void)addFriendConfirm:(NSString *)targetid
                    type:(NSString *)type
                  remark:(NSString *)remark
   withCompletionHandler:(DictCallback)callback
{
    NSDictionary *param = @{@"opercode": @"0109", @"userid":[defaults objectForKey:@"userid"], @"token":[defaults objectForKey:@"token"],@"targetid":targetid,@"type":type,@"remark":remark};
    NSLog(@"\n##########加好友确认/修改备注接口##########\n[参 数]:%@\n#############################\n",param);
    [HttpRequest requestWithParams:param andCompletionHandler:^(NSMutableDictionary *dict) {
        NSLog(@"\n##########加好友确认/修改备注返回结果##########\n[结 果]:%@\n#############################\n",dict);
        callback(dict);
    }];
}

+ (void)getCodeSheet:(NSString *)codetype
         fathercode:(NSString *)fathercode
withCompletionHandler:(DictCallback)callback
{
    NSDictionary *param = @{@"opercode": @"0110", @"userid":[defaults objectForKey:@"userid"], @"token":[defaults objectForKey:@"token"],@"codetype":codetype,@"fathercode":fathercode};
    NSLog(@"\n##########获取码表信息接口##########\n[参 数]:%@\n#############################\n",param);
    [HttpRequest requestWithParams:param andCompletionHandler:^(NSMutableDictionary *dict) {
        NSLog(@"\n##########获取码表信息返回结果##########\n[结 果]:%@\n#############################\n",dict);
        callback(dict);
    }];
}

+ (void)requestTribeList:(NSString *)type
               tribename:(NSString *)tribename
                authflag:(NSString *)authflag
               tribetype:(NSString *)tribetype
                     tag:(NSString *)tag
                district:(NSString *)district
                   start:(NSString *)start
                   count:(NSString *)count
   withCompletionHandler:(DictCallback)callback
{
    NSDictionary *param = @{@"opercode": @"0111", @"userid":[defaults objectForKey:@"userid"], @"token":[defaults objectForKey:@"token"],@"type":type,@"tribename":tribename,@"authflag":authflag,@"tribetype":tribetype,@"tag":tag,@"district":district,@"start":start,@"count":count};
    NSLog(@"\n##########获取码表信息接口##########\n[参 数]:%@\n#############################\n",param);
    [HttpRequest requestWithParams:param andCompletionHandler:^(NSMutableDictionary *dict) {
        NSLog(@"\n##########获取码表信息返回结果##########\n[结 果]:%@\n#############################\n",dict);
        callback(dict);
    }];
}

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
withCompletionHandler:(DictCallback)callback
{
    NSDictionary *param = @{@"opercode": @"0112", @"userid":[defaults objectForKey:@"userid"], @"token":[defaults objectForKey:@"token"],@"tribename":tribename,@"tribestyle":tribestyle,@"secretary":userid,@"signature":signature,@"desc":desc,@"condition":condition,@"purpose":purpose,@"rule":rule,@"tags":tags,@"district":district,@"maxcount":maxcount,@"members":members};
    NSLog(@"\n##########创建部落接口##########\n[参 数]:%@\n#############################\n",param);
    [HttpRequest requestWithParams:param andCompletionHandler:^(NSMutableDictionary *dict) {
        NSLog(@"\n##########获创建部落返回结果##########\n[结 果]:%@\n#############################\n",dict);
        callback(dict);
    }];
}

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
  withCompletionHandler:(DictCallback)callback
{
    NSDictionary *param = @{@"opercode": @"0113", @"userid":[defaults objectForKey:@"userid"], @"token":[defaults objectForKey:@"token"],@"tribeid":tribeid, @"tribename":tribename,@"tribestyle":tribestyle,@"secretary":userid,@"signature":signature,@"desc":desc,@"condition":condition,@"purpose":purpose,@"rule":rule,@"tags":tags,@"district":district,@"maxcount":maxcount};
    NSLog(@"\n##########修改部落信息接口##########\n[参 数]:%@\n#############################\n",param);
    [HttpRequest requestWithParams:param andCompletionHandler:^(NSMutableDictionary *dict) {
        NSLog(@"\n##########修改部落信息返回结果##########\n[结 果]:%@\n#############################\n",dict);
        callback(dict);
    }];
}

+ (void)getTribeInfo:(NSString *)tribeid withCompletionHandler:(DictCallback)callback
{
    NSDictionary *param = @{@"opercode": @"0114", @"userid":[defaults objectForKey:@"userid"], @"token":[defaults objectForKey:@"token"],@"tribeid":tribeid};
    NSLog(@"\n##########获取部落信息接口##########\n[参 数]:%@\n#############################\n",param);
    [HttpRequest requestWithParams:param andCompletionHandler:^(NSMutableDictionary *dict) {
        NSLog(@"\n##########获取部落信息返回结果##########\n[结 果]:%@\n#############################\n",dict);
        callback(dict);
    }];
}

+ (void)requestAddTribe:(NSString *)tribeid withCompletionHandler:(DictCallback)callback
{
    NSDictionary *param = @{@"opercode": @"0115", @"userid":[defaults objectForKey:@"userid"], @"token":[defaults objectForKey:@"token"],@"tribeid":tribeid};
    NSLog(@"\n##########申请加入部落接口##########\n[参 数]:%@\n#############################\n",param);
    [HttpRequest requestWithParams:param andCompletionHandler:^(NSMutableDictionary *dict) {
        NSLog(@"\n##########申请加入部落返回结果##########\n[结 果]:%@\n#############################\n",dict);
        callback(dict);
    }];
}

+ (void)dealAddTribeRequest:(NSString *)tribeid
                   targetid:(NSString *)targetid
                 permitflag:(NSString *)permitflag
      withCompletionHandler:(DictCallback)callback
{
    NSDictionary *param = @{@"opercode": @"0116", @"userid":[defaults objectForKey:@"userid"], @"token":[defaults objectForKey:@"token"],@"tribeid":tribeid,@"targetid":targetid,@"permitflag":permitflag};
    NSLog(@"\n##########部落创建者/秘书长处理加入部落请求接口##########\n[参 数]:%@\n#############################\n",param);
    [HttpRequest requestWithParams:param andCompletionHandler:^(NSMutableDictionary *dict) {
        NSLog(@"\n##########部落创建者/秘书长处理加入部落请求返回结果##########\n[结 果]:%@\n#############################\n",dict);
        callback(dict);
    }];
}

+ (void)getTribeMembers:(NSString *)tribeid withCompletionHandler:(DictCallback)callback
{
    NSDictionary *param = @{@"opercode": @"0117", @"userid":[defaults objectForKey:@"userid"], @"token":[defaults objectForKey:@"token"],@"tribeid":tribeid};
    NSLog(@"\n##########获取部落成员列表接口##########\n[参 数]:%@\n#############################\n",param);
    [HttpRequest requestWithParams:param andCompletionHandler:^(NSMutableDictionary *dict) {
        NSLog(@"\n##########获取部落成员列表返回结果##########\n[结 果]:%@\n#############################\n",dict);
        callback(dict);
    }];
}

+ (void)quitTribe:(NSString *)targetid
          tribeid:(NSString *)tribeid
withCompletionHandler:(DictCallback)callback
{
    NSDictionary *param = @{@"opercode": @"0118", @"userid":[defaults objectForKey:@"userid"], @"token":[defaults objectForKey:@"token"],@"targetid":targetid,@"tribeid":tribeid};
    NSLog(@"\n##########退出部落接口##########\n[参 数]:%@\n#############################\n",param);
    [HttpRequest requestWithParams:param andCompletionHandler:^(NSMutableDictionary *dict) {
        NSLog(@"\n##########退出部落返回结果##########\n[结 果]:%@\n#############################\n",dict);
        callback(dict);
    }];
}

+ (void)distributeInfo:(NSString *)title
                  tags:(NSString *)tags
                  type:(NSString *)type
               arttype:(NSString *)arttype
               content:(NSString *)content
 withCompletionHandler:(DictCallback)callback
{
    NSDictionary *param = @{@"opercode": @"0120", @"userid":[defaults objectForKey:@"userid"], @"token":[defaults objectForKey:@"token"],@"title":title,@"tags":tags, @"arttype":arttype, @"content":content};
    NSLog(@"\n##########发布广场/资讯信息接口##########\n[参 数]:%@\n#############################\n",param);
    [HttpRequest requestWithParams:param andCompletionHandler:^(NSMutableDictionary *dict) {
        NSLog(@"\n##########发布广场/资讯信息返回结果##########\n[结 果]:%@\n#############################\n",dict);
        callback(dict);
    }];
}

+ (void)getDetailInfo:(NSString *)type
                artid:(NSString *)artid
withCompletionHandler:(DictCallback)callback
{
    NSDictionary *param = @{@"opercode": @"0121", @"userid":[defaults objectForKey:@"userid"], @"token":[defaults objectForKey:@"token"],@"type":type,@"artid":artid};
    NSLog(@"\n##########获取广场/咨询消息详细信息接口##########\n[参 数]:%@\n#############################\n",param);
    [HttpRequest requestWithParams:param andCompletionHandler:^(NSMutableDictionary *dict) {
        NSLog(@"\n##########获取广场/咨询消息详细信息返回结果##########\n[结 果]:%@\n#############################\n",dict);
        callback(dict);
    }];
}

+ (void)chat:(NSString *)targetid
    sendtype:(NSString *)sendtype
        mess:(NSString *)mess
withCompletionHandler:(DictCallback)callback
{
    NSDictionary *param = @{@"opercode": @"0130", @"userid":[defaults objectForKey:@"userid"], @"token":[defaults objectForKey:@"token"],@"targetid":targetid,@"sendtype":sendtype,@"mess":mess,@"sign":[SignGenerator getSign]};
    NSLog(@"\n##########通用聊天接口##########\n[参 数]:%@\n#############################\n",param);
    [[UDPServiceEngine sharedEngine] sendData:param withCompletionHandler:^(id data) {
        NSLog(@"\n##########通用聊天返回结果##########\n[结 果]:%@\n#############################\n",data);
        callback(data);
    } andErrorHandler:^(id data) {
        NSLog(@"\n##########通用聊天出错##########\n[原 因]:%@\n#############################\n",data);
    }];
}

+ (void)recvMessage:(NSString *)messids withCompletionHandler:(DictCallback)callback
{
    NSDictionary *param = @{@"opercode": @"0132", @"userid":[defaults objectForKey:@"userid"], @"token":[defaults objectForKey:@"token"],@"messids":messids,@"sign":[SignGenerator getSign]};
    NSLog(@"\n##########客户端发送收到消息接口##########\n[参 数]:%@\n#############################\n",param);
    [[UDPServiceEngine sharedEngine] sendData:param withCompletionHandler:^(id data) {
        NSLog(@"\n##########客户端发送收到消息返回结果##########\n[结 果]:%@\n#############################\n",data);
        callback(data);
    } andErrorHandler:^(id data) {
        NSLog(@"\n##########客户端发送收到消息出错##########\n[原 因]:%@\n#############################\n",data);
    }];
}

+ (void)getChatHistory:(NSString *)targetid
              sendtype:(NSString *)sendtype
                 start:(NSString *)start
             direction:(NSString *)direction
                 count:(NSString *)count
 withCompletionHandler:(DictCallback)callback
{
    NSDictionary *param = @{@"opercode": @"0133", @"userid":[defaults objectForKey:@"userid"], @"token":[defaults objectForKey:@"token"],@"targetid":targetid,@"sendtype":sendtype,@"start":start,@"direction":direction,@"count":count,@"sign":[SignGenerator getSign]};
    NSLog(@"\n##########获取聊天记录信息接口##########\n[参 数]:%@\n#############################\n",param);
    [[UDPServiceEngine sharedEngine] sendData:param withCompletionHandler:^(id data) {
        NSLog(@"\n##########获取聊天记录信息返回结果##########\n[结 果]:%@\n#############################\n",data);
        callback(data);
    } andErrorHandler:^(id data) {
        NSLog(@"\n##########获取聊天记录信息出错##########\n[原 因]:%@\n#############################\n",data);
    }];
}

+ (void)gotoOneDream:(NSString *)tribeid withCompletionHandler:(DictCallback)callback
{
    NSDictionary *param = @{@"opercode": @"0136", @"userid":[defaults objectForKey:@"userid"], @"token":[defaults objectForKey:@"token"],@"tribeid":tribeid};
    NSLog(@"\n##########进入部落/直播间接口##########\n[参 数]:%@\n#############################\n",param);
    [[UDPServiceEngine sharedEngine] sendData:param withCompletionHandler:^(id data) {
        NSLog(@"\n##########进入部落/直播间返回结果##########\n[结 果]:%@\n#############################\n",data);
        callback(data);
    } andErrorHandler:^(id data) {
        NSLog(@"\n##########进入部落/直播间出错##########\n[原 因]:%@\n#############################\n",data);
    }];
}

+ (void)leaveOneDream:(NSString *)tribeid withCompletionHandler:(DictCallback)callback
{
    NSDictionary *param = @{@"opercode": @"0137", @"userid":[defaults objectForKey:@"userid"], @"token":[defaults objectForKey:@"token"],@"tribeid":tribeid};
    NSLog(@"\n##########临时退出部落回话(非退出部落，关系保留)/直播间接口##########\n[参 数]:%@\n#############################\n",param);
    [[UDPServiceEngine sharedEngine] sendData:param withCompletionHandler:^(id data) {
        NSLog(@"\n##########临时退出部落回话(非退出部落，关系保留)/直播间返回结果##########\n[结 果]:%@\n#############################\n",data);
        callback(data);
    } andErrorHandler:^(id data) {
        NSLog(@"\n##########临时退出部落回话(非退出部落，关系保留)/直播间出错##########\n[原 因]:%@\n#############################\n",data);
    }];
}

@end