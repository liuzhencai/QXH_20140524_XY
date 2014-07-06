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
#import "MyTribeModel.h"
#import "VistorModel.h"
#import "InfoCommentModel.h"
#import "SquareInfo.h"
#import "ActivityInfoModel.h"
#import "SquareActInfo.h"
#import "CodeSheetObject.h"
#import "AskInfoModel.h"

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

/**
 *  json转换为部落列表
 *
 *  @param obj 传入参数
 *
 *  @return 返回部落列表
 */
+ (NSMutableArray *)json2TribeList:(NSDictionary *)obj;

/**
 *  json转换为访客列表
 *
 *  @param obj 传入参数
 *
 *  @return 返回访客列表
 */
+ (NSMutableArray *)json2VistorList:(NSDictionary *)obj;

/**
 *  json转换为评论列表
 *
 *  @param obj 传入参数
 *
 *  @return 返回评论列表
 */
+ (NSMutableArray *)json2CommentList:(NSDictionary *)obj;

/**
 *  json转换为广场列表
 *
 *  @param obj 传入参数
 *
 *  @return 返回广场列表
 */
+ (NSMutableArray *)json2SquareList:(NSDictionary *)obj;

/**
 *  json转换为码表
 *
 *  @param obj 传入参数
 *
 *  @return 返回码表列表
 */
+ (NSMutableArray *)json2CodeSheet:(NSDictionary *)obj;

/**
 *  json转换为问道
 *
 *  @param obj 传入参数
 *
 *  @return 返回问道对象
 */
+ (NSMutableArray *)json2AskInfo:(NSDictionary *)obj;

@end
