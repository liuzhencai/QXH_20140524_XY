//
//  MessageDetailCell.h
//  QXH
//
//  Created by XueYong on 7/9/14.
//  Copyright (c) 2014 ZhaoLilong. All rights reserved.
//

#import <UIKit/UIKit.h>
@class MessageDetailCell;
@protocol MessageDetailDelegate <NSObject>

- (void)selectButtonWithCell:(MessageDetailCell *)cell atIndex:(int)index;

@end

typedef enum {
    E_Message_Type_System = 0,//系统消息
    E_Message_Type_AddFriend = 3,//加好友申请
    E_Message_Type_AddFriendResult = 4,//处理请求好友申请
    E_Message_Type_AddTribe = 5,//加入部落申请
    E_Message_Type_AddTribeResult = 6,//处理部落加入申请
    E_Message_Type_OutTribe = 7,//完全退出部落
    E_Message_Type_InformSb = 12,//@某人，@某部落
}MessageType;

@interface MessageDetailCell : UITableViewCell
@property (nonatomic, assign) id delegate;
@property (nonatomic, strong) UIView *bgView;
@property (nonatomic, strong) UILabel *title;
@property (nonatomic, strong) UIImageView *headImageView;
@property (nonatomic, strong) UILabel *textDes;

@property (nonatomic, strong) UIButton *agreeBtn;//同意
@property (nonatomic, strong) UIButton *refuseBtn;//拒绝

@property (nonatomic, strong) NSMutableDictionary *dealMessages;//处理过的消息
- (void)resetCellParamDict:(id)objt;

@end
