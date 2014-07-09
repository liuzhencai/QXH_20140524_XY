//
//  MessageDetailCell.h
//  QXH
//
//  Created by XueYong on 7/9/14.
//  Copyright (c) 2014 ZhaoLilong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MessageDetailCell : UITableViewCell
@property (nonatomic, strong) UILabel *title;
@property (nonatomic, strong) UIImageView *headImageView;
@property (nonatomic, strong) UILabel *textDes;

@property (nonatomic, strong) UIButton *agreeBtn;//同意
@property (nonatomic, strong) UIButton *refuseBtn;//拒绝
@end
