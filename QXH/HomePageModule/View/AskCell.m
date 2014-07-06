//
//  AskCell.m
//  QXH
//
//  Created by ZhaoLilong on 14-5-5.
//  Copyright (c) 2014年 ZhaoLilong. All rights reserved.
//

#import "AskCell.h"

@implementation AskCell

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setCellData:(AskInfoModel *)model
{
    [_portraitView setImageWithURL:IMGURL(model.sphoto) placeholderImage:[UIImage imageNamed:@"img_portrait96"]];
    [_portraitView circular];
    _nameLbl.text = model.sname;
    _dateLbl.text = model.date;
    _contentLbl.text = model.content;
    _transmitLbl.text = [NSString stringWithFormat:@"浏览 %@",model.browsetime];
}

@end
