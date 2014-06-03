//
//  SignGenerator.h
//  QXH
//
//  Created by ZhaoLilong on 6/3/14.
//  Copyright (c) 2014 ZhaoLilong. All rights reserved.
//

#import <Foundation/Foundation.h>

#define POSSIBLE_CHARS @"0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ"

#define SIGN_LEN 8

@interface SignGenerator : NSObject

+ (NSString *)getSign;

@end
