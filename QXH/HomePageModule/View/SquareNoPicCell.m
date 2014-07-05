//
//  SquareNoPicCell.m
//  QXH
//
//  Created by ZhaoLilong on 7/2/14.
//  Copyright (c) 2014 ZhaoLilong. All rights reserved.
//

#import "SquareNoPicCell.h"

@implementation SquareNoPicCell

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
    _nameLabel.text = model.uname;
    [_portraitView setImageWithURL:IMGURL(model.uphoto) placeholderImage:[UIImage imageNamed:@"img_portrait96"]];
    _commentLabel.text = model.uduty;
    InfoModel *tmpModel = (InfoModel *)model.content;
    _contentLabel.text = tmpModel.content;
}

@end
