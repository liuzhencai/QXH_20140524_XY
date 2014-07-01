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
    
    /*储存其他联系人信息*/
    NSMutableDictionary* uerArrayDic;
}

@property (nonatomic, retain)UserInfoModel* userInfo;

+(UserInfoModelManger*)sharUserInfoModelManger;

- (UserInfoModel*)getUserInfo;

/*通过id获取其他user信息*/
- (UserInfoModel*)getOtherUserInfo:(NSString*)userid;
@end
