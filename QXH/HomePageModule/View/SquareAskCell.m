//
//  SquareAskCell.m
//  QXH
//
//  Created by ZhaoLilong on 7/2/14.
//  Copyright (c) 2014 ZhaoLilong. All rights reserved.
//

#import "SquareAskCell.h"

@implementation SquareAskCell

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
    InfoModel *info = model.content;
    _contentLabel.text = info.content;
    [_askImg setImageWithURL:IMGURL(info.sphoto) placeholderImage:nil];
    _dateLabel.text = [model.date substringToIndex:10];
}

@end
