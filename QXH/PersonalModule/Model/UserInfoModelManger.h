//
//  UserInfoModelManger.h
//  QXH
//
//  Created by liuzhencai on 14-6-10.
//  Copyright (c) 2014年 ZhaoLilong. All rights reserved.
//

#import <Foundation/Foundation.h>

//typedef UserInfoModel* (^UserInfoModelCallback) (UserInfoModel *auserInfo);

@interface UserInfoModelManger : NSObject
{
    UserInfoModel* userInfo;
    
    /*储存其他联系人信息*/
    NSMutableDictionary* uerArrayDic;
}

@property (nonatomic, strong)UserInfoModel* userInfo;
@property (nonatomic, strong)NSMutableDictionary* uerArrayDic;

+(UserInfoModelManger*)sharUserInfoModelManger;

- (void)getUserInfo:(void (^)(UserInfoModel* Userinfo))backUserInfo;

///*通过id获取其他user信息*/
//- (void)getOtherUserInfo:(NSString*)userid;
- (void)getOtherUserInfo:(NSString *)userid withCompletionHandler:(UserInfoModel* (^) (UserInfoModel*))backUserinfo;


@end
