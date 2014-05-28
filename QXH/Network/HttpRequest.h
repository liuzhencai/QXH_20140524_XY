//
//  HttpRequest.h
//  QXH
//
//  Created by ZhaoLilong on 14-5-12.
//  Copyright (c) 2014年 ZhaoLilong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HttpRequest : NSObject

/*
---------------------------------------------------------------------------------------------------------------------------------
 API:0104(HTTP) 登陆之前获取当前最新版号
 --------------------------------------------------------
 Request(Client Call):
 {
 opercode:"0104",		//operCode为0104，客户端通过该字段确定事件
 platform :1,			//客户端平台,1为安卓平台,2为ios系统
 version:1.1			//客户端版本
 }
 
 Response:{
 opercode:"0104",		//operCode为0104，客户端通过该字段确定事件
 statecode:"0200",		//StateCode取值：获取成功[0200],获取失败[其他]
 info:"获取信息成功",		//描述信息
 version:1.2,			//该平台下的最新版本
 forceupdate:1,			//1为不强制，2为强制更新 (服务器端会记录该版本发布后允许的最低版本，当客户端版本低于该版本，强制更新)
 desc:"新版本的特性，描述信息",	//当用户版本为最新版本时，该desc中值为""
 url:"新版本的下载地址"		//当用户版本为最新版本时，该url中值为""
 }
 */

/**
 *  登陆之前获取当前最新版号
 *
 *  @param params   参数列表
 *  @param callback  响应回调
 */
+ (void)requestLatestVersionNoWithParams:(NSMutableDictionary *)params andCompletionHandler:(DictCallback)callback;

/*
 API:0105(HTTP) 获取用户信息
 --------------------------------------------------------
 Request(Client Call):
 {
 opercode:"0105",		//operCode为0105，客户端通过该字段确定事件
 userid:"666666",		//用户唯一标识
 token:"ab123456789",		//当用户登陆之后，服务器会指定唯一的令牌给相应的客户端，通过此令牌拥有用户权限
 targetid:"123456"		//要获取那个用户的信息
 }
 
 Response:{
 opercode:"0105",		//operCode为0105，客户端通过该字段确定事件
 statecode:"0200",		//StateCode取值：获取成功[0200],获取失败[其他]
 info:"获取成功",		//获取成功/失败!
 displayname:"张三",		//昵称
 signature:"这个是签名...",	//签名
 title:"头衔",			//头衔
 address:"籍贯编码",		//籍贯编码
 domicile:"居住地编码",		//居住地编码
 introduce:"自我介绍",		//自我介绍
 comname:"公司名称",		//公司名称
 comdesc:"公司描述",		//公司描述
 comaddress:"公司地址",		//公司地址
 comurl:"http://wz.com",		//公司网址
 induname:"行业名称",		//行业名称
 indudesc:"行业描述",		//行业描述
 schoolname:"学校名称",		//学校名称
 schooltype:"学校类型",		//学校类型
 sex:"0"	,			//0为保密，1为男，2为女
 photo:"1.jpg",			//头像
 email:"123@qq.com",		//用户邮箱
 tags:"标签1，标签2",		//用户标签
 attentiontags:"标签1，标签2",	//关注标签
 hobbies:"爱好1，爱好2",		//爱好
 educations:"经历1，经历2",	//教育经历
 usertype:"0",			//0为普通用户
 gold:"1000",			//金币数量
 level:"1",			//用户级别
 configure:"a:0;b:1,c:2",	//客户端配置相关信息（需客户端人员协定之后定义公共设置信息）
 status:2			//0为正常用户，1为禁用用户，2为临时用户
 }
*/
/**
 *  获取用户信息
 *
 *  @param params   参数列表
 *  @param callback 响应回调
 */
+ (void)requestUserInfoWithParams:(NSMutableDictionary *)params andCompletionHandler:(DictCallback)callback;

/*
---------------------------------------------------------------------------------------------------------------------------------
 API:0106(HTTP) 修改用户信息
 --------------------------------------------------------
 Request(Client Call):
 {
 opercode:"0106",		//operCode为0106，客户端通过该字段确定事件
 userid:"666666",		//用户唯一标识
 token:"ab123456789",		//当用户登陆之后，服务器会指定唯一的令牌给相应的客户端，通过此令牌拥有用户权限
 displayname:"张三",		//昵称
 signature:"这个是签名...",	//签名
 title:"头衔",			//头衔
 address:"籍贯编码",		//籍贯编码
 domicile:"居住地编码",		//居住地编码
 introduce:"自我介绍",		//自我介绍
 comname:"公司名称",		//公司名称
 comdesc:"公司描述",		//公司描述
 comaddress:"公司地址",		//公司地址
 comurl:"http://wz.com",		//公司网址
 induname:"行业名称",		//行业名称
 indudesc:"行业描述",		//行业描述
 schoolname:"学校名称",		//学校名称
 schooltype:"学校类型",		//学校类型
 sex:"0"	,			//0为保密，1为男，2为女
 email:"123@qq.com",		//用户邮箱
 tags:"标签1，标签2",		//用户标签
 attentiontags:"标签1，标签2",	//关注标签
 hobbies:"爱好1，爱好2",		//爱好
 educations:"经历1，经历2",	//教育经历
 usertype:"0",			//0为普通用户
 gold:"1000",			//金币数量
 level:"1",			//用户级别
 configure:"a:0;b:1,c:2",	//客户端配置相关信息（需客户端人员协定之后定义公共设置信息）
 }
 多个图片上传格式（HTML提交时），上传多个文件的name相同(此时读取第一个文件作为用户头像，无文件不读取)
 < input type='file' name='upload' />
 
 Response:{
 opercode:"0106",		//operCode为0106，客户端通过该字段确定事件
 statecode:"0200",		//StateCode取值：获取成功[0200],获取失败[其他]
 info:"修改成功"			//修改成功/失败!
 }
 */
/**
 *  修改用户信息
 *
 *  @param params   参数列表
 *  @param callback 响应回调
 */
+ (void)modifyUserInfoWithParams:(NSMutableDictionary *)params andCompletionHandler:(DictCallback)callback;


/*
---------------------------------------------------------------------------------------------------------------------------------
 API:0107(HTTP) 获取好友(通讯录)/查找用户列表公用接口
 Request(Client Call):
 {
 opercode:"0107",		//operCode为0107，客户端通过该字段确定事件
 userid:"666666",		//用户唯一标识
 token:"ab123456789",		//当用户登陆之后，服务器会指定唯一的令牌给相应的客户端，通过此令牌拥有用户权限
 type:"1",			//1为获取好友列表，2为搜索
 address:"籍贯编码",		//籍贯编码
 domicile:"居住地编码",		//居住地编码
 displayname:"张三",		//昵称
 }
 Response:{
 opercode:"0106",		//operCode为0106，客户端通过该字段确定事件
 statecode:"0200",		//StateCode取值：获取成功[0200],获取失败[其他]
 info:"获取成功",		//获取成功/失败!
 lists:
 [
 {
 name:"未分组",		//组名称
 type:"1",		//1为未分组
 list:
 [{userid:"123",username:"周扒皮",photo:"2",displayname:"张三",signature:"这个是签名...",remark:"备注",usertype:"0",level:"1"},{userid:"123",username:"周扒皮",photo:2,displayname:"张三",signature:"这个是签名...",remark:"备注",usertype:"0",level:"1"},...]
 },
 {
 name:"哈哈你我",		//组名称
 type:"2",		//2为已分组
 list:
 [{userid:"123",username:"周扒皮",photo:"2",displayname:"张三",signature:"这个是签名...",remark:"备注",usertype:"0",level:"1"},{userid:"123",username:"周扒皮",photo:2,displayname:"张三",signature:"这个是签名...",remark:"备注",usertype:"0",level:"1"},...]
 },
 ]
 }
 */
/**
 *  获取好友(通讯录)/查找用户列表
 *
 *  @param params   参数列表
 *  @param callback 响应回调
 */
+ (void)getFriendWithParams:(NSMutableDictionary *)params andCompletionHandler:(DictCallback)callback;

/*
 API:0108(HTTP) 加好友请求
 --------------------------------------------------------
 Request(Client Call):
 {
 opercode:"0108",
 userid:"1234565",		//用户唯一标识
 token:"ab123456789",		//当用户登陆之后，服务器会指定唯一的令牌给相应的客户端，通过此令牌拥有用户权限
 targetid:"123456",		//被处理的加入成员的userid
 mess:"我是某某莫"		//好友请求验证消息
 }
 
 Response:{
 opercode:"0108",		//operCode为0108，客户端通过该字段确定事件
 statecode:"0200",		//StateCode取值：获取成功[0200],获取失败[其他]
 info:"好友申请发送成功"		//申请成功/失败!
 }
 */


/**
 *  请求加好友
 *
 *  @param params   参数列表
 *  @param callback 响应回调
 */
+ (void)requestAddFriendWithParams:(NSMutableDictionary *)params andCompletionHandler:(DictCallback)callback;

/*
---------------------------------------------------------------------------------------------------------------------------------
 API:0109(HTTP) 加好友确认/修改备注
 --------------------------------------------------------
 Request(Client Call):
 {
 opercode:"0109",
 userid:"1234565",		//用户唯一标识
 token:"ab123456789",		//当用户登陆之后，服务器会指定唯一的令牌给相应的客户端，通过此令牌拥有用户权限
 targetid:"123456",		//被处理的加入成员的userid
 type:"0",			//0为同意(备注不为空添加备注)，1为拒绝，2为修改备注
 remark:"备注"			//备注
 }
 
 Response:{
 opercode:"0109",		//operCode为0109，客户端通过该字段确定事件
 statecode:"0200",		//StateCode取值：获取成功[0200],获取失败[其他]
 info:"操作成功"			//操作成功/失败!
 }
 */
 /**
 *  加好友确认/修改备注
 *
 *  @param params   参数列表
 *  @param callback 响应回调
 */
+ (void)addFriendConfirmWithParams:(NSMutableDictionary *)params andCompletionHandler:(DictCallback)callback;

/*
---------------------------------------------------------------------------------------------------------------------------------
 API:0110(HTTP) 获取码表信息
 --------------------------------------------------------
 Request(Client Call):
 {
 opercode:"0110",		//operCode为0110，客户端通过该字段确定事件
 userid:"666666",		//用户唯一标识
 codetype:"district",		//district为省市区信息，...
 fathercode:"000000",		//当为获取省列表时fathercode=000000,获取市区时fathercode为父级区域的编码
 token:"ab123456789"		//当用户登陆之后，服务器会指定唯一的令牌给相应的客户端，通过此令牌拥有用户权限
 }
 
 Response:{
 opercode:"0110",		//operCode为0110，客户端通过该字段确定事件
 statecode:"0200",		//StateCode取值：获取成功[0200],获取失败[其他]
 info:"获取成功",		//获取成功/失败!
 list:
 [
 {code:"123456",name:"北京市"},{code:"123456",name:"北京市"},{code:"123456",name:"北京市"},......
 ]
 }
 */
 /**
 *  获取码表信息
 *
 *  @param params   参数列表
 *  @param callback 响应回调
 */
+ (void)requestCityCodeWithParams:(NSMutableDictionary *)params andCompletionHandler:(DictCallback)callback;

/*
 ---------------------------------------------------------------------------------------------------------------------------------
 API:0111(HTTP) 获取部落列表
 --------------------------------------------------------
 Request(Client Call):
 {
 opercode:"0111",
 userid:"1234565",		//用户唯一标识
 token:"ab123456789",		//当用户登陆之后，服务器会指定唯一的令牌给相应的客户端，通过此令牌拥有用户权限
 type:"1",			//1为获取已加入的部落列表，2为搜索相关部落列表(为2时读取下列条件)
 tribename:"部落名称",		//部落名称
 signature:"部落签名",		//部落签名
 desc:"部落描述",		//部落描述
 condition:"加入条件",		//加入条件
 purpose:"宗旨",			//宗旨
 rule:"章程",			//章程
 tags:"标签，标签"，		//不同标签之间用逗号隔开
 district:"130400",		//地域信息
 }
 
 Response:{
 opercode:"0111",		//operCode为0111，客户端通过该字段确定事件
 statecode:"0200",		//StateCode取值：获取成功[0200],获取失败[其他]
 info:"创建成功",		//获取成功/失败!
 list:[
 {tribeid:"123444",tribename:"部落1",photo:"2",signature:"这个是签名...",creater:"123456",creatername:"张三"},
 {tribeid:"123444",tribename:"部落2",photo:"2",signature:"这个是签名...",creater:"123456",creatername:"张三"},
 ...
 ]
 }
 */
 /**
 *  获取部落列表
 *
 *  @param params   参数列表
 *  @param callback 响应回调
 */
+ (void)requestTribeListWithParams:(NSMutableDictionary *)params andCompletionHandler:(DictCallback)callback;

/*
 ---------------------------------------------------------------------------------------------------------------------------------
 API:0112(HTTP) 创建部落
 --------------------------------------------------------
 Request(Client Call):
 {
 opercode:"0112",
 userid:"1234565",		//用户唯一标识
 token:"ab123456789",		//当用户登陆之后，服务器会指定唯一的令牌给相应的客户端，通过此令牌拥有用户权限
 tribename:"部落名称",		//部落名称
 signature:"部落签名",		//部落签名
 desc:"部落描述",		//部落描述
 condition:"加入条件",		//加入条件
 purpose:"宗旨",			//宗旨
 rule:"章程",			//章程
 tags:"标签，标签"，		//不同标签之间用逗号隔开
 district:"130400",		//地域信息
 maxcount:"30",			//最多人数
 members:"123,456,789"		//部落成员，成员(userid)之间以逗号隔开
 }
 多个图片上传格式（HTML提交时），上传多个文件的name相同(此时读取第一个文件作为部落头像，无文件不读取)
 < input type='file' name='upload' />
 
 Response:{
 opercode:"0112",		//operCode为0112，客户端通过该字段确定事件
 statecode:"0200",		//StateCode取值：获取成功[0200],获取失败[其他]
 info:"创建成功",		//获取成功/失败!
 tribeid:"123444"		//部落唯一标示
 }
 */
 /**
 *  创建部落
 *
 *  @param params   参数列表
 *  @param callback 响应回调
 */
+ (void)createTribeWithParams:(NSMutableDictionary *)params andCompletionHandler:(DictCallback)callback;

/*
 ---------------------------------------------------------------------------------------------------------------------------------
 API:0113(HTTP) 修改部落信息
 --------------------------------------------------------
 Request(Client Call):
 {
 opercode:"0113",
 userid:"1234565",		//用户唯一标识
 token:"ab123456789",		//当用户登陆之后，服务器会指定唯一的令牌给相应的客户端，通过此令牌拥有用户权限
 tribeid:"123444"		//部落唯一标示
 tribename:"部落名称",		//部落名称
 signature:"部落签名",		//部落签名
 desc:"部落描述",		//部落描述
 condition:"加入条件",		//加入条件
 purpose:"宗旨",			//宗旨
 rule:"章程",			//章程
 tags:"标签，标签"，		//不同标签之间用逗号隔开
 district:"130400",		//地域信息
 maxcount:"30",			//最多人数
 }
 多个图片上传格式（HTML提交时），上传多个文件的name相同(此时读取第一个文件作为部落头像，无文件不读取)
 < input type='file' name='upload' />
 
 Response:{
 opercode:"0113",		//operCode为0113，客户端通过该字段确定事件
 statecode:"0200",		//StateCode取值：获取成功[0200],获取失败[其他]
 info:"修改成功",		//修改成功/失败!
 }
 */
 /**
 *  修改部落信息
 *
 *  @param params   参数列表
 *  @param callback 响应回调
 */
+ (void)modifyTribeInfoWithParams:(NSMutableDictionary *)params andCompletionHandler:(DictCallback)callback;

/*
 ---------------------------------------------------------------------------------------------------------------------------------
 
 API:0114(HTTP) 获取部落信息
 --------------------------------------------------------
 Request(Client Call):
 {
 opercode:"0114",
 userid:"1234565",		//用户唯一标识
 token:"ab123456789",		//当用户登陆之后，服务器会指定唯一的令牌给相应的客户端，通过此令牌拥有用户权限
 tribeid:"123444"		//部落唯一标示
 }
 
 Response:{
 opercode:"0114",		//operCode为0114，客户端通过该字段确定事件
 statecode:"0200",		//StateCode取值：获取成功[0200],获取失败[其他]
 info:"创建成功",		//获取成功/失败!
 tribename:"部落名称",		//部落名称
 signature:"部落签名",		//部落签名
 desc:"部落描述",		//部落描述
 condition:"加入条件",		//加入条件
 purpose:"宗旨",			//宗旨
 rule:"章程",			//章程
 tags:"标签，标签"，		//不同标签之间用逗号隔开
 creater:"123456",		//创建人userid
 creatername:"张三",		//创建人名称
 createrphoto:"1.jpg",		//创建人头像
 cretersign:"签名",		//创建人签名
 district:"130400",		//地域信息
 photo:"2.jpg",			//部落头像
 maxcount:"30",			//部落最多人数
 nowcount:"20"			//当前部落人数
 }
 */
 /**
 *  获取部落信息
 *
 *  @param params   参数列表
 *  @param callback 响应回调
 */
+ (void)requestTribeInfoWithParams:(NSMutableDictionary *)params andCompletionHandler:(DictCallback)callback;

/*
 ---------------------------------------------------------------------------------------------------------------------------------
 
 API:0115(HTTP) 申请加入部落
 --------------------------------------------------------
 Request(Client Call):
 {
 opercode:"0115",
 userid:"1234565",		//用户唯一标识
 token:"ab123456789",		//当用户登陆之后，服务器会指定唯一的令牌给相应的客户端，通过此令牌拥有用户权限
 tribeid:"123444"		//部落唯一标示
 }
 
 Response:{
 opercode:"0115",		//operCode为0115，客户端通过该字段确定事件
 statecode:"0200",		//StateCode取值：获取成功[0200],获取失败[其他]
 info:"申请成功"			//申请成功/失败!
 }
 */
 /**
 *  申请加入部落
 *
 *  @param params   参数列表
 *  @param callback 响应回调
 */
+ (void)requestJoinTribeWithParams:(NSMutableDictionary *)params andCompletionHandler:(DictCallback)callback;

/*
 ---------------------------------------------------------------------------------------------------------------------------------
 
 API:0116(HTTP) 部落创建者处理加入部落请求
 --------------------------------------------------------
 Request(Client Call):
 {
 opercode:"0116",
 userid:"1234565",		//用户唯一标识
 token:"ab123456789",		//当用户登陆之后，服务器会指定唯一的令牌给相应的客户端，通过此令牌拥有用户权限
 tribeid:"123444",		//部落唯一标示
 targetid:"123456",		//被处理的加入成员的userid
 permitflag:"0"			//允许标示：0为允许加入，1为拒绝加入
 }
 
 Response:{
 opercode:"0116",		//operCode为0116，客户端通过该字段确定事件
 statecode:"0200",		//StateCode取值：获取成功[0200],获取失败[其他]
 info:"处理成功"			//处理成功/失败!
 }
 */
 /**
 *  部落创建者处理加入部落请求
 *
 *  @param params   参数列表
 *  @param callback 响应回调
 */
+ (void)dealJoinTribeWithParams:(NSMutableDictionary *)params andCompletionHandler:(DictCallback)callback;

/*
---------------------------------------------------------------------------------------------------------------------------------
 
 
 API:0117(HTTP) 获取部落成员列表
 --------------------------------------------------------
 Request(Client Call):
 {
 opercode:"0117
 userid:"1234565",		//用户唯一标识
 token:"ab123456789",		//当用户登陆之后，服务器会指定唯一的令牌给相应的客户端，通过此令牌拥有用户权限
 tribeid:"123444"		//部落唯一标示
 }
 
 Response:{
 opercode:"0117",		//operCode为0117，客户端通过该字段确定事件
 statecode:"0200",		//StateCode取值：获取成功[0200],获取失败[其他]
 info:"创建成功",		//获取成功/失败!
 list:[
 {userid:"123",username:"周扒皮",photo:"2",displayname:"张三",signature:"这个是签名...",remark:"备注",usertype:"0",level:"1"},
 {userid:"123",username:"周扒皮",photo:"2",displayname:"张三",signature:"这个是签名...",remark:"备注",usertype:"0",level:"1"},
 ...
 ]
 }
 */
 /**
 *  部落创建者处理加入部落请求
 *
 *  @param params   参数列表
 *  @param callback 响应回调
 */
+ (void)requestTribeMemberWithParams:(NSMutableDictionary *)params andCompletionHandler:(DictCallback)callback;

/*
 ---------------------------------------------------------------------------------------------------------------------------------
 
 
 API:0118(HTTP) 退出部落
 --------------------------------------------------------
 Request(Client Call):
 {
 opercode:"0118",
 userid:"1234565",		//用户唯一标识
 token:"ab123456789",		//当用户登陆之后，服务器会指定唯一的令牌给相应的客户端，通过此令牌拥有用户权限
 tribeid:"123444"		//部落唯一标示
 }
 
 Response:{
 opercode:"0118",		//operCode为0118，客户端通过该字段确定事件
 statecode:"0200",		//StateCode取值：获取成功[0200],获取失败[其他]
 info:"退出成功"			//退出成功/失败!
 }
 */
 /**
 *  退出部落
 *
 *  @param params   参数列表
 *  @param callback 响应回调
 */
+ (void)quitTribeWithParams:(NSMutableDictionary *)params andCompletionHandler:(DictCallback)callback;

/*
 ---------------------------------------------------------------------------------------------------------------------------------
 
 API:0119(HTTP) 获取查询广场/咨询消息列表,获取收藏列表
 --------------------------------------------------------
 Request(Client Call):
 {
 opercode:"0119",
 userid:"1234565",		//用户唯一标识
 token:"ab123456789"		//当用户登陆之后，服务器会指定唯一的令牌给相应的客户端，通过此令牌拥有用户权限
 type:"1",			//信息类型(1为广场消息，2为咨询,3为收藏)
 tags:"标签，标签"，		//不同标签之间用逗号隔开
 arttype:"教育",			//文章类型
 start:"10",			//起始消息的artid，不填写该字段读取最新消息n个
 direction:"before",		//方向 before获取start消息之前的n条,after获取start消息之后的n调
 count:"20"			//获取消息数量
 }
 
 Response:{
 opercode:"0119",		//operCode为0119，客户端通过该字段确定事件
 statecode:"0200",		//StateCode取值：获取成功[0200],获取失败[其他]
 info:"获取成功",		//获取成功/失败!
 list:				//消息列表
 [
 {artid:"1234",sid:"123456",sname:"发送人名字",sphoto:"1.jpg",date:"2014-05-06 22:13:11",title:"标题",artimgs:"1.jpg,2.jpg",article:"这是消息",ctcount:10,gold:10},
 {artid:"1235",sid:"123456",sname:"发送人名字",sphoto:"1.jpg",date:"2014-05-06 22:13:11",title:"标题",artimgs:"1.jpg,2.jpg",article:"这是消息",ctcount:10,gold:10},
 {artid:"1236",sid:"123456",sname:"发送人名字",sphoto:"1.jpg",date:"2014-05-06 22:13:11",title:"标题",artimgs:"1.jpg,2.jpg",article:"这是消息",ctcount:10,gold:10},
 ......
 ]
 }
 */
 /**
 *  获取查询广场/咨询消息列表,获取收藏列表
 *
 *  @param params   参数列表
 *  @param callback 响应回调
 */
+ (void)querySquareWithParams:(NSMutableDictionary *)params andCompletionHandler:(DictCallback)callback;

/*
 ---------------------------------------------------------------------------------------------------------------------------------
 
 API:0120(HTTP) 广场/咨询发布信息
 --------------------------------------------------------
 Request(Client Call):
 {
 opercode:"0120",
 userid:"1234565",		//用户唯一标识
 token:"ab123456789",		//当用户登陆之后，服务器会指定唯一的令牌给相应的客户端，通过此令牌拥有用户权限
 title:"标题",			//文章标题
 tags:"标签，标签"，		//不同标签之间用逗号隔开
 type:"1",			//信息类型(1为广场消息，2为咨询)
 arttype:"教育",			//文章类型
 article:"文章内容",		//文章内容
 }
 多个图片上传格式（HTML提交时），上传多个文件的name相同
 < input type='file' name='upload' />
 < input type='file' name='upload' />
 < input type='file' name='upload' />
 
 
 Response:{
 opercode:"0120",		//operCode为0120，客户端通过该字段确定事件
 statecode:"0200",		//StateCode取值：获取成功[0200],获取失败[其他]
 info:"发布成功",		//发布成功/失败!
 artid:"1234"			//发布信息的id
 }
 */
 /**
 *  广场/咨询发布信息
 *
 *  @param params   参数列表
 *  @param callback 响应回调
 */
+ (void)requestSquareInfoWithParams:(NSMutableDictionary *)params andCompletionHandler:(DictCallback)callback;

/*
 ---------------------------------------------------------------------------------------------------------------------------------
 
 API:0121(HTTP) 获取广场/咨询消息详细信息
 --------------------------------------------------------
 Request(Client Call):
 {
 opercode:"0121",
 userid:"1234565",		//用户唯一标识
 token:"ab123456789",		//当用户登陆之后，服务器会指定唯一的令牌给相应的客户端，通过此令牌拥有用户权限
 type:"1",			//信息类型(1为广场消息，2为咨询)
 artid:"1234"			//广场消息的唯一标示
 }
 
 Response:{
 opercode:"0121",		//operCode为0121，客户端通过该字段确定事件
 statecode:"0200",		//StateCode取值：获取成功[0200],获取失败[其他]
 info:"获取成功",		//获取成功/失败!
 sid:"123456",			//消息发布者的唯一标示userid
 sname:"发送人名字",		//消息发布者的名字
 sphoto:"1.jpg",			//消息发布者的头像
 date:"2014-05-06 22:13:11",	//发布日期
 title:"标题",			//消息标题
 artimgs:"1.jpg,2.jpg",		//图片信息
 article:"这是消息",		//消息文章实体内容
 ctcount:10,			//评论次数
 gold:10				//打赏金币数
 }
 */
  /**
 *  获取广场/咨询消息详细信息
 *
 *  @param params   参数列表
 *  @param callback 响应回调
 */
+ (void)requestSquareDetailWithParams:(NSMutableDictionary *)params andCompletionHandler:(DictCallback)callback;

/*
 ---------------------------------------------------------------------------------------------------------------------------------
 
 API:0122(HTTP) 广场文章加金/评论
 --------------------------------------------------------
 Request(Client Call):
 {
 opercode:"0122",
 userid:"1234565",		//用户唯一标识
 token:"ab123456789",		//当用户登陆之后，服务器会指定唯一的令牌给相应的客户端，通过此令牌拥有用户权限
 artid:"1234",			//广场消息的唯一标示
 gold:"1",			//加金 1为加金1,0为不加金
 comment:"评论"			//评论
 }
 
 Response:{
 opercode:"0122",		//operCode为0122，客户端通过该字段确定事件
 statecode:"0200",		//StateCode取值：获取成功[0200],获取失败[其他]
 info:"操作成功",		//获取成功/失败!
 ctid:"1234"			//评论的id
 }
 */
  /**
 *  广场文章加金/评论
 *
 *  @param params   参数列表
 *  @param callback 响应回调
 */
+ (void)requestSquareRemarkWithParams:(NSMutableDictionary *)params andCompletionHandler:(DictCallback)callback;

/*
 ---------------------------------------------------------------------------------------------------------------------------------
 
 API:0123(HTTP) 获取评论列表
 --------------------------------------------------------
 Request(Client Call):
 {
 opercode:"0123",
 userid:"1234565",		//用户唯一标识
 token:"ab123456789",		//当用户登陆之后，服务器会指定唯一的令牌给相应的客户端，通过此令牌拥有用户权限
 artid:"1234",			//广场消息的唯一标示
 start:"10",			//起始评论号 不填写该字段读取最新消息n个
 direction:"before",		//方向 before获取start消息之前的n条,after获取start消息之后的n调
 count:"20"			//获取消息数量
 }
 
 Response:{
 opercode:"0123",		//operCode为0123，客户端通过该字段确定事件
 statecode:"0200",		//StateCode取值：获取成功[0200],获取失败[其他]
 info:"操作成功",		//获取成功/失败!
 list:				//评论列表
 [
 {ctid:"1234",sid:"123456",sname:"发送人名字",sphoto:"1.jpg",date:"2014-05-06 22:13:11",comment:"这是评论"},
 {ctid:"1234",sid:"123456",sname:"发送人名字",sphoto:"1.jpg",date:"2014-05-06 22:13:11",comment:"这是评论"},
 {ctid:"1234",sid:"123456",sname:"发送人名字",sphoto:"1.jpg",date:"2014-05-06 22:13:11",comment:"这是评论"},
 ......
 ]
 }
 */
  /**
 *  获取评论列表
 *
 *  @param params   参数列表
 *  @param callback 响应回调
 */
+ (void)requestRemarkListWithParams:(NSMutableDictionary *)params andCompletionHandler:(DictCallback)callback;

/*
 ---------------------------------------------------------------------------------------------------------------------------------
 
 API:0124(HTTP) 广场文章收藏
 --------------------------------------------------------
 Request(Client Call):
 {
 opercode:"0124",
 userid:"1234565",		//用户唯一标识
 token:"ab123456789",		//当用户登陆之后，服务器会指定唯一的令牌给相应的客户端，通过此令牌拥有用户权限
 artid:"1234",			//广场消息的唯一标示
 type:"1",			//1为分享，2为收藏
 targetid:"12344556",		//发送给，好友或部落
 sendtype:"1",			//1为好友私聊，2为部落聊天
 }
 
 Response:{
 opercode:"0124",		//operCode为0124，客户端通过该字段确定事件
 statecode:"0200",		//StateCode取值：获取成功[0200],获取失败[其他]
 info:"操作成功"			//操作成功/失败!
 }
 */
  /**
 *  广场文章收藏
 *
 *  @param params   参数列表
 *  @param callback 响应回调
 */
+ (void)requestSquareCollectionWithParams:(NSMutableDictionary *)params andCompletionHandler:(DictCallback)callback;

/*
 ---------------------------------------------------------------------------------------------------------------------------------
 
 
 API:0125(HTTP) 获取/搜索活动列表
 --------------------------------------------------------
 Request(Client Call):
 {
 opercode:"0125",
 userid:"1234565",		//用户唯一标识
 token:"ab123456789"		//当用户登陆之后，服务器会指定唯一的令牌给相应的客户端，通过此令牌拥有用户权限
 start:"10",			//起始消息的artid，不填写该字段读取最新消息n个
 direction:"before",		//方向 before获取start消息之前的n条,after获取start消息之后的n调
 count:"20",			//获取消息数量
 actname:"活动名称",		//活动名称
 tags:"标签，标签"，		//不同标签之间用逗号隔开
 district:"130400",		//地域信息
 canjoin:"0"			//0为全部活动，1为可加入报名的活动,2为已参加的活动
 }
 
 Response:{
 opercode:"0125",		//operCode为0125，客户端通过该字段确定事件
 statecode:"0200",		//StateCode取值：获取成功[0200],获取失败[其他]
 info:"获取成功",		//获取成功/失败!
 list:				//消息列表
 [
 {actid:"1234",actname:"活动名称",photos:"1.jpg,2.jpg",signupbegindate:"2014-05-01 12:00:00",signupenddate:"2014-05-03 12:00:00",actdate:"2014-05-05 12:00:00",actaddr:"活动地址",maxcount:"30",nowcount:"10",tags:"标签，标签",desc:""},
 {actid:"1234",actname:"活动名称",photos:"1.jpg,2.jpg",signupbegindate:"2014-05-01 12:00:00",signupenddate:"2014-05-03 12:00:00",actdate:"2014-05-05 12:00:00",actaddr:"活动地址",maxcount:"30",nowcount:"10",tags:"标签，标签",desc:""},
 {actid:"1234",actname:"活动名称",photos:"1.jpg,2.jpg",signupbegindate:"2014-05-01 12:00:00",signupenddate:"2014-05-03 12:00:00",actdate:"2014-05-05 12:00:00",actaddr:"活动地址",maxcount:"30",nowcount:"10",tags:"标签，标签",desc:""},
 ......
 ]
 }
 */
  /**
 *  获取/搜索活动列表
 *
 *  @param params   参数列表
 *  @param callback 响应回调
 */
+ (void)requestActivityListWithParams:(NSMutableDictionary *)params andCompletionHandler:(DictCallback)callback;

/*
 ---------------------------------------------------------------------------------------------------------------------------------
 API:0126(HTTP) 创建活动(activity)
 --------------------------------------------------------
 Request(Client Call):
 {
 opercode:"0126",
 userid:"1234565",		//用户唯一标识
 token:"ab123456789",		//当用户登陆之后，服务器会指定唯一的令牌给相应的客户端，通过此令牌拥有用户权限
 actname:"活动名称",		//活动名称
 desc:"活动描述",		//活动描述,简介
 condition:"加入条件",		//加入条件
 tags:"标签，标签"，		//不同标签之间用逗号隔开
 district:"130400",		//地域信息
 actaddr:"活动地址",		//活动地址
 startoffaddr:"出发地点"		//出发地点
 maxcount:"30",			//最多人数
 signupbegindate:"2014-05-01 12:00:00",//报名起始日期
 signupenddate:"2014-05-03 12:00:00",//报名截止日期
 actdate:"2014-05-05 12:00:00"	//活动起始时间
 }
 多个图片上传格式（HTML提交时），上传多个文件的name相同
 < input type='file' name='upload' />
 < input type='file' name='upload' />
 < input type='file' name='upload' />
 
 
 Response:{
 opercode:"0126",		//operCode为0126，客户端通过该字段确定事件
 statecode:"0200",		//StateCode取值：获取成功[0200],获取失败[其他]
 info:"发起成功,请耐心等待审核",	//发起成功/失败!
 actid:"123444"			//活动唯一标示
 }
 */
  /**
 *  创建活动
 *
 *  @param params   参数列表
 *  @param callback 响应回调
 */
+ (void)createActivityWithParams:(NSMutableDictionary *)params andCompletionHandler:(DictCallback)callback;

/*
 ---------------------------------------------------------------------------------------------------------------------------------
 
 API:0127(HTTP) 获取活动详细信息
 --------------------------------------------------------
 Request(Client Call):
 {
 opercode:"0123",
 userid:"1234565",		//用户唯一标识
 token:"ab123456789",		//当用户登陆之后，服务器会指定唯一的令牌给相应的客户端，通过此令牌拥有用户权限
 actid:"1234"			//活动的唯一标示
 }
 
 Response:{
 opercode:"0127",		//operCode为0127，客户端通过该字段确定事件
 statecode:"0200",		//StateCode取值：获取成功[0200],获取失败[其他]
 info:"获取成功",		//获取成功/失败!
 actname:"活动名称",		//活动名称
 desc:"活动描述",		//活动描述,简介
 actimgs:"1.jpg,2.jpg",		//活动相关图片
 condition:"加入条件",		//加入条件
 tags:"标签，标签"，		//不同标签之间用逗号隔开
 district:"130400",		//地域信息
 actaddr:"活动地址",		//活动地址
 startoffaddr:"出发地点",	//出发地点
 maxcount:"30",			//最多人数
 nowcount:"10",			//当前人数
 signupbegindate:"2014-05-01 12:00:00",//报名起始日期
 signupenddate:"2014-05-03 12:00:00",//报名截止日期
 actdate:"2014-05-05 12:00:00"	//活动起始时间
 joins:				//已报名的人
 [
 {userid:"123",photo:"2",displayname:"张三",remark:"备注"},
 {userid:"123",photo:"2",displayname:"张三",remark:"备注"},
 ...
 ],
 followers:
 [
 {userid:"123",photo:"2",displayname:"张三",remark:"备注"},
 {userid:"123",photo:"2",displayname:"张三",remark:"备注"},
 ...
 ]
 }
 */
  /**
 *  获取活动详细信息
 *
 *  @param params   参数列表
 *  @param callback 响应回调
 */
+ (void)requestActivityDetailWithParams:(NSMutableDictionary *)params andCompletionHandler:(DictCallback)callback;

/*
 ---------------------------------------------------------------------------------------------------------------------------------
 
 API:0128(HTTP) 加入/关注活动
 --------------------------------------------------------
 Request(Client Call):
 {
 opercode:"0128",
 userid:"1234565",		//用户唯一标识
 token:"ab123456789",		//当用户登陆之后，服务器会指定唯一的令牌给相应的客户端，通过此令牌拥有用户权限
 type:"1",			//1为申请加入，2为关注
 actid:"123444"			//活动唯一标示
 }
 
 Response:{
 opercode:"0128",		//operCode为0128，客户端通过该字段确定事件
 statecode:"0200",		//StateCode取值：获取成功[0200],获取失败[其他]
 info:"操作成功"			//操作成功/失败!
 }
 */
  /**
 *  获取活动详细信息
 *
 *  @param params   参数列表
 *  @param callback 响应回调
 */
+ (void)joinActivityWithParams:(NSMutableDictionary *)params andCompletionHandler:(DictCallback)callback;

/*
 ---------------------------------------------------------------------------------------------------------------------------------
 
 API:0129(HTTP) 退出活动
 --------------------------------------------------------
 Request(Client Call):/
 {
 opercode:"0129",
 userid:"1234565",		//用户唯一标识
 token:"ab123456789",		//当用户登陆之后，服务器会指定唯一的令牌给相应的客户端，通过此令牌拥有用户权限
 actid:"123444"			//活动唯一标示
 }
 
 Response:{
 opercode:"0129",		//operCode为0129，客户端通过该字段确定事件
 statecode:"0200",		//StateCode取值：获取成功[0200],获取失败[其他]
 info:"退出成功"			//退出成功/失败!p
 }
 */
  /**
 *  退出活动
 *
 *  @param params   参数列表
 *  @param callback 响应回调
 */
+ (void)quitActivityWithParams:(NSMutableDictionary *)params andCompletionHandler:(DictCallback)callback;

/*
 ---------------------------------------------------------------------------------------------------------------------------------
 API:0133(HTTP) 获取聊天记录信息
 --------------------------------------------------------
 Request(Client Call):
 {
 opercode:"0133",
 userid:"1234565",		//用户唯一标识
 token:"ab123456789"		//当用户登陆之后，服务器会指定唯一的令牌给相应的客户端，通过此令牌拥有用户权限
 targetid:"12344556",		//发送给，好友或部落
 sendtype:"1",			//1为好友私聊，2为部落聊天
 start:"10",			//起始消息version号，不填写该字段读取最新消息n个
 direction:"before",		//方向 before获取start消息之前的n条,after获取start消息之后的n调
 count:"20"			//获取消息数量
 }
 
 Response:{
 opercode:"0133",		//operCode为0110，客户端通过该字段确定事件
 statecode:"0200",		//StateCode取值：获取成功[0200],获取失败[其他]
 info:"获取成功",		//获取成功/失败!
 list:				//
 [
 {messid:"123",sid:"123456",sname:"发送人名字",sphoto:"1.jpg",date:"2014-05-06 22:13:11",mess:"这是消息"},
 {messid:"124",sid:"123456",sname:"发送人名字",sphoto:"1.jpg",date:"2014-05-06 22:13:11",mess:"这是消息"},
 {messid:"125",sid:"123456",sname:"发送人名字",sphoto:"1.jpg",date:"2014-05-06 22:13:11",mess:"这是消息"},
 ......
 ]
 }
 */
 /**
 *  获取聊天记录信息
 *
 *  @param params   参数列表
 *  @param callback 响应回调
 */
+ (void)requestChatHistoryWithParams:(NSMutableDictionary *)params andCompletionHandler:(DictCallback)callback;

/*
 API:0134(HTTP) 分享通用接口
 --------------------------------------------------------
 Request(Client Call):
 {
 opercode:"0134",
 userid:"1234565",		//用户唯一标识
 token:"ab123456789",		//当用户登陆之后，服务器会指定唯一的令牌给相应的客户端，通过此令牌拥有用户权限
 artid:"1234",			//广场消息的唯一标示
 contentype:"1",			//1为广场文章，2为咨询分享，3为活动分享
 sharetype:"1",			//1为分享给好友，2为分享给部落
 targetid:"12344556",		//分享给好友或部落的id，如果为多个好友或部落，中间以逗号隔开
 }
 
 Response:{
 opercode:"0134",		//operCode为0133，客户端通过该字段确定事件
 statecode:"0200",		//StateCode取值：获取成功[0200],获取失败[其他]
 info:"操作成功"			//操作成功/失败!
 }
 */
  /**
 *  分享通用接口
 *
 *  @param params   参数列表
 *  @param callback 响应回调
 */

+ (void)requestWithParams:(NSMutableDictionary *)params andCompletionHandler:(DictCallback)callback;

@end
