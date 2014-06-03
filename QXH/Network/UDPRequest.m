//
//  UDPRequest.m
//  QXH
//
//  Created by ZhaoLilong on 5/28/14.
//  Copyright (c) 2014 ZhaoLilong. All rights reserved.
//

#import "UDPRequest.h"

static UDPRequest *udpRequest;

@interface UDPRequest ()
{
    GCDAsyncUdpSocket *udpSocket;
}
@end

@implementation UDPRequest

- (void)setupSocket
{
	udpSocket = [[GCDAsyncUdpSocket alloc] initWithDelegate:self delegateQueue:dispatch_get_main_queue()];
	
	NSError *error = nil;
	
	if (![udpSocket bindToPort:0 error:&error])
	{
		return;
	}
	if (![udpSocket beginReceiving:&error])
	{
		return;
	}
}

- (id)init
{
    self = [super init];
    if (self) {
       	if (udpSocket == nil)
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
	[udpSocket sendData:data toHost:SOCKET_SERVER port:SOCKET_PORT withTimeout:-1 tag:tag];
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

- (void)udpSocket:(GCDAsyncUdpSocket *)sock didReceiveData:(NSData *)data
      fromAddress:(NSData *)address
withFilterContext:(id)filterContext
{
    self.block(data);
}

@end
