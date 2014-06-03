//
//  SignGenerator.m
//  QXH
//
//  Created by ZhaoLilong on 6/3/14.
//  Copyright (c) 2014 ZhaoLilong. All rights reserved.
//

#import "SignGenerator.h"

@implementation SignGenerator

+ (NSString *)getSign
{
    NSMutableString *sign = [[NSMutableString alloc] init];
    for (int i = 0; i < SIGN_LEN; i++) {
        [sign appendString:[POSSIBLE_CHARS substringWithRange:NSMakeRange(arc4random()%62, 1)]];
    }
    return sign;
}

@end
