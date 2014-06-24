//
//  SquareActivityCell.m
//  QXH
//
//  Created by xuey on 14-6-5.
//  Copyright (c) 2014年 ZhaoLilong. All rights reserved.
//

#import "SquareActivityCell.h"

@implementation SquareActivityCell

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setCellData:(SquareInfo *)model
{
    [_portraitView setImageWithURL:IMGURL(model.uphoto) placeholderImage:[UIImage imageNamed:@"img_portrait96"]];
    _nameLabel.text = model.uname;
    _postionLabel.text = model.uduty;
    SquareActInfo *actInfo = model.content;
    _contentLabel.text =actInfo.actname;
    _dateLabel.text = model.date;
}

@end
