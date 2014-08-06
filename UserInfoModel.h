//
//  UserInfoModel.h
//  QXH
//
//  Created by ZhaoLilong on 5/26/14.
//  Copyright (c) 2014 ZhaoLilong. All rights reserved.
//


#import <Foundation/Foundation.h>



@interface UserInfoModel : NSObject

@property (nonatomic, copy) NSString *displayname; // 昵称

@property (nonatomic, copy) NSString *signature; // 签名

@property (nonatomic, copy) NSString *title; // 头衔

@property (nonatomic, copy) NSString *address; // 籍贯编码

@property (nonatomic, copy) NSString *domicile; // 居住地编码

@property (nonatomic, copy) NSString *introduce; // 自我介绍

@property (nonatomic, copy) NSString *comname;  // 公司名称

@property (nonatomic, copy) NSString *comdesc;   // 公司描述

@property (nonatomic, copy) NSString *comaddress; // 公司地址

@property (nonatomic, copy) NSString *comurl;   // 公司网址

@property (nonatomic, copy) NSString *induname; // 行业名称

@property (nonatomic, copy) NSString *indudesc; // 行业描述

@property (nonatomic, copy) NSString *schoolname; // 学校名称

@property (nonatomic, copy) NSString *schooltype; // 学校类型

@property (nonatomic, copy) NSString *sex; // 0为保密，1为男，2为女

@property (nonatomic, copy) NSString *photo; // 头像

@property (nonatomic, copy) NSString *email; // 用户邮箱

@property (nonatomic, copy) NSString *tags; // 用户标签

@property (nonatomic, copy) NSString *attentiontags; // 关注标签

@property (nonatomic, copy) NSString *hobbies; // 爱好

@property (nonatomic, copy) NSString *educations; // 教育经历

@property (nonatomic, copy) NSString *usertype; // 0为普通用户

@property (nonatomic, copy) NSString *gold;  // 金币数量

@property (nonatomic, copy) NSString *level; // 用户级别

@property (nonatomic, copy) NSString *configure; // 客户端配置相关信息

@property (nonatomic, copy) NSString *status; // 0为正常用户，1为禁用用户，2为临时用户
@property (nonatomic,strong) UIImageView* iconImageview;//用户头像
@property (nonatomic,copy) NSString* phone;//电话号码
@property (nonatomic,copy) NSString* degree;//学位
@property (nonatomic,copy) NSString* honours;//贡献
@end
