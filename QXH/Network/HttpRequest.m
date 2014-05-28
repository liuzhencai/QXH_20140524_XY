//
//  HttpRequest.m
//  QXH
//
//  Created by ZhaoLilong on 14-5-12.
//  Copyright (c) 2014年 ZhaoLilong. All rights reserved.
//

#import "HttpRequest.h"
#import "HttpServiceEngine.h"

@implementation HttpRequest

+ (void)requestWithParams:(NSMutableDictionary *)params andCompletionHandler:(DictCallback)callback
{
    [[HttpServiceEngine sharedEngine] sendData:params andMethod:nil completionHandler:^(NSInteger statusCode, id object) {
        NSLog(@"back object:%@",object);
        if ([object objectForKey:@"0200"]) {
            callback(object);
        }else{
            callback(nil);
        }
    } errorHandler:^(NSError *error) {
        callback(nil);
    }];
}

@end
