//
//  SelectCityViewController.h
//  QXH
//
//  Created by XueYong on 7/8/14.
//  Copyright (c) 2014 ZhaoLilong. All rights reserved.
//

#import "MyViewController.h"
typedef void (^SelectCityBlock) (NSDictionary *dateDict);

@interface SelectCityViewController : MyViewController
@property (nonatomic, copy) SelectCityBlock selectCityCallBack;
@end
