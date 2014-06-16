//
//  TribeDynamicViewController.h
//  QXH
//
//  Created by XUE on 14-5-21.
//  Copyright (c) 2014年 ZhaoLilong. All rights reserved.
//

#import "MyViewController.h"

@interface TribeDynamicViewController : MyViewController<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic, strong) NSDictionary *tribeInfoDict;//部落信息
@end
