//
//  TribeController.h
//  QXH
//
//  Created by XueYong on 5/20/14.
//  Copyright (c) 2014 ZhaoLilong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ChatRoomController.h"

@interface TribeController : MyViewController
{
    /*多次接受通知，改为唯一*/
    ChatRoomController *chatview;
}
@property (strong, nonatomic)  UISearchBar *searchBar;
@end
