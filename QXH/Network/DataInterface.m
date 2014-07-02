//
//  DataInterface.m
//  QXH
//
//  Created by ZhaoLilong on 6/4/14.
//  Copyright (c) 2014 ZhaoLilong. All rights reserved.
//

#import "DataInterface.h"
#import "JSONKit.h"

@implementation DataInterface

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

+ (void)modifyUserInfo:(NSString *)displayname
                oldpwd:(NSString *)oldpwd
                newpwd:(NSString *)newpwd
             signature:(NSString *)signature
                 title:(NSString *)title
                degree:(NSString *)degree
               address:(NSString *)address
              domicile:(NSString *)domicile
             introduce:(NSString *)introduce
               comname:(NSString *)comname
               comdesc:(NSString *)comdesc
            comaddress:(NSString *)comaddress
                comurl:(NSString *)comurl
              induname:(NSString *)induname
              indudesc:(NSString *)indudesc
            schoolname:(NSString *)schoolname
            schooltype:(NSString *)schooltype
                   sex:(NSString *)sex
                 photo:(NSString *)photo
                 email:(NSString *)email
                  tags:(NSString *)tags
         attentiontags:(NSString *)attentiontags
               hobbies:(NSString *)hobbies
            educations:(NSString *)educations
               honours:(NSString *)honours
              usertype:(NSString *)usertype
                  gold:(NSString *)gold
                 level:(NSString *)level
             configure:(NSString *)configure
 withCompletionHandler:(DictCallback)callback
{
    NSDictionary *param = @{@"opercode": @"0106", @"userid":[defaults objectForKey:@"userid"], @"token":[defaults objectForKey:@"token"],@"displayname":displayname,@"oldpwd":oldpwd,@"newpwd":newpwd,@"signature":signature,@"title":title,@"degree":degree,@"address":address,@"domicile":domicile,@"introduce":introduce,@"comname":comname,@"comdesc":comdesc,@"comaddress":comaddress,@"comurl":comurl,@"induname":induname,@"indudesc":indudesc,@"schoolname":schoolname,@"schooltype":schooltype,@"photo":photo,@"sex":sex,@"email":ORIGIN_VAL,@"tags":tags,@"attentiontags":attentiontags,@"hobbies":hobbies,@"educations":educations,@"honours":honours,@"usertype":usertype,@"gold":gold,@"level":level,@"level":level,@"configure":configure};
    NSLog(@"\n##########修改用户信息接口##########\n[参 数]:%@\n#############################\n",param);
    [HttpRequest requestWithParams:param andCompletionHandler:^(NSMutableDictionary *dict) {
        NSLog(@"\n##########修改用户信息返回结果##########\n[结 果]:%@\n#############################\n",dict);
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
                  status:(NSString *)status
               tribetype:(NSString *)tribetype
                     tag:(NSString *)tag
                district:(NSString *)district
                   start:(NSString *)start
                   count:(NSString *)count
   withCompletionHandler:(DictCallback)callback
{
    NSDictionary *param = @{@"opercode": @"0111", @"userid":[defaults objectForKey:@"userid"], @"token":[defaults objectForKey:@"token"],@"type":type,@"tribename":tribename,@"authflag":authflag,@"status":status,@"tribetype":tribetype,@"tag":tag,@"district":district,@"start":start,@"count":count};
    NSLog(@"\n##########获取码表信息获取部落/群组/直播间列表接口##########\n[参 数]:%@\n#############################\n",param);
    [HttpRequest requestWithParams:param andCompletionHandler:^(NSMutableDictionary *dict) {
        NSLog(@"\n##########获取部落/群组/直播间列表返回结果##########\n[结 果]:%@\n#############################\n",dict);
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
              photo:(NSString *)photo
           maxcount:(NSString *)maxcount
            members:(NSString *)members
withCompletionHandler:(DictCallback)callback{
    NSDictionary *param = @{@"opercode": @"0112", @"userid":[defaults objectForKey:@"userid"], @"token":[defaults objectForKey:@"token"],@"tribename":tribename,@"tribestyle":tribestyle,@"secretary":userid,@"signature":signature,@"desc":desc,@"condition":condition,@"purpose":purpose,@"rule":rule,@"tags":tags,@"district":district,@"photo":photo,@"maxcount":maxcount,@"members":members};
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

+ (void)getInfoList:(NSString *)type
         detailtype:(NSString *)detailtype
                tag:(NSString *)tag
            arttype:(NSString *)arttype
      contentlength:(NSString *)contentlength
              start:(NSString *)start
              count:(NSString *)count
withCompletionHandler:(DictCallback)callback
{
    NSDictionary *param = @{@"opercode": @"0119", @"userid":[defaults objectForKey:@"userid"], @"token":[defaults objectForKey:@"token"],@"type":type,@"detailtype":detailtype,@"tag":tag,@"arttype":arttype,@"contentlength":contentlength,@"start":start,@"count":count};
    NSLog(@"\n##########获取查询广场文章/咨询文章列表,获取收藏列表接口##########\n[参 数]:%@\n#############################\n",param);
    [HttpRequest requestWithParams:param andCompletionHandler:^(NSMutableDictionary *dict) {
        NSLog(@"\n##########获取查询广场文章/咨询文章列表,获取收藏列表返回结果##########\n[结 果]:%@\n#############################\n",dict);
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

+ (void)praiseArticle:(NSString *)artid
                 laud:(NSString *)laud
              comment:(NSString *)comment
withCompletionHandler:(DictCallback)callback
{
    NSDictionary *param = @{@"opercode": @"0122", @"userid":[defaults objectForKey:@"userid"], @"token":[defaults objectForKey:@"token"],@"artid":artid,@"laud":laud,@"comment":comment};
    NSLog(@"\n##########文章赞/评论接口##########\n[参 数]:%@\n#############################\n",param);
    [HttpRequest requestWithParams:param andCompletionHandler:^(NSMutableDictionary *dict) {
        NSLog(@"\n##########文章赞/评论返回结果##########\n[结 果]:%@\n#############################\n",dict);
        callback(dict);
    }];
}

+ (void)getCommentList:(NSString *)artid
                 start:(NSString *)start
                 count:(NSString *)count
 withCompletionHandler:(DictCallback)callback
{
    NSDictionary *param = @{@"opercode": @"0123", @"userid":[defaults objectForKey:@"userid"], @"token":[defaults objectForKey:@"token"],@"artid":artid,@"start":start,@"count":count};
    NSLog(@"\n##########获取评论列表接口##########\n[参 数]:%@\n#############################\n",param);
    [HttpRequest requestWithParams:param andCompletionHandler:^(NSMutableDictionary *dict) {
        NSLog(@"\n##########获取评论列表返回结果##########\n[结 果]:%@\n#############################\n",dict);
        callback(dict);
    }];
}

+ (void)squareArticleCollection:(NSString *)type
                          artid:(NSString *)artid
          withCompletionHandler:(DictCallback)callback
{
    NSDictionary *param = @{@"opercode": @"0124", @"userid":[defaults objectForKey:@"userid"], @"token":[defaults objectForKey:@"token"],@"type":type,@"artid":artid};
    NSLog(@"\n##########广场文章收藏接口##########\n[参 数]:%@\n#############################\n",param);
    [HttpRequest requestWithParams:param andCompletionHandler:^(NSMutableDictionary *dict) {
        NSLog(@"\n##########广场文章收藏返回结果##########\n[结 果]:%@\n#############################\n",dict);
        callback(dict);
    }];
}

+ (void)getActList:(NSString *)start
             count:(NSString *)count
           actname:(NSString *)actname
     contentlength:(NSString *)contentlength
               tag:(NSString *)tag
          district:(NSString *)district
           canjoin:(NSString *)canjoin
          actstate:(NSString *)actstate
           tribeid:(NSString *)tribeid
         begindate:(NSString *)begindate
           enddate:(NSString *)enddate
withCompletionHandler:(DictCallback)callback
{
    NSDictionary *param = @{@"opercode": @"0125", @"userid":[defaults objectForKey:@"userid"], @"token":[defaults objectForKey:@"token"],@"start":start,@"count":count,@"actname":actname,@"contentlength":contentlength,@"tag":tag,@"district":district,@"canjoin":canjoin,@"actstate":actstate,@"tribeid":tribeid,@"begindate":begindate,@"enddate":enddate};
    NSLog(@"\n##########获取/搜索活动列表接口##########\n[参 数]:%@\n#############################\n",param);
    [HttpRequest requestWithParams:param andCompletionHandler:^(NSMutableDictionary *dict) {
        NSLog(@"\n##########获取/搜索活动列表返回结果##########\n[结 果]:%@\n#############################\n",dict);
        callback(dict);
    }];
}

+ (void)createAct:(NSString *)actname
          acttype:(NSString *)acttype
             desc:(NSString *)desc
          actimgs:(NSString *)actimgs
        condition:(NSString *)condition
         comefrom:(NSString *)comefrom
             tags:(NSString *)tags
         district:(NSString *)district
          actaddr:(NSString *)actaddr
     startoffaddr:(NSString *)startoffaddr
         maxcount:(NSString *)maxcount
  signupbegindate:(NSString *)signupbegindate
    signupenddate:(NSString *)signupenddate
        begindate:(NSString *)begindate
          enddate:(NSString *)enddate
withCompletionHandler:(DictCallback)callback
{
    NSDictionary *param = @{@"opercode": @"0126", @"userid":[defaults objectForKey:@"userid"], @"token":[defaults objectForKey:@"token"],@"actname":actname,@"acttype":acttype,@"desc":desc,@"actimgs":actimgs,@"condition":condition,@"comefrom":comefrom,@"tags":tags,@"district":district,@"actaddr":actaddr,@"startoffaddr":startoffaddr,@"maxcount":maxcount,@"signupbegindate":signupbegindate,@"signupenddate":signupenddate,@"begindate":begindate,@"enddate":enddate};
    NSLog(@"\n##########创建活动接口##########\n[参 数]:%@\n#############################\n",param);
    [HttpRequest requestWithParams:param andCompletionHandler:^(NSMutableDictionary *dict) {
        NSLog(@"\n##########创建活动返回结果##########\n[结 果]:%@\n#############################\n",dict);
        callback(dict);
    }];
}

+ (void)getActDetailInfo:(NSString *)actid withCompletionHandler:(DictCallback)callback
{
    NSDictionary *param = @{@"opercode": @"0127", @"userid":[defaults objectForKey:@"userid"], @"token":[defaults objectForKey:@"token"],@"actid":actid};
    NSLog(@"\n##########获取活动详细信息接口##########\n[参 数]:%@\n#############################\n",param);
    [HttpRequest requestWithParams:param andCompletionHandler:^(NSMutableDictionary *dict) {
        NSLog(@"\n##########获取活动详细信息返回结果##########\n[结 果]:%@\n#############################\n",dict);
        callback(dict);
    }];
}

+ (void)joinAct:(NSString *)type
          actid:(NSString *)actid
withCompletionHandler:(DictCallback)callback
{
    NSDictionary *param = @{@"opercode": @"0128", @"userid":[defaults objectForKey:@"userid"], @"token":[defaults objectForKey:@"token"],@"type":type,@"actid":actid};
    NSLog(@"\n##########加入/关注活动接口##########\n[参 数]:%@\n#############################\n",param);
    [HttpRequest requestWithParams:param andCompletionHandler:^(NSMutableDictionary *dict) {
        NSLog(@"\n##########加入/关注活动返回结果##########\n[结 果]:%@\n#############################\n",dict);
        callback(dict);
    }];
}

+ (void)quitAct:(NSString *)actid withCompletionHandler:(DictCallback)callback
{
    NSDictionary *param = @{@"opercode": @"0129", @"userid":[defaults objectForKey:@"userid"], @"token":[defaults objectForKey:@"token"],@"actid":actid};
    NSLog(@"\n##########退出活动/取消关注接口##########\n[参 数]:%@\n#############################\n",param);
    [HttpRequest requestWithParams:param andCompletionHandler:^(NSMutableDictionary *dict) {
        NSLog(@"\n##########退出活动/取消关注返回结果##########\n[结 果]:%@\n#############################\n",dict);
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
    NSDictionary *param = @{@"opercode": @"0133", @"userid":[defaults objectForKey:@"userid"], @"token":[defaults objectForKey:@"token"],@"targetid":targetid,@"sendtype":sendtype,@"start":start,@"direction":direction,@"count":count};
    NSLog(@"\n##########获取聊天记录信息接口##########\n[参 数]:%@\n#############################\n",param);
    [HttpRequest requestWithParams:param andCompletionHandler:^(NSMutableDictionary *dict) {
        NSLog(@"\n##########获取聊天记录信息返回结果##########\n[结 果]:%@\n#############################\n",dict);
        callback(dict);
    }];
}

+ (void)shareContent:(NSString *)artid
         contenttype:(NSString *)contenttype
           sharetype:(NSString *)sharetype
            targetid:(NSString *)targetid
withCompletionHandler:(DictCallback)callback
{
//    NSDictionary *param = @{@"opercode": @"0134", @"userid":[defaults objectForKey:@"userid"], @"token":[defaults objectForKey:@"token"],@"artid":artid,@"contenttype":contenttype,@"sharetype":sharetype,@"targetid":targetid};
    NSDictionary *param = @{@"opercode": @"0134", @"userid":[defaults objectForKey:@"userid"], @"token":[defaults objectForKey:@"token"],@"sourceid":artid,@"sourcetype":contenttype,@"sharetype":sharetype,@"targetid":targetid};
    NSLog(@"\n##########分享内容接口##########\n[参 数]:%@\n#############################\n",param);
    [HttpRequest requestWithParams:param andCompletionHandler:^(NSMutableDictionary *dict) {
        NSLog(@"\n##########分享内容返回结果##########\n[结 果]:%@\n#############################\n",dict);
        callback(dict);
    }];
}

+ (void)registerUser:(NSString *)name andPswd:(NSString *)pswd withCompletionHandler:(DictCallback)callback
{
    NSDictionary *param = @{@"opercode":@"0135",@"email":name,@"pwd":[pswd md5HexDigest]};
    NSLog(@"\n##########调用用户注册接口##########\n[参 数]:%@\n#############################\n",param);
    [HttpRequest requestWithParams:param andCompletionHandler:^(NSMutableDictionary *dict) {
        NSLog(@"\n##########用户注册返回结果##########\n[结 果]:%@\n#############################\n",dict);
        callback(dict);
    }];
}

+ (void)gotoOneDream:(NSString *)tribeid withCompletionHandler:(DictCallback)callback
{
    NSDictionary *param = @{@"opercode": @"0136", @"userid":[defaults objectForKey:@"userid"], @"token":[defaults objectForKey:@"token"],@"tribeid":tribeid};
    NSLog(@"\n##########进入部落/直播间接口##########\n[参 数]:%@\n#############################\n",param);
    [HttpRequest requestWithParams:param andCompletionHandler:^(NSMutableDictionary *dict) {
        NSLog(@"\n##########进入部落/直播间返回结果##########\n[结 果]:%@\n#############################\n",dict);
        callback(dict);
    }];
    
//    [[UDPServiceEngine sharedEngine] sendData:param withCompletionHandler:^(id data) {
//        NSLog(@"\n##########进入部落/直播间返回结果##########\n[结 果]:%@\n#############################\n",data);
//        callback(data);
//    } andErrorHandler:^(id data) {
//        NSLog(@"\n##########进入部落/直播间出错##########\n[原 因]:%@\n#############################\n",data);
//    }];
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

+ (void)modifyAct:(NSString *)actid
          actname:(NSString *)actname
          acttype:(NSString *)acttype
             desc:(NSString *)desc
        condition:(NSString *)condition
         comefrom:(NSString *)comefrom
             tags:(NSString *)tags
         district:(NSString *)district
          actaddr:(NSString *)actaddr
     startoffaddr:(NSString *)startoffaddr
         maxcount:(NSString *)maxcount
       delactimgs:(NSString *)delactimgs
          actimgs:(NSString *)actimgs
  signupbegindate:(NSString *)signupbegindate
    signupenddate:(NSString *)signupenddate
        begindate:(NSString *)begindate
          enddate:(NSString *)enddate
withCompletionHandler:(DictCallback)callback
{
    NSDictionary *param = @{@"opercode": @"0138", @"userid":[defaults objectForKey:@"userid"], @"token":[defaults objectForKey:@"token"],@"actid":actid,@"actname":actname,@"acttype":acttype,@"desc":desc,@"condition":condition,@"comefrom":comefrom,@"tags":tags,@"district":district,@"actaddr":actaddr,@"startoffaddr":startoffaddr,@"maxcount":maxcount,@"delactimgs":delactimgs,@"actimgs":actimgs,@"signupbegindate":signupbegindate,@"signupenddate":signupenddate,@"begindate":begindate,@"enddate":enddate};
    NSLog(@"\n##########修改活动接口##########\n[参 数]:%@\n#############################\n",param);
    [HttpRequest requestWithParams:param andCompletionHandler:^(NSMutableDictionary *dict) {
        NSLog(@"\n##########修改活动返回结果##########\n[结 果]:%@\n#############################\n",dict);
        callback(dict);
    }];
}

+ (void)getVisitorList:(NSString *)targetid withCompletionHandler:(DictCallback)callback
{
    NSDictionary *param = @{@"opercode": @"0139", @"userid":[defaults objectForKey:@"userid"], @"token":[defaults objectForKey:@"token"],@"targetid":targetid};
    NSLog(@"\n##########获取访客接口##########\n[参 数]:%@\n#############################\n",param);
    [HttpRequest requestWithParams:param andCompletionHandler:^(NSMutableDictionary *dict) {
        NSLog(@"\n##########获取访客返回结果##########\n[结 果]:%@\n#############################\n",dict);
        callback(dict);
    }];
}

+ (void)getLoginInfoWithCompletionHandler:(DictCallback)callback
{
    NSDictionary *param = @{@"opercode": @"0140", @"userid":[defaults objectForKey:@"userid"], @"token":[defaults objectForKey:@"token"]};
    NSLog(@"\n##########获取登陆消息接口##########\n[参 数]:%@\n#############################\n",param);
    [HttpRequest requestWithParams:param andCompletionHandler:^(NSMutableDictionary *dict) {
        NSLog(@"\n##########获取登陆消息返回结果##########\n[结 果]:%@\n#############################\n",dict);
        callback(dict);
    }];
}

+ (void)fileUpload:(id)file type:(NSString *)type withCompletionHandler:(DictCallback)completionBlock errorBlock:(DescriptionBlock)errorBlock
{
    [HttpRequest uploadFile:file type:type completionHandler:^(id data) {
        NSLog(@"\n##########上传文件成功##########\n[结 果]:%@\n#############################\n",data);
        completionBlock(data);
    } errorHandler:^(NSString *desc) {
        NSLog(@"\n##########上传文件失败##########\n[原 因]:%@\n#############################\n",desc);
        errorBlock(desc);
    }];
}

+ (void)getSquareInfoList:(NSString *)type
               detailtype:(NSString *)detailtype
                      tag:(NSString *)tag
                  arttype:(NSString *)arttype
            contentlength:(NSString *)contentlength
                    start:(NSString *)start
                    count:(NSString *)count
    withCompletionHandler:(DictCallback)callback
{
    NSDictionary *param = @{@"opercode": @"0142", @"userid":[defaults objectForKey:@"userid"], @"token":[defaults objectForKey:@"token"],@"type":type,@"detailtype":detailtype,@"tag":tag,@"arttype":arttype,@"contentlength":contentlength,@"start":start,@"count":count};
    NSLog(@"\n##########获取广场消息列表接口##########\n[参 数]:%@\n#############################\n",param);
    [HttpRequest requestWithParams:param andCompletionHandler:^(NSMutableDictionary *dict) {
        NSMutableDictionary *infoDict = [[NSMutableDictionary alloc] initWithDictionary:dict];
        NSArray *list = [dict objectForKey:@"list"];
        NSMutableArray *resultList = [[NSMutableArray alloc] init];
        for (NSDictionary *tmpDict in list) {
            NSString *subJson = [tmpDict objectForKey:@"content"];
            NSMutableDictionary *resultDict = [NSMutableDictionary dictionaryWithDictionary:tmpDict];
            JSONDecoder *jd = [[JSONDecoder alloc] initWithParseOptions:JKParseOptionPermitTextAfterValidJSON];
            NSError *error = nil;
            NSDictionary *subDict = [jd objectWithData:[subJson dataUsingEncoding:NSUTF8StringEncoding] error:&error];
            [resultDict setValue:subDict forKey:@"content"];
            [resultList addObject:resultDict];
        }
        [infoDict setObject:resultList forKey:@"list"];
        NSLog(@"\n##########获取广场消息列表返回结果##########\n[结 果]:%@\n#############################\n",infoDict);
        callback(infoDict);
    }];
}

+ (void)transmit:(NSString *)type
        targetid:(NSString *)targetid
         refsign:(NSString *)refsign
withCompletionHandler:(DictCallback)callback
{
    NSDictionary *param = @{@"opercode": @"0143", @"userid":[defaults objectForKey:@"userid"], @"token":[defaults objectForKey:@"token"],@"type":type,@"targetid":targetid,@"refsign":refsign};
    NSLog(@"\n##########转发通用接口接口##########\n[参 数]:%@\n#############################\n",param);
    [HttpRequest requestWithParams:param andCompletionHandler:^(NSMutableDictionary *dict) {
        NSLog(@"\n##########转发通用接口返回结果##########\n[结 果]:%@\n#############################\n",dict);
        callback(dict);
    }];
}

+ (void)getEveryDayAsk:(NSString *)type
               tribeid:(NSString *)tribeid
 withCompletionHandler:(DictCallback)callback
{
    NSDictionary *param = @{@"opercode": @"0144", @"userid":[defaults objectForKey:@"userid"], @"token":[defaults objectForKey:@"token"],@"type":type,@"tribeid":tribeid};
    NSLog(@"\n##########获取每日一问通用接口##########\n[参 数]:%@\n#############################\n",param);
    [HttpRequest requestWithParams:param andCompletionHandler:^(NSMutableDictionary *dict) {
        NSLog(@"\n##########获取每日一问通用接口返回结果##########\n[结 果]:%@\n#############################\n",dict);
        callback(dict);
    }];
}

+ (void)getHomePageAdsWithCompletionHandler:(DictCallback)callback
{
    NSDictionary *param = @{@"opercode": @"0145", @"userid":[defaults objectForKey:@"userid"], @"token":[defaults objectForKey:@"token"]};
    NSLog(@"\n##########获取首页公告位置焦点图接口##########\n[参 数]:%@\n#############################\n",param);
    [HttpRequest requestWithParams:param andCompletionHandler:^(NSMutableDictionary *dict) {
        NSLog(@"\n##########获取首页公告位置焦点图返回结果##########\n[结 果]:%@\n#############################\n",dict);
        callback(dict);
    }];
}

+ (void)reportInfoType:(NSString *)type
              targetid:(NSString *)targetid
               content:(NSString *)content
 withCompletionHandler:(DictCallback)callback
{
    NSDictionary *param = @{@"opercode": @"0146", @"userid":[defaults objectForKey:@"userid"], @"token":[defaults objectForKey:@"token"],@"type": type, @"targetid": targetid, @"content": content};
    NSLog(@"\n##########举报接口##########\n[参 数]:%@\n#############################\n",param);
    [HttpRequest requestWithParams:param andCompletionHandler:^(NSMutableDictionary *dict) {
        NSLog(@"\n##########举报接口返回结果##########\n[结 果]:%@\n#############################\n",dict);
        callback(dict);
    }];
}

+ (void)inviteToTribe:(NSString *)targetid
              tribeid:(NSString *)tribeid
withCompletionHandler:(DictCallback)callback
{
    NSDictionary *param = @{@"opercode": @"0147", @"userid":[defaults objectForKey:@"userid"], @"token":[defaults objectForKey:@"token"],@"targetid": targetid, @"tribeid": tribeid};
    NSLog(@"\n##########部落创建者或管理员拉人进部落接口##########\n[参 数]:%@\n#############################\n",param);
    [HttpRequest requestWithParams:param andCompletionHandler:^(NSMutableDictionary *dict) {
        NSLog(@"\n##########部落创建者或管理员拉人进部落接口返回结果##########\n[结 果]:%@\n#############################\n",dict);
        callback(dict);
    }];
}

+ (void)infoToTop:(NSString *)tribeid
             type:(NSString *)type
           messid:(NSString *)messid
withCompletionHandler:(DictCallback)callback
{
    NSDictionary *param = @{@"opercode": @"0148", @"userid":[defaults objectForKey:@"userid"], @"token":[defaults objectForKey:@"token"],@"tribeid": tribeid, @"type": type, @"messid":messid};
    NSLog(@"\n##########部落消息置顶/取消置顶接口##########\n[参 数]:%@\n#############################\n",param);
    [HttpRequest requestWithParams:param andCompletionHandler:^(NSMutableDictionary *dict) {
        NSLog(@"\n##########部落消息置顶/取消置顶返回结果##########\n[结 果]:%@\n#############################\n",dict);
        callback(dict);
    }];
}

+ (void)getTribeTopInfo:(NSString *)tribeid
  withCompletionHandler:(DictCallback)callback
{
    NSDictionary *param = @{@"opercode": @"0149", @"userid":[defaults objectForKey:@"userid"], @"token":[defaults objectForKey:@"token"],@"tribeid": tribeid};
    NSLog(@"\n##########获取部落置顶消息接口##########\n[参 数]:%@\n#############################\n",param);
    [HttpRequest requestWithParams:param andCompletionHandler:^(NSMutableDictionary *dict) {
        NSLog(@"\n##########获取部落置顶消息返回结果##########\n[结 果]:%@\n#############################\n",dict);
        callback(dict);
    }];
}

+ (void)getInfluence:(NSString *)type withCompletionHandler:(DictCallback)callback
{
    NSDictionary *param = @{@"opercode": @"0150", @"userid":[defaults objectForKey:@"userid"], @"token":[defaults objectForKey:@"token"],@"type": type};
    NSLog(@"\n##########获取影响力接口##########\n[参 数]:%@\n#############################\n",param);
    [HttpRequest requestWithParams:param andCompletionHandler:^(NSMutableDictionary *dict) {
        NSLog(@"\n##########获取影响力返回结果##########\n[结 果]:%@\n#############################\n",dict);
        callback(dict);
    }];
}

@end
