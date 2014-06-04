//
//  UDPServiceEngine.m
//  QXH
//
//  Created by ZhaoLilong on 6/3/14.
//  Copyright (c) 2014 ZhaoLilong. All rights reserved.
//

#import "UDPServiceEngine.h"
#import "UDPRequest.h"
#import "JSONKit.h"

@interface UDPServiceEngine ()
{
    UDPRequest *udp;
    NSMutableArray *signs;
}

@end

@implementation UDPServiceEngine

+ (UDPServiceEngine *)sharedEngine
{
    static UDPServiceEngine *engine = nil;
    
    static dispatch_once_t predicate; dispatch_once(&predicate, ^{
        engine = [[self alloc] init];
    });
    
    return engine;
}

- (id)init
{
    self = [super init];
    if (self) {
        udp = [[UDPRequest alloc] init];
        signs = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)sendData:(NSDictionary *)param withCompletionHandler:(Completion)callback andErrorHandler:(Completion)error
{
    NSString *sign = [param objectForKey:@"sign"];
    if ([signs containsObject:sign]) {
        // 当签名队列总数超出80时，移除第一个队列签名
        if ([signs count] > 80) {
            [signs removeObjectAtIndex:0];
        }
        [signs addObject:sign];
    }
    
    if ([[param objectForKey:@"opercode"] isEqualToString:@"0102"]) {
        // 登陆只发送一次
        [udp send:param];
    }else{
        dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
        dispatch_apply(SEND_TIMES, queue, ^(size_t index) {
            [udp send:param];
        });
    }

    __block BOOL isSuccess = NO;
    __block NSUInteger failtimes = 0;
    udp.block = ^(NSData *data){
        id returnValue = nil;
        if (!isSuccess) {
            JSONDecoder *jd = [[JSONDecoder alloc] initWithParseOptions:JKParseOptionPermitTextAfterValidJSON];
            returnValue = [jd objectWithData:[GTMBase64 decodeData:data]];
            if ([[returnValue objectForKey:@"statecode"] isEqualToString:@"0200"]) {
                isSuccess = YES;
                callback(returnValue);
            }else{
                ++failtimes;
            }
        }
        if (failtimes == 4) {
            error([returnValue objectForKey:@"info"]);
        }
    };
}

- (void)removeSignAtIndex:(NSUInteger)index
{
    [signs removeObjectAtIndex:index];
}

- (void)removeSign:(NSString *)sign
{
    [signs removeObject:sign];
}

- (void)removeAllSign
{
    [signs removeAllObjects];
}

@end
