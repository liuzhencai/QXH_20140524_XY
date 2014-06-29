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
 *  修改用户信息(注：如果某个字段不修改请将字段的值置为“------”,其他情况视为修改)
 *
 *  @param displayname   昵称
 *  @param oldpwd        老密码
 *  @param newpwd        新密码
 *  @param signature     签名
 *  @param title         头衔职称
 *  @param degree        学位
 *  @param address       籍贯编码
 *  @param domicile      居住地编码
 *  @param introduce     自我介绍
 *  @param comname       公司名称
 *  @param comdesc       公司描述
 *  @param comaddress    公司地址
 *  @param comurl        公司网址
 *  @param induname      行业名称
 *  @param indudesc      行业描述
 *  @param schoolname    学校名称
 *  @param schooltype    学校类型
 *  @param sex           0为保密，1为男，2为女
 *  @param email         用户邮箱
 *  @param tags          用户标签
 *  @param attentiontags 关注标签
 *  @param hobbies       爱好
 *  @param educations    教育经历
 *  @param honours       荣誉
 *  @param callback      回调
 */
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
 withCompletionHandler:(DictCallback)callback;
                                                                                                                                                                        
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
 *  @param status    1为状态正常的部落(可聊天使用的部落),2为申请中的部落(不能聊天)
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
                  status:(NSString *)status
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
//+ (void)createTribe:(NSString *)tribename
//         tribestyle:(NSString *)tribestyle
//          secretary:(NSString *)userid
//          signature:(NSString *)signature
//               desc:(NSString *)desc
//          condition:(NSString *)condition
//            purpose:(NSString *)purpose
//               rule:(NSString *)rule
//               tags:(NSString *)tags
//           district:(NSString *)district
//           maxcount:(NSString *)maxcount
//            members:(NSString *)members
//withCompletionHandler:(DictCallback)callback;

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
 *  获取查询广场文章/咨询文章列表,获取收藏列表
 *
 *  @param type          信息类型(0为不区分[获取个人收藏文章时使用],1为广场消息，2为咨询)
 *  @param detailtype    信息明细类型 1为最新，2为最热,3为收藏
 *  @param tag           标签
 *  @param arttype       文章类型
 *  @param contentlength 文章列表中文章的长度
 *  @param start         起始消息的artid，不填写该字段读取最新消息n个
 *  @param count         获取消息数量
 */
+ (void)getInfoList:(NSString *)type
         detailtype:(NSString *)detailtype
                tag:(NSString *)tag
            arttype:(NSString *)arttype
      contentlength:(NSString *)contentlength
              start:(NSString *)start
              count:(NSString *)count
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
 *  文章赞/评论
 *
 *  @param artid    广场消息的唯一标示
 *  @param laud     赞 1为赞1,0为无操作
 *  @param comment  评论
 *  @param callback 回调
 */
+ (void)praiseArticle:(NSString *)artid
                 laud:(NSString *)laud
              comment:(NSString *)comment
withCompletionHandler:(DictCallback)callback;

/**
 *  获取评论列表
 *
 *  @param artid    广场消息的唯一标示
 *  @param start    起始评论号 ,该字段为0时读取最新消息n个
 *  @param count    获取消息数量
 *  @param callback 回调
 */
+ (void)getCommentList:(NSString *)artid
                 start:(NSString *)start
                 count:(NSString *)count
 withCompletionHandler:(DictCallback)callback;

/**
 *  广场文章收藏
 *
 *  @param type  1为收藏，2为取消收藏
 *  @param artid 广场消息的唯一标示
 *  @param callback 回调
 */
+ (void)squareArticleCollection:(NSString *)type
                          artid:(NSString *)artid
          withCompletionHandler:(DictCallback)callback;



/**
 *  获取/搜索活动列表(列表按创建时间的逆序排列)
 *
 *  @param start     起始消息的artid，不填写该字段读取最新消息n个
 *  @param count     获取消息数量
 *  @param actname   活动名称
 *  @param tribeid   活动描述的长度
 *  @param tag       标签
 *  @param district  地域信息
 *  @param canjoin   0为全部活动，1为未参加的活动,2为已参加的活动,3为和我有关的活动（参加的，关注的）
 *  @param actstate  活动状态 0为全部，1为未开始的活动，2为正在进行的活动，3为已结束的活动
 *  @param tribeid   部落id，不为0时读取分享到该部落的活动
 *  @param begindate 活动起始时间
 *  @param enddate   活动结束时间
 *  @param callback  回调
 */
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
withCompletionHandler:(DictCallback)callback;

/**
 *  创建活动
 *
 *  @param actname         活动名称
 *  @param acttype         活动类型
 *  @param desc            活动描述,简介
 *  @param actimgs         活动相关图片
 *  @param condition       加入条件
 *  @param comefrom        来自哪里
 *  @param tags            不同标签之间用逗号隔开
 *  @param district        地域信息
 *  @param actaddr         活动地址
 *  @param startoffaddr    出发地点
 *  @param maxcount        最多人数
 *  @param signupbegindate 报名起始日期
 *  @param signupenddate   报名截止日期
 *  @param begindate       活动起始时间
 *  @param enddate         活动结束时间
 *  @param callback        回调
 */
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
withCompletionHandler:(DictCallback)callback;

/**
 *  获取活动详细信息
 *
 *  @param actid    活动的唯一标示
 *  @param callback 回调
 */
+ (void)getActDetailInfo:(NSString *)actid withCompletionHandler:(DictCallback)callback;

/**
 *  加入/关注活动
 *
 *  @param type     1为申请加入，2为关注
 *  @param actid    活动唯一标示
 *  @param callback 回调
 */
+ (void)joinAct:(NSString *)type
          actid:(NSString *)actid
withCompletionHandler:(DictCallback)callback;

/**
 *  退出活动/取消关注
 *
 *  @param actid    活动唯一标示
 *  @param callback 回调
 */
+ (void)quitAct:(NSString *)actid withCompletionHandler:(DictCallback)callback;

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
 *  分享内容
 *
 *  @param artid       广场消息的唯一标示
 *  @param contenttype 1为广场文章，2为咨询分享，3为活动分享
 *  @param sharetype   1为分享给好友，2为分享给部落
 *  @param targetid    分享给好友或部落的id，如果为多个好友或部落，中间以逗号隔开
 *  @param callback 回调
 */
+ (void)shareContent:(NSString *)artid
         contenttype:(NSString *)contenttype
           sharetype:(NSString *)sharetype
            targetid:(NSString *)targetid
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

/**
 *  修改活动
 *
 *  @param actid           活动唯一标示
 *  @param actname         活动名称
 *  @param acttype         活动类型
 *  @param desc            活动描述,简介
 *  @param condition       加入条件
 *  @param comefrom        来自哪里
 *  @param tags            不同标签之间用逗号隔开
 *  @param district        地域信息
 *  @param actaddr         活动地址
 *  @param startoffaddr    出发地点
 *  @param maxcount        最多人数
 *  @param delactimgs      要删除的图片列表
 *  @param actimgs         新添加的图片列表
 *  @param signupbegindate 报名起始日期
 *  @param signupenddate   报名截止日期
 *  @param begindate       活动起始时间
 *  @param enddate         活动结束时间
 */
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
withCompletionHandler:(DictCallback)callback;

/**
 *  获取访客
 *
 *  @param targetid 要获取那个用户的id
 *  @param callback 回调
 */
+ (void)getVisitorList:(NSString *)targetid withCompletionHandler:(DictCallback)callback;

/**
 *  获取登录消息
 *
 *  @param callback 获取登陆消息（此接口为用户登陆成功后调用，用户获取在用户离线期间收到的消息）
 */
+ (void)getLoginInfoWithCompletionHandler:(DictCallback)callback;

/**
 *  文件上传
 *
 *  @param file     UIImage对象或文件URL
 *  @param type     1为图片，2为文档，3为音频
 *  @param callback 回调
 */
+ (void)fileUpload:(id)file
              type:(NSString *)type
withCompletionHandler:(DictCallback)completionBlock
        errorBlock:(DescriptionBlock)errorBlock;

/**
 *  获取广场消息列表
 *
 *  @param type          type值：0为不区分,1为广场发布的文章，2为转发到广场的咨询，3为转发到广场的活动
 *  @param detailtype    信息明细类型 1为最新,2为我发布的(注：关于广场中最热获取，认为是获取广场发布文章的最热请调用API:0119(HTTP)接口)
 *  @param tag           标签(暂时保留，客户端不需填写值)
 *  @param arttype       文章类型(暂时保留，客户端不需填写值)
 *  @param contentlength 文章列表中文章的长度
 *  @param start         起始消息的artid，不填写该字段读取最新消息n个
 *  @param count         获取消息数量
 *  @param callback      回调
 */
+ (void)getSquareInfoList:(NSString *)type
               detailtype:(NSString *)detailtype
                      tag:(NSString *)tag
                  arttype:(NSString *)arttype
            contentlength:(NSString *)contentlength
                    start:(NSString *)start
                    count:(NSString *)count
    withCompletionHandler:(DictCallback)callback;

/**
 *  转发通用接口(转发指将咨询文章，活动转发到广场的操作)
 *
 *  @param type     2为咨询转发，3为活动转发
 *  @param targetid 要转发的目标id
 *  @param refsign  转发语
 *  @param callback 回调
 */
+ (void)transmit:(NSString *)type
        targetid:(NSString *)targetid
         refsign:(NSString *)refsign
withCompletionHandler:(DictCallback)callback;

/**
 *  获取每日一问通用接口
 *
 *  @param type     1为广场每日一问，2为部落中置顶消息
 *  @param tribeid  部落id(sendtype=2时读取该字段)
 *  @param callback 回调
 */
+ (void)getEveryDayAsk:(NSString *)type
               tribeid:(NSString *)tribeid
 withCompletionHandler:(DictCallback)callback;

/**
 *  获取首页公告位置焦点图
 *
 *  @param callback 回调
 */
+ (void)getHomePageAdsWithCompletionHandler:(DictCallback)callback;

/**
 *  举报接口
 *
 *  @param type     举报类型,1：举报用户，2为举报部落，3为举报广场文章，4为举报活动
 *  @param targetid 举报目标id
 *  @param content  举报内容
 *  @param callback 回调
 */
+ (void)reportInfoType:(NSString *)type
              targetid:(NSString *)targetid
               content:(NSString *)content
 withCompletionHandler:(DictCallback)callback;

@end
