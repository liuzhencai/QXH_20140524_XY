//
//  ModelGenerator.h
//  QXH
//
//  Created by ZhaoLilong on 5/26/14.
//  Copyright (c) 2014 ZhaoLilong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UserInfoModel.h"
#import "InfoModel.h"
#import "InfoDetailModel.h"

@interface ModelGenerator : NSObject

/**
 *  json转换为用户信息
 *
 *  @param obj 传入参数
 *
 *  @return 返回用户信息模型
 */
+ (UserInfoModel *)json2UserInfo:(NSDictionary *)obj;

/**
 *  json转换为资讯列表
 *
 *  @param obj 传入参数
 *
 *  @return 返回资讯列表
 */
+ (NSMutableArray *)json2InfoList:(NSDictionary *)obj;

/**
 *  json转换为资讯详细信息
 *
 *  @param obj 传入参数
 *
 *  @return 返回资讯详细信息
 */
+ (InfoDetailModel *)json2InfoDetail:(NSDictionary *)obj;

@end
