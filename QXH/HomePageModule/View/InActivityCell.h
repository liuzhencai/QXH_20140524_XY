//
//  InActivityCell.h
//  QXH
//
//  Created by xuey on 14-5-28.
//  Copyright (c) 2014年 ZhaoLilong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NIAttributedLabel.h"
@interface InActivityCell : UITableViewCell

@property (strong, nonatomic)  UILabel *activityTitleLabel; // 活动标题标签
@property (strong, nonatomic)  UILabel *activityTypeLabel; // 活动类型标签
@property (strong, nonatomic)  UILabel *activityDescriptionLabel; // 活动描述标签
@property (strong, nonatomic)  UIImageView *activityImage; // 活动图片
@property (strong, nonatomic)  UILabel *tribeLabel;//部落标签
@property (strong, nonatomic)  UILabel *orgnizerLabel; // 发起人标签
@property (strong, nonatomic)  UILabel *timeLabel; // 时间标签
@property (strong, nonatomic)  UILabel *addrLabel; // 地址标签
@property (strong, nonatomic)  NIAttributedLabel *signUpLabel; // 报名标签
@property (strong, nonatomic)  NIAttributedLabel *followLabel; // 关注标签

@property (strong, nonatomic)  UIImageView *activityStatus;//活动状态
@property (strong, nonatomic)  UILabel *statusLabel;//活动状态标签

- (void)resetCellParamDict:(id)objt;

@end
