//
//  HttpServiceEngine.h
//  QXH
//
//  Created by ZhaoLilong on 13-9-11.
//  Copyright (c) 2013年 ZhaoLilong. All rights reserved.
//

#import "MKNetworkEngine.h"
#import "MBProgressHUD.h"

/**
 *  数据处理回调block
 *
 *  @param statusCode HTTP状态码
 *  @param object     返回数据
 *
 *  @return 无返回值
 */
typedef void (^DataProcessBlock)(NSInteger statusCode, id object);

typedef void (^DownloadProgressBlock)(double progress);

@interface HttpServiceEngine : MKNetworkEngine
{
    MBProgressHUD *progressHUD;
}

/**
 *  单例实现方法
 *
 *  @return 返回网络服务单例
 */
+ (HttpServiceEngine *)sharedEngine;

/**
 *  初始化主机
 *
 *  @return 返回本身
 */
- (id)initHost;

/**
 *  发送数据
 *
 *  @param method      方法：GET/POST
 *  @param params      参数
 *  @param dataProcess 完成回调
 *  @param errorBlock  错误回调
 */
- (void)sendData:(NSDictionary *)params
       andMethod:(NSString *)method
completionHandler:(DataProcessBlock)dataProcess
    errorHandler:(MKNKErrorBlock) errorBlock;

/**
 *  上传文件
 *
 *  @param data            文件数据
 *  @param filename        文件名
 *  @param type            文件类型
 *  @param completionBlock 完成回调
 *  @param errorBlock      错误回调
 */
- (void)uploadFile:(NSData *)data
          filename:(NSString *)filename
              type:(NSString *)type
 completionHandler:(DataProcessBlock) completionBlock
      errorHandler:(MKNKErrorBlock) errorBlock;

/**
 *  根据url下载文件
 *
 *  @param remoteURL       文件url
 *  @param filePath        文件存储路径
 *  @param completionBlock 完成回调
 *  @param errorBlock   错误回调
 */
-(void) downloadFileFrom:(NSString *) remoteURL
                  toFile:(NSString*)
filePath progressHandler:(DownloadProgressBlock)downloadProgress
       completionHandler:(DataProcessBlock)completionBlock
            errorHandler:(MKNKErrorBlock) errorBlock;

/**
 *  对象json序列化
 *
 *  @param obj 对象
 *
 *  @return 序列化json串
 */
+ (NSString *)jsonSerilizationWithObject:(id)obj;

/**
 *  设置HTTP请求头
 *
 *  @param hiModel 请求头模型对象
 */
//- (void)setAPICustomHeaders:(ApiHeaderInfoModel *)hiModel;

@end
