//
//  NameCardTitleCell.h
//  QXH
//
//  Created by XUE on 14-5-20.
//  Copyright (c) 2014年 ZhaoLilong. All rights reserved.
//

@protocol NameCardTitleDelegate <NSObject>

- (void)didSelectButtonWithIndex:(int)index;

@end

#import <UIKit/UIKit.h>

@interface NameCardTitleCell : UITableViewCell
@property (nonatomic, strong) UIImageView *headImgView;//头像
@property (nonatomic, strong) UILabel *name;//姓名
@property (nonatomic, strong) UILabel *duty;//职务
@property (nonatomic, strong) UILabel *phone;//电话
@property (nonatomic, strong) UILabel *email;//邮箱
@property (nonatomic, strong) UIButton *addFriend;//加为好友
@property (nonatomic, strong) UIButton *forwardCard;//转发名片
@property (nonatomic, assign) BOOL isMyFriend;//我的好友
@property (nonatomic, assign) id delegate;

- (void)resetCellParamDict:(id)objt;

@end
