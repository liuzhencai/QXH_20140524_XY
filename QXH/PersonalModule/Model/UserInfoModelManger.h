//
//  UserInfoModelManger.h
//  QXH
//
//  Created by liuzhencai on 14-6-10.
//  Copyright (c) 2014年 ZhaoLilong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserInfoModelManger : NSObject
{
    UserInfoModel* userInfo;
}

@property (nonatomic, retain)UserInfoModel* userInfo;

+(UserInfoModelManger*)sharUserInfoModelManger;

@end
