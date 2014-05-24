//
//  ShareToTribeViewController.h
//  QXH
//
//  Created by XueYong on 5/22/14.
//  Copyright (c) 2014 ZhaoLilong. All rights reserved.
//

#import "MyViewController.h"
typedef void (^ShareToTribeCallBlock)(NSDictionary *);

@interface ShareToTribeViewController : MyViewController
@property (nonatomic, copy) ShareToTribeCallBlock shareToTribeBlock;
@end
