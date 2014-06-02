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

@interface ModelGenerator : NSObject

+ (UserInfoModel *)json2UserInfo:(NSDictionary *)obj;

+ (NSMutableArray *)json2InfoList:(NSDictionary *)obj;

@end
