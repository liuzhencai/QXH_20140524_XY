//
//  ActivityInfoModel.h
//  QXH
//
//  Created by 神州租车 on 14-5-27.
//  Copyright (c) 2014年 ZhaoLilong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ActivityInfoModel : NSObject

@property (nonatomic, strong) NSString *actid;//活动id
@property (nonatomic, strong) NSString *actname;//活动名称
@property (nonatomic, strong) NSString *photos;//头像
@property (nonatomic, strong) NSString *actimgs;//活动相关图片
@property (nonatomic, strong) NSString *actaddr;//活动地址
@property (nonatomic, strong) NSString *startoffaddr;//出发地点
@property (nonatomic, strong) NSString *maxcount;//最多人数
@property (nonatomic, strong) NSString *nowcount;//目前人数
@property (nonatomic, strong) NSString *tags;//不同标签之间用逗号隔开
@property (nonatomic, strong) NSString *desc;//活动描述,简介
@property (nonatomic, strong) NSString *signupbegindate;//报名起始日期
@property (nonatomic, strong) NSString *signupenddate;//报名截止日期
@property (nonatomic, strong) NSString *actdate;//活动时间
@property (nonatomic, strong) NSString *district;//地域信息
@property (nonatomic, strong) NSString *condition;//加入条件

@end
