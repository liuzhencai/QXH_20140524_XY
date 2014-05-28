//
//  HttpServiceEngine.m
//  QXH
//
//  Created by ZhaoLilong on 13-9-11.
//  Copyright (c) 2013年 ZhaoLilong. All rights reserved.
//

#import "HttpServiceEngine.h"
#import "Public.h"

@implementation HttpServiceEngine

static HttpServiceEngine *httpEngine;

+ (HttpServiceEngine *)sharedEngine{
    @synchronized(self){
        if (!httpEngine) {
            httpEngine = [[HttpServiceEngine alloc] initHost];
        }
        return httpEngine;
    }
}

- (id)initHost{
    if(self = [super initWithHostName:HOST_URL customHeaderFields:@{@"Content-Type" : @"application/json"}]) {
        
    }
    return self;
}

- (NSString *)mergeUrl:(NSString *)url andParams:(NSDictionary *)params{
    NSMutableString *path = [NSMutableString string];
    [path appendFormat:@"%@?",url];
    for (NSString *key in params) {
        [path appendFormat:@"%@=%@&",key, [[params valueForKey:key] mk_urlEncodedString]];
    }
    [path deleteCharactersInRange:NSMakeRange([path length]-1, 1)];
    return path;
}

- (BOOL)isJPEGValid:(NSData*)jpeg

{
    if([jpeg length] < 4)
    {
        return NO;
    }
    
    const char* bytes = (const char*)[jpeg bytes];
    
    if(bytes[0] != 0xFF|| bytes[1] != 0xD8)
    {
        return NO;
    }
    
    if(bytes[[jpeg length] - 2] != 0xFF|| bytes[[jpeg length] - 1] != 0xD9)
    {
        return NO;
    }

    return YES;
}

-(void) downloadFileFrom:(NSString *) remoteURL toFile:(NSString*) filePath progressHandler:(DownloadProgressBlock)downloadProgress completionHandler:(DataProcessBlock)completionBlock errorHandler:(MKNKErrorBlock) errorBlock
{
    __block __weak MKNetworkOperation *op = nil;
    op = [self operationWithURLString:remoteURL];
    [op addDownloadStream:[NSOutputStream outputStreamToFileAtPath:filePath
                                                            append:YES]];
    [op onDownloadProgressChanged:^(double progress) {
        downloadProgress(progress);
        if (progress == 1.0) {
            NSString *destFilePath = [MR_CACHE_PATH stringByAppendingPathComponent:[[filePath componentsSeparatedByString:@"/"] lastObject]];
            NSError *error = nil;
            NSData *data;
            data = [NSData dataWithContentsOfFile:destFilePath];
            if([[NSFileManager defaultManager] copyItemAtPath:filePath toPath:destFilePath error:&error]){
                [[NSFileManager defaultManager] removeItemAtPath:filePath error:&error];
            }
            [op addCompletionHandler:^(MKNetworkOperation *completedOperation) {
                completionBlock(op.HTTPStatusCode,[completedOperation responseData]);
            } errorHandler:^(MKNetworkOperation *errorOp, NSError* error) {
                errorBlock(error);
            }];
        }
    }];
    [self enqueueOperation:op];
}

-(void) uploadImage:(UIImage *) image
            andType:(NSInteger)type
  completionHandler:(DataProcessBlock) completionBlock
       errorHandler:(MKNKErrorBlock) errorBlock
{
    __block __weak MKNetworkOperation *op = nil;
    op = [self operationWithPath:IMAGE_UPLOAD_URL
                          params:[NSDictionary dictionaryWithObject:[NSString stringWithFormat:@"%d",type] forKey:@"type"]
                      httpMethod:@"POST"];
    [op addData:UIImageJPEGRepresentation(image, 0.9) forKey:@"pic" mimeType:@"image/jpeg" fileName:@".jpg"];
    // setFreezable uploads your images after connection is restored!
    [op setFreezable:YES];
    
    [op addCompletionHandler:^(MKNetworkOperation* completedOperation) {
        [completedOperation responseJSONWithCompletionHandler:^(id jsonObject) {
            completionBlock(op.HTTPStatusCode,jsonObject);
            /* error  字典(图片铃声上传接口共用)：
             *      1:图片类型参数type不可为空
             *      2:图片类型错误
             *      3:不允许上传此类型的文件，只允许JPG和JPEG格式
             *      4:上传文件不能为空
             *      5:上传文件的大小超出限制，不能大于3M
             *      6:不允许上传此类型的文件，只允许MP3格式
             *      7:上传文件的大小超出限制，不能大于500K
             */
        }];
    }errorHandler:^(MKNetworkOperation *errorOp, NSError* error) {
        errorBlock(error);
    }];
    [self enqueueOperation:op];
}

- (void)uploadImages:(NSArray *)images
             andType:(NSInteger)type
    completionHander:(DataProcessBlock)completionBlock
        errorHandler:(MKNKErrorBlock)errorBlock
{
    __block __weak MKNetworkOperation *op = nil;
    op = [self operationWithPath:IMAGE_UPLOAD_URL
                          params:[NSDictionary dictionaryWithObject:[NSString stringWithFormat:@"%d",type] forKey:@"type"]
                      httpMethod:@"POST"];
    for (UIImage *image in images) {
        [op addData:UIImageJPEGRepresentation(image, 0.9) forKey:@"pic" mimeType:@"image/jpeg" fileName:@".jpg"];
    }
    // setFreezable uploads your images after connection is restored!
    [op setFreezable:YES];
    
    [op addCompletionHandler:^(MKNetworkOperation* completedOperation) {
        [completedOperation responseJSONWithCompletionHandler:^(id jsonObject) {
            completionBlock(op.HTTPStatusCode,jsonObject);
            /* error  字典(图片铃声上传接口共用)：
             *      1:图片类型参数type不可为空
             *      2:图片类型错误
             *      3:不允许上传此类型的文件，只允许JPG和JPEG格式
             *      4:上传文件不能为空
             *      5:上传文件的大小超出限制，不能大于3M
             *      6:不允许上传此类型的文件，只允许MP3格式
             *      7:上传文件的大小超出限制，不能大于500K
             */
        }];
    }errorHandler:^(MKNetworkOperation *errorOp, NSError* error) {
        errorBlock(error);
    }];
    [self enqueueOperation:op];

}

- (void)sendData:(NSDictionary *)params andMethod:(NSString *)method completionHandler:(DataProcessBlock)dataProcess errorHandler:(MKNKErrorBlock) errorBlock
{
    __block __weak MKNetworkOperation *op = nil;
    if (params == nil) {
        //        op = [self operationWithPath:[url mk_urlEncodedString] params:params httpMethod:method];
        op = [self operationWithPath:SERVICE_URL params:params httpMethod:method];
    }else{
        if ([method isEqualToString:@"GET"]) {
            op = [self operationWithPath:[self mergeUrl:SERVICE_URL andParams:params]];
        }else{
            //            op = [self operationWithPath:[url mk_urlEncodedString] params:params httpMethod:method];
            op = [self operationWithPath:SERVICE_URL params:params httpMethod:method];
        }
    }
    [op addCompletionHandler:^(MKNetworkOperation *completedOperation) {
        [completedOperation responseJSONWithCompletionHandler:^(id jsonObject) {
            dataProcess(op.HTTPStatusCode,jsonObject);
        }];
    } errorHandler:^(MKNetworkOperation *errorOp, NSError* error) {
        errorBlock(error);
    }];
    
    [self enqueueOperation:op];
}

+ (NSString *)jsonSerilizationWithObject:(id)obj
{
    NSString *jsonStr;
    if ([NSJSONSerialization isValidJSONObject:obj]) {
        NSError *error;
        NSData *data = [NSJSONSerialization dataWithJSONObject:obj options:NSJSONWritingPrettyPrinted error:&error];
        jsonStr = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    }
    return jsonStr;
}

//- (void)setAPICustomHeaders:(ApiHeaderInfoModel *)hiModel
//{
//    NSMutableDictionary *headers = [[NSMutableDictionary alloc] init];
//    if (hiModel.devid) {
//        [headers setValue:hiModel.devid forKey:@"devid"];
//    }
//    if (hiModel.userId) {
//        [headers setValue:hiModel.userId forKey:@"userId"];
//    }
//    [super setCustomHeaders:headers];
//}

@end
