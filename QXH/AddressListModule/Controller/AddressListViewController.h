//
//  AddressListsViewController.h
//  QXH
//
//  Created by XueYong on 5/18/14.
//  Copyright (c) 2014 ZhaoLilong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ChatController.h"
typedef void (^AddressListCallBlock) (NSDictionary *dict);
@interface AddressListViewController : MyViewController<UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate>
{
    UITableView* myMessageTable;
    UITableView *addressListTable;
    
    /*内存释放有问题*/
    ChatController* chat;
}

@property (nonatomic, strong)  UISearchBar *searchBar;
@property (nonatomic, copy) AddressListCallBlock addressListBlock;

@end
