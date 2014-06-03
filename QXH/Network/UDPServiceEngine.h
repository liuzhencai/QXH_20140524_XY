//
//  UDPServiceEngine.h
//  QXH
//
//  Created by ZhaoLilong on 6/3/14.
//  Copyright (c) 2014 ZhaoLilong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UDPRequest.h"

#define SEND_TIMES 4

@interface UDPServiceEngine : NSObject

/**
 *  udp服务引擎单例
 *
 *  @return 返回udp服务引擎
 */
+ (UDPServiceEngine *)sharedEngine;

/**
 *  移除指定签名
 *
 *  @param sign 签名
 */
- (void)removeSign:(NSString *)sign;

/**
 *  移除所有签名
 */
- (void)removeAllSign;

/**
 *  发送udp报文
 *
 *  @param param    发送参数
 *  @param callback 回调
 */
- (void)sendData:(NSDictionary *)param withCompletionHandler:(Completion)callback;

@end
