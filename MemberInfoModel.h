//
//  MemberInfoModel.h
//  QXH
//
//  Created by 神州租车 on 14-5-27.
//  Copyright (c) 2014年 ZhaoLilong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MemberInfoModel : NSObject

@property (nonatomic, strong) NSString *userid;//成员id
@property (nonatomic, strong) NSString *username;//成员名称
@property (nonatomic, strong) NSString *photo;//头像
@property (nonatomic, strong) NSString *displayname;//昵称
@property (nonatomic, strong) NSString *signature;//签名
@property (nonatomic, strong) NSString *remark;//备注
@property (nonatomic, strong) NSString *usertype;//用户类型
@property (nonatomic, strong) NSString *level;//用户级别

@end
