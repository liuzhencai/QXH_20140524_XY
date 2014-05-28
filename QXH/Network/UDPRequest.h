//
//  UDPRequest.h
//  QXH
//
//  Created by ZhaoLilong on 5/28/14.
//  Copyright (c) 2014 ZhaoLilong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GCDAsyncUdpSocket.h"

@interface UDPRequest : NSObject
{
    long tag;
}

+ (UDPRequest *)sharedUDPRequest;

- (void)send:(NSDictionary *)params;

@end
