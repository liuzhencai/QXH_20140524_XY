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
#import "AppDelegate.h"
#import "HomePageController.h"

@implementation HttpRequest

+ (void)reConnection
{
    AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    UINavigationController *nav = (UINavigationController *)[delegate.tabController.viewControllers objectAtIndex:0];
    HomePageController *controller = [nav.viewControllers objectAtIndex:0];
    [controller reConnection];
}

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
        /**
         *  udp心跳出错，重新连接
         */
        if ([[object objectForKey:@"statecode"] isEqualToString:@"0441"]) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示"
                                                            message:[object objectForKey:@"info"]
                                                           delegate:nil
                                                  cancelButtonTitle:@"确定"
                                                  otherButtonTitles:nil, nil];
            [alert show];
            callback(nil);
            [self reConnection];
            return;
        }
        callback(object);
    } errorHandler:^(NSError *error) {
        [self reConnection];
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

+ (void)uploadFiles:(NSArray *)files andType:(NSString *)type andCompletionBlock:(ListCallback)uploadComplete
{
    __block NSMutableArray *imageUrls = [[NSMutableArray alloc] initWithCapacity:1];
    __block NSInteger count = 0;
//        for (UIImage *tempImage in images) {
//            [self uploadImage:tempImage AndType:type andCompletionBlock:^(NSDictionary *dict) {
//                ++count;
//                if ([[dict objectForKey:@"error"] isEqual:[NSNull null]]) {
//                    NSLog(@"图片上传成功");
//                    [imageUrls addObject:[dict objectForKey:@"success"]];
//                } else {
//                    NSLog(@"error: %@", [dict objectForKey:@"error"]);
//                }
//                NSLog(@"count:%d,imagescount:%d",count, [images count]);
//                if (count == [images count]) {
//                    NSLog(@"图片上传完毕");
//                    uploadComplete(imageUrls);
//                }
//            }];
//        }
        dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0);
        dispatch_apply([files count], queue, ^(size_t index) {
            dispatch_async(queue, ^{
                [self uploadFile:files[index] type:type completionHandler:^(id data) {
                    ++count;
                    [imageUrls addObject:[data objectForKey:@"filename"]];
                    if (count == [files count]) {
                        NSLog(@"图片上传完毕");
                        uploadComplete(imageUrls);
                    }
                } errorHandler:^(NSString *desc) {
                    
                }];
            });
        });
}

@end
