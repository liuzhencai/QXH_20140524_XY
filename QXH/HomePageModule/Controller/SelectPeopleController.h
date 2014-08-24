//
//  SelectPeopleController.h
//  QXH
//
//  Created by ZhaoLilong on 14-8-2.
//  Copyright (c) 2014年 ZhaoLilong. All rights reserved.
//

#import "MyViewController.h"

typedef void (^SelPeopleBlock)(NSArray *);

@interface SelectPeopleController : MyViewController<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, copy) SelPeopleBlock callback;

@property (nonatomic, strong) NSMutableArray *selectedPerson;

@end
