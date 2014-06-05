//
//  PersonalInfoController.h
//  QXH
//
//  Created by ZhaoLilong on 14-5-4.
//  Copyright (c) 2014年 ZhaoLilong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PersonalInfoController : MyViewController<UITableViewDataSource, UITableViewDelegate>
{
    NSArray *titleArray;
}
@property (weak, nonatomic) IBOutlet UITableView *meTable;

@end
