//
//  MyMessageCell.h
//  QXH
//
//  Created by XueYong on 5/19/14.
//  Copyright (c) 2014 ZhaoLilong. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    E_Message_Type_System = 0,//系统消息
    E_Message_Type_AddFriend = 3,//加好友申请
    E_Message_Type_AddFriendResult = 4,//处理请求好友申请
    E_Message_Type_AddTribe = 5,//加入部落申请
    E_Message_Type_AddTribeResult = 6,//处理部落加入申请
    E_Message_Type_OutTribe = 7,//完全退出部落
    E_Message_Type_InformSb = 12,//@某人，@某部落
    
}MessageType;

@interface MyMessageCell : UITableViewCell

@property (nonatomic, strong) UIImageView *headImgView;
@property (nonatomic, strong) UILabel *name;
@property (nonatomic, strong) UILabel *duty;
@property (nonatomic, strong) UILabel *date;
@property (nonatomic, strong) UIImageView *arrowImgView;
@property (nonatomic, strong) UIImageView* countImage;
@property (nonatomic, strong) UILabel* countlabel;

- (void)resetCellParamDict:(id)objt;
@end
