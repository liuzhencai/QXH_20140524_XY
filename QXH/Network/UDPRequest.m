//
//  UDPRequest.m
//  QXH
//
//  Created by ZhaoLilong on 5/28/14.
//  Copyright (c) 2014 ZhaoLilong. All rights reserved.
//

#import "UDPRequest.h"
#import "JSONKit.h"

static UDPRequest *udpRequest;

@interface UDPRequest ()
@property (nonatomic, strong) GCDAsyncUdpSocket *udpSocket;
@end

@implementation UDPRequest

- (void)setupSocket
{
	_udpSocket = [[GCDAsyncUdpSocket alloc] initWithDelegate:self delegateQueue:dispatch_get_main_queue()];

    NSError *error;
    /**
     *  绑定端口
     */
    if (![_udpSocket bindToPort:SOCKET_PORT error:&error])
	{
		return;
	}
    
    // 发送广播设置
//  BOOL result =   [_udpSocket enableBroadcast:YES error:&error];
    
    if (![_udpSocket joinMulticastGroup:SOCKET_SERVER error:&error])
    {
        NSLog(@"开启组播失败--->%@",[error description]);
    }
    
	if (![_udpSocket beginReceiving:&error])
	{
		return;
	}

}

- (id)init
{
    self = [super init];
    if (self) {
       	if (_udpSocket == nil)
        {
            [self setupSocket];
        }
    }
    return self;
}

- (void)send:(NSDictionary *)params
{
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:params
                                                       options:NSJSONWritingPrettyPrinted
                                                         error:nil];
    NSData *data = [GTMBase64 encodeData:jsonData];
	[_udpSocket sendData:data toHost:SOCKET_SERVER port:SOCKET_PORT withTimeout:-1 tag:tag];
    tag++;
}

- (void)udpSocket:(GCDAsyncUdpSocket *)sock didSendDataWithTag:(long)tag
{
	// You could add checks here
}

- (void)udpSocket:(GCDAsyncUdpSocket *)sock didNotSendDataWithTag:(long)tag dueToError:(NSError *)error
{
	// You could add checks here
}

- (void)udpSocket:(GCDAsyncUdpSocket *)sock
   didReceiveData:(NSData *)data
      fromAddress:(NSData *)address
withFilterContext:(id)filterContext
{
//    BOOL isSuccess = NO;
    id returnValue = nil;
//    if (!isSuccess) {
        JSONDecoder *jd = [[JSONDecoder alloc] initWithParseOptions:JKParseOptionPermitTextAfterValidJSON];
        returnValue = [jd objectWithData:[GTMBase64 decodeData:data]];
//        DebugLog(@"接受到系统消息==%@",returnValue);
        if (returnValue) {
//            isSuccess = YES;
            if ([[returnValue objectForKey:@"opercode"] isEqualToString:@"0131"]) {
                static NSString *oldSign;
                NSString *newSign = [returnValue objectForKey:@"sign"];
                if (![oldSign isEqualToString:newSign]) {
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"recvMsg" object:nil userInfo:returnValue];
                }
                oldSign = [returnValue objectForKey:@"sign"];
            }
        }
//    }
    self.block(data);
}

@end
