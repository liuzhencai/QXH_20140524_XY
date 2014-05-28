//
//  UDPRequest.m
//  QXH
//
//  Created by ZhaoLilong on 5/28/14.
//  Copyright (c) 2014 ZhaoLilong. All rights reserved.
//

#import "UDPRequest.h"

static GCDAsyncUdpSocket *udpSocket;

@implementation UDPRequest

SYNTHESIZE_SINGLETON_FOR_CLASS(UDPRequest);

- (id)init
{
    self = [super init];
    if (self) {
        udpSocket = [[GCDAsyncUdpSocket alloc] initWithDelegate:self delegateQueue:dispatch_get_main_queue()];
    }
    return self;
}

- (void)send:(NSDictionary *)params
{
//    NSData *data = [msg dataUsingEncoding:NSUTF8StringEncoding];
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:params
                                                       options:NSJSONWritingPrettyPrinted
                                                         error:nil];
    NSData *data = [GTMBase64 encodeData:jsonData];
	[udpSocket sendData:data toHost:SOCKET_SERVER port:SOCKET_PORT withTimeout:-1 tag:tag];
}

- (void)udpSocket:(GCDAsyncUdpSocket *)sock didSendDataWithTag:(long)tag
{
	// You could add checks here
}

- (void)udpSocket:(GCDAsyncUdpSocket *)sock didNotSendDataWithTag:(long)tag dueToError:(NSError *)error
{
	// You could add checks here
}

- (void)udpSocket:(GCDAsyncUdpSocket *)sock didReceiveData:(NSData *)data
      fromAddress:(NSData *)address
withFilterContext:(id)filterContext
{
	NSString *msg = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
	if (msg)
	{
		NSLog(@"RECV: %@", [Base64 decodeBase64String:msg]);
	}
	else
	{
		NSString *host = nil;
		uint16_t port = 0;
		[GCDAsyncUdpSocket getHost:&host port:&port fromAddress:address];
		
		NSLog(@"RECV: Unknown message from: %@:%hu", host, port);
	}
}

@end
