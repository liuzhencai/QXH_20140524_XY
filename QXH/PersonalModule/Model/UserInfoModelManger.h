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
    
    /*获取到的图片*/
    UIImage* Iconimage;
    
    /*根据id，存储获取到的头像的image*/
    NSMutableDictionary* headArrayDic;
    /*我的userid*/
    NSString* MeUserId;
}

@property (nonatomic, strong)UserInfoModel* userInfo;
@property (nonatomic, strong)UIImage* Iconimage;
@property (nonatomic, strong)NSString* MeUserId;
@property (nonatomic, strong)NSMutableDictionary* uerArrayDic;

+(UserInfoModelManger*)sharUserInfoModelManger;

- (void)getUserInfo:(void (^)(UserInfoModel* Userinfo))backUserInfo;
- (UserInfoModel*)getMe;

///*通过id获取其他user信息*/
//- (void)getOtherUserInfo:(NSString*)userid;
- (void)getOtherUserInfo:(NSString *)userid withCompletionHandler:(UserInfoModel* (^) (UserInfoModel*))backUserinfo;

- (UIImage*)getIcon:(NSString*)photo;
///*通过id，查看本地是否已经存储图片，如果已经存储，则取本地的*/
- (UIImage*)getImageByLocalId:(NSString*)userid;
@end
