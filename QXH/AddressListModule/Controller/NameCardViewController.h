//
//  NameCardViewController.h
//  QXH
//
//  Created by XueYong on 5/16/14.
//  Copyright (c) 2014 ZhaoLilong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ChatController.h"

@interface NameCardViewController : MyViewController
{
    ChatController* chat;
}
@property (nonatomic, assign) BOOL isMyFriend;
@property (nonatomic, strong) NSDictionary *memberDict;
@property (nonatomic, strong) NSString *memberId;//
@end
