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

+ (void)uploadFile:(id)file
              type:(NSString *)type
 completionHandler:(Completion)completionBlock
      errorHandler:(DescriptionBlock)errorBlock
{
    NSData *data = nil;
    NSString *fileName = nil;
    if ([file isKindOfClass:[UIImage class]]) {
        // 对图片进行压缩处理
        data = UIImageJPEGRepresentation(file, 0.5);
        fileName = [NSString stringWithFormat:@"%ld.png", (long)[[NSDate date] timeIntervalSince1970]];
    }else if([file isKindOfClass:[NSString class]]){
        data = [NSData dataWithContentsOfFile:file];
        NSString *fileFullName = [(NSString *)file lastPathComponent];
        NSString *fileNameSuffix = nil;
        if ([fileFullName rangeOfString:@"."].location != NSNotFound) {
            fileNameSuffix = [[fileFullName componentsSeparatedByString:@"."] lastObject];
        }
        if (!fileNameSuffix) {
            NSAssert(NO, @"上传文件缺少扩展名!");
        }
        fileName = [NSString stringWithFormat:@"%ld.%@", (long)[[NSDate date] timeIntervalSince1970], fileNameSuffix];
    }else{
        NSAssert(NO, @"上传文件参数类型错误!");
    }
    [[HttpServiceEngine sharedEngine] uploadFile:data filename:fileName type:type completionHandler:^(NSInteger statusCode, id object) {
        if ([[object objectForKey:@"statecode"] isEqualToString:@"0200"]) {
            completionBlock(object);
        }else{
            errorBlock([object objectForKey:@"info"]);
        }
    } errorHandler:^(NSError *error) {
        errorBlock([error description]);
    }];
}

@end
