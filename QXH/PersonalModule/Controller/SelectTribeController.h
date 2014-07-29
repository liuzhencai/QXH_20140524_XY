//
//  SelectTribeController.h
//  QXH
//
//  Created by ZhaoLilong on 7/19/14.
//  Copyright (c) 2014 ZhaoLilong. All rights reserved.
//

#import "MyViewController.h"
#import "MJRefresh.h"
#import "MyCardController.h"

typedef void (^SelectTribeBlock) (MyTribeModel *model);

typedef NS_ENUM(NSInteger, SelectType) {
    SelectTypeNameCard = 0,                         // no button type
    SelectTypeInfTrans
};

@interface SelectTribeController : MyViewController<UITableViewDataSource, UITableViewDelegate>
{
    
}
@property (weak, nonatomic) IBOutlet UITableView *tribeTbl;
@property (nonatomic, assign) id parentController;
@property (nonatomic, assign) SelectType type;
@property (nonatomic, copy) SelectTribeBlock callback;

@end
