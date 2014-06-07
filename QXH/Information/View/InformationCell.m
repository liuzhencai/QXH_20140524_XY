//
//  InformationCell.m
//  QXH
//
//  Created by liuzhencai on 14-5-13.
//  Copyright (c) 2014年 ZhaoLilong. All rights reserved.
//

#import "InformationCell.h"

@implementation InformationCell

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setModel:(InfoModel *)model
{
    self.titleLabel.text = model.title;
    self.dateLabel.text = model.date;
    self.contentLabel.text = model.content;
}

@end
