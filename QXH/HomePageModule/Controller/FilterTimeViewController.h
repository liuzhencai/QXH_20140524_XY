//
//  FilterTimeViewController.h
//  QXH
//
//  Created by XueYong on 5/17/14.
//  Copyright (c) 2014 ZhaoLilong. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void (^FilterTimeBlock)(id object);
@interface FilterTimeViewController : MyViewController
@property (nonatomic, copy) FilterTimeBlock filterTimeCallBack;
@end
