//
//  TribeInfoModel.h
//  QXH
//
//  Created by 神州租车 on 14-5-27.
//  Copyright (c) 2014年 ZhaoLilong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TribeInfoModel : NSObject

@property (nonatomic, strong) NSString *tribeid;//部落id
@property (nonatomic, strong) NSString *tribename;//部落名称
@property (nonatomic, strong) NSString *photo;//头像
@property (nonatomic, strong) NSString *signature;//签名
@property (nonatomic, strong) NSString *creater;//创建人id
@property (nonatomic, strong) NSString *creatername;//创建人name

@property (nonatomic, strong) NSString *desc;//描述
@property (nonatomic, strong) NSString *condition;//加入条件
@property (nonatomic, strong) NSString *purpose;//宗旨
@property (nonatomic, strong) NSString *tags;//不同标签之间用逗号隔开(@"标签，标签,...")
@property (nonatomic, strong) NSString *district;//地域信息

@property (nonatomic, strong) NSString *rule;//章程
@property (nonatomic, assign) NSInteger maxcount;//最多人数
@property (nonatomic, strong) NSString *members;//部落成员(@"123,456,789")

@end
