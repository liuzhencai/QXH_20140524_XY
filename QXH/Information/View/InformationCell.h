//
//  InformationCell.h
//  QXH
//
//  Created by liuzhencai on 14-5-13.
//  Copyright (c) 2014年 ZhaoLilong. All rights reserved.
//  资讯cell

#import <UIKit/UIKit.h>

@interface InformationCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

- (void)setModel:(InfoModel *)model;

@end
