//
//  HttpRequest.m
//  QXH
//
//  Created by ZhaoLilong on 14-5-12.
//  Copyright (c) 2014年 ZhaoLilong. All rights reserved.
//

#import "HttpRequest.h"
#import "HttpServiceEngine.h"
#import "Base64.h"

@implementation HttpRequest

+ (void)requestWithParams:(NSDictionary *)params andCompletionHandler:(DictCallback)callback
{
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:params
                                                       options:NSJSONWritingPrettyPrinted
                                                         error:nil];
    NSString *json = [[NSString alloc] initWithData:jsonData
                                           encoding:NSUTF8StringEncoding];
    NSString *base64Str = [Base64 encodeBase64String:json];
    NSDictionary *param = @{@"reqMess": base64Str};
    [[HttpServiceEngine sharedEngine] sendData:param andMethod:nil completionHandler:^(NSInteger statusCode, id object) {
        if ([[object objectForKey:@"statecode"] isEqualToString:@"0200"]) {
            callback(object);
        }else{
            callback(nil);
        }
    } errorHandler:^(NSError *error) {
        callback(nil);
    }];
}

@end
