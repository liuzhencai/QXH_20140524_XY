//
//  EditUserInfoViewController.h
//  QXH
//
//  Created by xuey on 14-6-27.
//  Copyright (c) 2014年 ZhaoLilong. All rights reserved.
//

#import "MyViewController.h"

typedef enum {
    EditUserInfoTypeName,//姓名
    EditUserInfoTypeSignature,//签名
    EditUserInfoTypeWorkUnit,//工作单位
    EditUserInfoTypeCity,//城市
    EditUserInfoTypeDuty,//单位职务
    EditUserInfoTypeInterest,//兴趣爱好
    EditUserInfoTypeSchool,//毕业院校
    EditUserInfoTypePhone,//手机号码
    EditUserInfoTypeHonor//曾获荣誉
}EditUserInfoType;

typedef void (^EditUserInfoBlock) (id objt);

@interface EditUserInfoViewController : MyViewController

@property (nonatomic, assign) EditUserInfoType type;
@property (nonatomic, copy) EditUserInfoBlock editUserInfoCallBack;
@end
