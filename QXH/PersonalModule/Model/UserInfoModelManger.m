//
//  UserInfoModelManger.m
//  QXH
//
//  Created by liuzhencai on 14-6-10.
//  Copyright (c) 2014年 ZhaoLilong. All rights reserved.
//  管理用户信息

#import "UserInfoModelManger.h"
#import "UserInfoModel.h"

@implementation UserInfoModelManger
@synthesize userInfo;



static   UserInfoModelManger* instance;

- (instancetype)init
{
    self = [super init];
    if (self) {

        
    }
    return self;
}

+(UserInfoModelManger*)sharUserInfoModelManger
{
    if (!instance) {
        instance = [[UserInfoModelManger alloc]init];
    }
    
    return instance;
}

- (UserInfoModel*)getUserInfo
{
    if (!userInfo) {
        userInfo = [[UserInfoModel alloc]init];
        NSString* userid = [defaults objectForKey:@"userid"] ;
        [DataInterface getUserInfo:userid withCompletionHandler:^(NSMutableDictionary *dict) {
           /*
            opercode:"0105",		//operCode为0105，客户端通过该字段确定事件
            statecode:"0200",		//StateCode取值：获取成功[0200],获取失败[其他]
            info:"获取成功",		//获取成功/失败!
            displayname:"张三",		//昵称
            phone:"1234",			//电话号码
            signature:"这个是签名...",	//签名
            title:"头衔",			//头衔职称
            degree:"教授",			//学位
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
            honours:"荣誉1，荣誉2",		//荣誉
            enterprises:"企业信息1，信息2",	//企业信息
            usertype:"0",			//0为普通用户
            gold:"1000",			//金币数量
            level:"1",			//用户级别
            configure:"a:0;b:1,c:2",	//客户端配置相关信息（需客户端人员协定之后定义公共设置信息）
            status:2			//0为正常用户，1为禁用用户，2为临时用户
            */
            
            userInfo.displayname = [dict valueForKey:@"displayname"];
            userInfo.signature = [dict valueForKey:@"signature"];
            userInfo.phone = [dict valueForKey:@"phone"];
            userInfo.title = [dict valueForKey:@"title"];
            userInfo.degree = [dict valueForKey:@"degree"];
            userInfo.address = [dict valueForKey:@"address"];
            userInfo.domicile = [dict valueForKey:@"domicile"];
            userInfo.introduce = [dict valueForKey:@"introduce"];
            userInfo.comname = [dict valueForKey:@"comname"];
            userInfo.comdesc = [dict valueForKey:@"comdesc"];
            userInfo.comaddress = [dict valueForKey:@"comaddress"];
            userInfo.comurl = [dict valueForKey:@"comurl"];
            userInfo.induname = [dict valueForKey:@"induname"];
            userInfo.indudesc = [dict valueForKey:@"indudesc"];
            userInfo.schoolname = [dict valueForKey:@"schoolname"];
            userInfo.schooltype = [dict valueForKey:@"schooltype"];
            userInfo.sex = [dict valueForKey:@"sex"];
            userInfo.photo = [dict valueForKey:@"photo"];
            userInfo.email = [dict valueForKey:@"email"];
            userInfo.tags = [dict valueForKey:@"tags"];
            userInfo.attentiontags = [dict valueForKey:@"attentiontags"];
            userInfo.hobbies = [dict valueForKey:@"hobbies"];
            userInfo.educations = [dict valueForKey:@"educations"];
            userInfo.honours = [dict valueForKey:@"honours"];
            userInfo.usertype = [dict valueForKey:@"usertype"];
            userInfo.gold = [dict valueForKey:@"gold"];
            userInfo.level = [dict valueForKey:@"level"];
            userInfo.configure = [dict valueForKey:@"configure"];
            userInfo.status = [dict valueForKey:@"status"];
            
            UIImageView *iconImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, minimumHeight, minimumHeight)];
//            [iconImage circular];
            [iconImage setImageWithURL:IMGURL(userInfo.photo) placeholderImage:[UIImage imageNamed:@"img_portrait96"]];
            userInfo.iconImageview = iconImage;
//            userInfo.enterprises = [dict valueForKey:@"enterprises"];
        }];
    }
    
    return userInfo;
}


/*通过id获取其他user信息*/
- (UserInfoModel*)getOtherUserInfo:(NSString*)userid
{
    UserInfoModel* uerinfo = nil;
    if (!uerArrayDic) {
        uerArrayDic = [[NSMutableDictionary alloc]init];
    }else{
      uerinfo = (UserInfoModel*)[uerArrayDic valueForKey:userid];
    }
    
    if (!userInfo) {
      /*如果没有则创建一个*/
        
    }
    return userInfo;
}
@end
