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
@synthesize saveArray,oldSign;

- (void)setupSocket
{
    static dispatch_queue_t myUdpQueue;
    if (!myUdpQueue) {
        myUdpQueue = dispatch_queue_create("com.qxh.udp", DISPATCH_QUEUE_CONCURRENT);
    }
	_udpSocket = [[GCDAsyncUdpSocket alloc] initWithDelegate:self delegateQueue:myUdpQueue];

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

- (void)forceClose
{
    [_udpSocket close];
    _udpSocket = nil;
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
        DebugLog(@"lzc接受到系统消息==%@",returnValue);
    if (returnValue) {
        if ([[returnValue objectForKey:@"opercode"] isEqualToString:@"0131"]) {
//            static NSString *oldSign;
            NSString *newSign = [returnValue objectForKey:@"sign"];
//            if (![self.oldSign isEqualToString:newSign]) {
//                 self.oldSign = newSign;
                if (!saveArray) {
                    saveArray = [[NSMutableArray alloc]init];
                }
                BOOL state = NO;
                for (int i=0; i<[saveArray count]; i++) {
                    NSDictionary* obj = [saveArray objectAtIndex:i];
                    if ([newSign isEqualToString:[obj objectForKey:@"sign"] ]) {
                        state = YES;
                        break;
                    }
                }
                
                if (!state) {
                    [self.saveArray addObject:returnValue];
                    NSLog(@"抛回主线程");
                    /*抛回主线程*/
                    [self performSelectorOnMainThread:@selector(updateViewOnMainThread) withObject:nil waitUntilDone:YES];
                }
//            }
           
        }
    }
    
    self.block(data);
}

- (void)updateViewOnMainThread{
   
    for (int i=0; i<[self.saveArray count]; i++) {
        NSLog(@"updateViewOnMainThread");
        NSMutableDictionary* obj = [[NSMutableDictionary alloc]initWithDictionary:[self.saveArray objectAtIndex:i]];
        [obj setValue:[NSString stringWithFormat:@"%d",[self.saveArray count]] forKey:@"MessageCountLiu"];
        /*在主线程中执行刷新*/
        [[NSNotificationCenter defaultCenter] postNotificationName:@"recvMsg" object:nil userInfo:obj];
    }
    [self.saveArray removeAllObjects];
 
}
@end
