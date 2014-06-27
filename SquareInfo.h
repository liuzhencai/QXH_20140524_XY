//
//  SqureInfo.h
//  
//
//  Created by ZhaoLilong on 14-6-22.
//  Copyright (c) 2014 suning. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "InfoModel.h"

@interface SquareInfo : NSObject

@property (nonatomic, strong) id content;

@property (nonatomic, copy) NSString *date;

@property (nonatomic, assign) NSInteger psid;

@property (nonatomic, copy) NSString *refsign;

@property (nonatomic, assign) NSInteger type;

@property (nonatomic, copy) NSString *uduty;

@property (nonatomic, assign) NSInteger uid;

@property (nonatomic, copy) NSString *uname;

@property (nonatomic, copy) NSString *uphoto;

@property (nonatomic, copy) NSString *usign;

@end
