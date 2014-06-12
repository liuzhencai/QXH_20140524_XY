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
        userInfo = [[UserInfoModel alloc]init];
    }
    return self;
}

+(UserInfoModelManger*)sharUserInfoModelManger
{
    if (instance) {
        instance = [[UserInfoModelManger alloc]init];
    }
    
    return instance;
}


@end
