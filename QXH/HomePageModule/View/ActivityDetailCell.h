//
//  ActivityDetailCell.h
//  QXH
//
//  Created by XueYong on 6/10/14.
//  Copyright (c) 2014 ZhaoLilong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ActivityDetailCell : UITableViewCell

@property (weak, nonatomic)  UILabel *activityTitleLabel; // 活动标题标签
@property (weak, nonatomic)  UILabel *activityTypeLabel; // 活动类型标签
@property (weak, nonatomic)  UILabel *activityDescriptionLabel; // 活动描述标签
@property (weak, nonatomic)  UIImageView *activityImage; // 活动图片
@property (weak, nonatomic)  UILabel *tribeLabel;//部落标签
@property (weak, nonatomic)  UILabel *orgnizerLabel; // 发起人标签
@property (weak, nonatomic)  UILabel *timeLabel; // 时间标签
@property (weak, nonatomic)  UILabel *addrLabel; // 地址标签
//@property (weak, nonatomic)  UILabel *signUpLabel; // 报名标签
//@property (weak, nonatomic)  UILabel *followLabel; // 关注标签
//
//@property (weak, nonatomic)  UIImageView *activityStatus;//活动状态
//@property (weak, nonatomic)  UILabel *statusLabel;//活动状态标签

- (void)resetCellParamDict:(id)objt;
@end
