//
//  ActivityCell.h
//  QXH
//
//  Created by ZhaoLilong on 14-5-4.
//  Copyright (c) 2014年 ZhaoLilong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ActivityCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *activityTitleLabel; // 活动标题标签
@property (weak, nonatomic) IBOutlet UILabel *activityTypeLabel; // 活动类型标签
@property (weak, nonatomic) IBOutlet UILabel *activityDescriptionLabel; // 活动描述标签
@property (weak, nonatomic) IBOutlet UIImageView *activityImage; // 活动图片
@property (weak, nonatomic) IBOutlet UILabel *tribeLabel;//部落标签
@property (weak, nonatomic) IBOutlet UILabel *orgnizerLabel; // 发起人标签
@property (weak, nonatomic) IBOutlet UILabel *timeLabel; // 时间标签
@property (weak, nonatomic) IBOutlet UILabel *addrLabel; // 地址标签
@property (weak, nonatomic) IBOutlet UIImageView *starView; // 星视图
@property (weak, nonatomic) IBOutlet UILabel *signUpLabel; // 报名标签
@property (weak, nonatomic) IBOutlet UILabel *followLabel; // 关注标签

@property (weak, nonatomic) IBOutlet UIImageView *activityStatus;//活动状态
@property (weak, nonatomic) IBOutlet UILabel *statusLabel;//活动状态标签

@end
